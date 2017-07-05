@isTest
private class BillingCalloutServiceTest {

    @isTest
    public static void testBillingUpdateSuccess(){
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock() );

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Project__c project = new Project__c();
        project.Status__c = 'running';
        project.ProjectRef__c = '123456';
        project.Billable_Amount__c = 123456.12;
        project.Opportunity__c = opp.Id;
        insert project;

        Test.startTest();
        project.Status__c = 'Billable';
        update project;
        Test.stopTest();

        Project__c updatedProject = [SELECT Id,Status__c FROM Project__c LIMIT 1];
        System.assertEquals('Billed', updatedProject.Status__c, 'Project Status did not update to billed');

  }
    @isTest
    public static void testBillingUpdateFailure(){
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure() );

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Project__c project = new Project__c();
        project.Status__c = 'running';
        project.ProjectRef__c = '123456';
        project.Billable_Amount__c = 123456.12;
        project.Opportunity__c = opp.Id;
        insert project;

        Test.startTest();
        project.Status__c = 'Billable';
        update project;
        Test.stopTest();

        Project__c updatedProject = [SELECT Id,Status__c FROM Project__c LIMIT 1];
        System.assertNotEquals('Billed', updatedProject.Status__c, 'Project Status updated to billed');

    }


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

        ServiceCredentials__c serviceCredentials = new ServiceCredentials__c();
        serviceCredentials.Name = 'BillingServiceCredential';
        serviceCredentials.Username__c = 'user';
        serviceCredentials.Password__c = 'pwd';

        insert serviceCredentials;
    }


}