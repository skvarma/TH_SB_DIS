/**
 * Created by skvarma on 2017-07-04.
 */

public with sharing class BillingCalloutService {


    public void callBillingService(List<Project__c> newProjectLst, Map<Id, Project__c> oldProjectMap){

        List<Project__c> prjLst = new List<Project__c>();
            for (Project__c prj : newProjectLst){
                if ((prj.Status__c == 'Billable') && (prj.Status__c <> ((Project__c)oldProjectMap.get(prj.Id)).Status__c)){
                    prjLst.add(prj);
                    callService(prj.ProjectRef__c,prj.Billable_Amount__c);
                }
            }
    }

    @future (callout=true)
    public static void callService(String projectRef, Decimal billAmount){
        ServiceCredentials__c serviceCredentials = ServiceCredentials__c.getValues('BillingServiceCredential');
        System.debug(serviceCredentials.Username__c);
        System.debug(serviceCredentials.Password__c);
        System.debug(projectRef);
        System.debug(billAmount);
        BillingServiceProxy.project billingServiceProject = new BillingServiceProxy.project();
        billingServiceProject.projectRef = projectRef;
        billingServiceProject.username = serviceCredentials.Username__c;
        billingServiceProject.password = serviceCredentials.Password__c;
        billingServiceProject.billAmount = billAmount;

        BillingServiceProxy.InvoicesPortSoap11 billingService = new BillingServiceProxy.InvoicesPortSoap11();
        String response = billingService.billProject(billingServiceProject);

        //System.debug('Response =  ' + response);
        if (response == 'ok'){

            Project__c project = [SELECT Id, Status__c FROM Project__c LIMIT 1];
            //project.ProjectRef__c = projectRef;
            project.Status__c = 'Billed';
            update project;
        }


    }

}