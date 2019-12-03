@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here
  @testSetup
    static void setup(){
        Account a = new Account();
        a.name='Test Account';
        Opportunity o = new Opportunity();
        o.name='Test Opportunity';
        o.StageName='Prospecting';
        o.AccountId=a.id;
        o.CloseDate=system.today();
        insert o;
        Project__c p = new Project__c();
        p.Billable_Amount__c=100000;
        p.Name='Test Project';
        p.End_Date__c=system.today();
        p.Opportunity__c=o.id;
        p.Status__c='Running';
        insert p;
    }
    @isTest static void testCalloutPass() {
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        Project__c p1=[Select Status__c from Project__c where name='Test Project'];
        test.startTest();
        p1.Status__c='Billable';
        update p1;
        test.stopTest();
        Project__c p2=[Select Status__c from Project__c where name='Test Project'];
        system.assertEquals('Billed',p2.Status__c ); 
    }
    @isTest static void testCalloutFail() {
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        Project__c p1=[Select Status__c from Project__c where name='Test Project'];
        test.startTest();
        p1.Status__c='Billable';
        update p1;
        test.stopTest();
        Project__c p2=[Select Status__c from Project__c where name='Test Project'];
        system.assertEquals('Billable',p2.Status__c ); 
    }
}