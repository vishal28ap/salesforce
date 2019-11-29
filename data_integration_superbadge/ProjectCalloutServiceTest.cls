@isTest
private class ProjectCalloutServiceTest {
  //Implement mock callout tests here
  @testSetup
    static void setup(){
        Account a = new Account();
        a.Name='Test Account';
        insert a;
        Opportunity o= new opportunity();
        o.Name='Test Opportunity';
        o.StageName='Prospecting';
        o.CloseDate=system.today();
        o.AccountId=a.Id;
        o.Amount=150000;
        o.Type='New Project';
        insert o;
    }
    @isTest
    static void successCall(){
        Opportunity opp=[select id, name from opportunity where name='Test Opportunity'];
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        opp.StageName='Closed Won';
        Test.startTest();
        update opp;
        Test.stopTest();
        Opportunity o = [SELECT StageName From Opportunity WHERE ID =:opp.Id];
        system.assertEquals('Submitted Project',o.StageName);   
    }
        @isTest
    static void failCall(){
        Opportunity opp=[select id, name from opportunity where name='Test Opportunity'];
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        opp.StageName='Closed Won';
        Test.startTest();
        update opp;
        Test.stopTest();
        Opportunity o = [SELECT StageName From Opportunity WHERE ID =:opp.Id];
        system.assertEquals('Resubmit Project',o.StageName);   
    }
}