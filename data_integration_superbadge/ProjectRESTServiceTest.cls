@isTest
private class ProjectRESTServiceTest {
    @testSetup
    static void loadServiceData(){
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.DeliveryInstallationStatus__c = 'In progress';
        opp.CloseDate = (Date.today()).addDays(20);
        opp.StageName = 'Submitted Project';
        
        INSERT opp;
        
        
        Project__c prjt = new Project__c();
        prjt.ProjectRef__c = 'ProjectRef';
        prjt.Name = 'ProjectName';
        prjt.Opportunity__c = opp.Id;
        prjt.Start_Date__c = Date.today();
        prjt.End_Date__c = (Date.today()).addDays(10);
        prjt.Billable_Amount__c = 1000;
        prjt.Status__c = 'Running';
        
        INSERT prjt;
    
    }
    
    @isTest    
    static void testProjectRESTService(){
        Project__c prjt = [SELECT Id, ProjectRef__c, Name, Opportunity__c, Start_Date__c, End_Date__c, Billable_Amount__c, Status__c
                            FROM Project__c LIMIT 1];
    
        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        System.assertEquals(1,[SELECT count() FROM Opportunity]);                          
        String returnMessage = ProjectRESTService.postProjectData('ProjectRef', 'ProjectName', String.valueOf(opp.Id),
                                       Date.today(), Date.today(), 1000, 'Running');                          
        Test.stopTest();
    }
}