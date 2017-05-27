/**
 * Created by skvarma on 2017-05-25.
 */

global class ProjectCalloutService {

    @InvocableMethod(label='Post OPP to PMS' description='Post Opp to PMS')
    public static void PostOpportunityToPMS(List<Id> oppIdLst){

        QueueablePMSCall pmsCall = new QueueablePMSCall(oppIdLst[0]);
        System.enqueueJob(pmsCall);
    }



    global class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts{

        private Id oppId;

        QueueablePMSCall(Id oppId){
            this.oppId = oppId;
        }

        global void execute(QueueableContext qc){
            Opportunity opp = [SELECT Id, Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE id = :oppId LIMIT 1];
            String pmsToken = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;
            System.debug('PMS Token = ' + pmsToken);
            Http http = new Http();
            HttpRequest httpRequest = new HttpRequest();

            httpRequest.setEndpoint('callout:ProjectService');
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setHeader('token',pmsToken);
            //httpRequest.setBody('{"opportunityId": "0066A0000025l46QAA","opportunityName": "Super-Duper Big Deal","accountName": "ACME Corp, Inc.","closeDate": "2017-4-30","amount": 150000}');
            PMSProjectObj pmsObj = new PMSProjectObj(opp.Id, opp.Name, opp.Account.Name, opp.CloseDate, opp.Amount);
            httpRequest.setBody(JSON.serialize(pmsObj));
            System.debug('HttpRequestBody = ' + httpRequest.getBody());
            HttpResponse httpResponse = http.send(httpRequest);

            if (httpResponse.getStatusCode() != 201){
                system.debug('Unexpected Status Code' + httpResponse.getStatus());
                System.debug('Status code = ' + httpResponse.getStatusCode());
                opp.StageName = 'Resubmit Project';
            } else{
                system.debug('Response = ' + httpResponse.getBody());
                opp.StageName = 'Submitted Project';
            }
            update opp;
        }
    }



    public class pmsProjectObj{
        Id opportunityId;
        String opportunityName;
        String accountName;
        Date closeDate;
        Decimal amount;

        public PMSProjectObj(Id opportunityId, String opportunityName, String accountName, Date closeDate, Decimal amount){
            this.opportunityId = opportunityId;
            this.opportunityName = opportunityName;
            this.accountName = accountName;
            this.closeDate = closeDate;
            this.amount = amount;
        }


    }

}