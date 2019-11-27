@isTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @istest
    static void getCallout(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        List<Product2> prod =[Select id from Product2 where Replacement_Part__c=True];
        System.assertEquals(22, prod.size());    
    }
    static testmethod void testScheduledJob(){
        String CRON_EXP = '0 0 1 * * ?';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        String jobId = System.schedule('ScheduledApexTest',CRON_EXP, new WarehouseSyncSchedule());
        Test.stopTest();
        CronTrigger cTId = [SELECT State FROM CronTrigger WHERE Id = :jobID];
        System.assertEquals('WAITING', String.valueOf(cTId.State), 'jobID Doesnt Match');
    }
}