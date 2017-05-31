/**
 * Created by skvarma on 2017-05-30.
 */
@isTest
private class ProjectRESTServiceTest {

    @testSetup
    static void setup(){
        Account acct = new Account(name='Test Account');
        insert acct;

        Opportunity opp = new Opportunity();
        opp.AccountId = acct.Id;
        opp.Name = 'Test Opp';
        opp.Type = 'New Project';
        opp.CloseDate = Date.today();
        opp.StageName = 'Prospecting';
        opp.Amount = 2000;
        insert opp;
    }

    @isTest
    static void testProjectServiceSucess() {

        //ProjectRESTService projectSvc = new ProjectRESTService();
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        String svcRes = ProjectRESTService.postProjectData('','Test Project',Opp.Id, Date.today(), Date.today()+20,10000,'Running');

        Opportunity oppValidate = [SELECT Id,DeliveryInstallationStatus__c FROM Opportunity LIMIT 1];
        Project__c project = [SELECT Id,Name FROM Project__c LIMIT 1];

        System.assertEquals('OK',svcRes,'Incorrect Status returned');
        System.assertEquals('In Progress', oppValidate.DeliveryInstallationStatus__c, 'Incorrect Installation Status on Opp');
        System.assertEquals('Test Project', project.Name, 'Incorrect Project Name');

    }

    @isTest
    static void testProjectServiceFailure() {

        //ProjectRESTService projectSvc = new ProjectRESTService();
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        String svcRes = ProjectRESTService.postProjectData('','Test Project',Opp.Id, Date.today(), Date.today()+20,10000,'XYZ');

        Opportunity oppValidate = [SELECT Id,DeliveryInstallationStatus__c FROM Opportunity LIMIT 1];
        //Project__c project = [SELECT Id,Name FROM Project__c LIMIT 1];

        System.assertEquals('Error',svcRes,'Incorrect Status returned');
        System.assertEquals(null, oppValidate.DeliveryInstallationStatus__c, 'Incorrect Installation Status on Opp');
        System.assertEquals(0, [SELECT count() FROM Project__c], 'N project should exist');

    }


}