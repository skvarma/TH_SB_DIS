/**
 * Created by skvarma on 2017-05-29.
 */

@RestResource(UrlMapping='/project/*')
global with sharing class ProjectRESTService {

    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status){
        String returnMsg = 'Blank';
        //Case thisCae = new Case(Subject=subject, Status=status, Origin=origin, Priority=priority);
        //insert thisCae;

        Project__c project = new Project__c();
        project.ProjectRef__c = ProjectRef;
        project.Name = ProjectName;
        project.Opportunity__c = OpportunityId;
        project.Start_Date__c = StartDate;
        project.End_Date__c = EndDate;
        project.Billable_Amount__c = Amount;
        project.Status__c = Status;

        Opportunity opp = new Opportunity();
        opp.Id = OpportunityId;
        opp.DeliveryInstallationStatus__c = 'In Progress';


        Savepoint sp = Database.setSavepoint();

        try{
            upsert project;
            update opp;
            returnMsg = 'OK';

        }Catch (DmlException ex){
            returnMsg = 'Error';
            Database.rollback(sp);
        }

        return returnMsg;
    }

}