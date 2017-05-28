@isTest
private class ProjectCalloutServiceTest {


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

      ServiceTokens__c token = new ServiceTokens__c(name='ProjectServiceToken',token__c='12345');
      insert token;

  }

  @isTest
  static void testProjectSubmitted(){
      Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
      Opportunity opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];

      Test.startTest();
        opp.StageName = 'Closed Won';
        update opp;
      Test.stopTest();

      Opportunity updatedOpp = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id LIMIT 1];

      System.assertEquals('Submitted Project',updatedOpp.StageName,'Stage should have been updated to Submitted Project.');
  }

    @isTest
    static void testProjectNotSubmitted(){
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        Opportunity opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];

        Test.startTest();
        opp.StageName = 'Closed Won';
        update opp;
        Test.stopTest();

        Opportunity updatedOpp = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id LIMIT 1];

        System.assertEquals('Resubmit Project',updatedOpp.StageName,'Stage should have been updated to Resubmit Project.');
    }

}