@isTest
private class MaintenanceRequestTest {
    //negative test
    @isTest static void negativeTestWithCycleDays() {       
        Account acct = new Account(Name= 'testAcct');
        insert acct;
        Contact cont = new Contact(LastName = 'contactTest', AccountID = acct.id, email = 'testcont@test.com');
        insert cont;
        Product2 prd1 = new Product2(Name = 'ProductTest1', Maintenance_Cycle__c = 2, Replacement_Part__c = true);
        insert prd1;
        Vehicle__c vhcl1 = new Vehicle__c(Name = 'VehicleTest1');
        insert vhcl1;             
        Case MntRequest = new Case(description = 'test123',
                                Subject = 'Other',
                                Type = 'Other',
                                Status = 'Working',
                                origin = 'Web',
                                Date_Reported__c = date.today(),
                                Date_Due__c = date.today(),
                                Vehicle__c = vhcl1.id,
                                Equipment__c = prd1.id);         
        insert MntRequest;      
        Work_Part__c wp1 = new Work_Part__c(Equipment__c = prd1.Id, Maintenance_Request__c = MntRequest.id);       
        insert wp1;       
        MntRequest.Status = 'Closed';
        Test.startTest();  
        update MntRequest; 
        Test.stopTest();
        system.assertEquals(0, [select count() from case where case.status='New']);
           
        }
    //positive test
    @isTest static void TestWithCycleDays() {       
        Account acct = new Account(Name= 'testAcct');
        insert acct;
        Contact cont = new Contact(LastName = 'contactTest', AccountID = acct.id, email = 'testcont@test.com');
        insert cont;
        Product2 prd1 = new Product2(Name = 'ProductTest1', Maintenance_Cycle__c = 2, Replacement_Part__c = true);
        insert prd1;
        Vehicle__c vhcl1 = new Vehicle__c(Name = 'VehicleTest1');
        insert vhcl1;             
        Case MntRequest = new Case(description = 'test123',
                                Subject = 'Other',
                                Type = 'Repair',
                                Status = 'Working',
                                origin = 'Web',
                                Date_Reported__c = date.today(),
                                Date_Due__c = date.today(),
                                Vehicle__c = vhcl1.id,
                                Equipment__c = prd1.id);
        insert MntRequest;
        Work_Part__c wp1 = new Work_Part__c(Equipment__c = prd1.Id, Maintenance_Request__c = MntRequest.id);        
        insert wp1;
        MntRequest.Status = 'Closed';        
        Test.startTest();  
        update MntRequest; 
        Test.stopTest();
        system.assertEquals(1, [select count() from case where case.status='New']); 
           
        }
    //bulk test
    @isTest static void testCaseBulkInsert(){
        Account acct = new Account(Name= 'testAcct');
        insert acct;
        Contact cont = new Contact(LastName = 'contactTest', AccountID = acct.id, email = 'testcont@test.com');
        insert cont;
        Product2 prd1 = new Product2(Name = 'ProductTest1', Maintenance_Cycle__c = 2, Replacement_Part__c = true);
        insert prd1;
        Vehicle__c vhcl1 = new Vehicle__c(Name = 'VehicleTest1');
        insert vhcl1;
        List<Case> testCaseList = new List<Case>();
        For(Integer i=0 ;i<300 ; i++) {
           Case MntRequest = new Case(description = 'test123'+i,
                                Subject = 'Other',
                                Type = 'Repair',
                                Status = 'New',
                                origin = 'Web',
                                Date_Reported__c = date.today(),
                                Date_Due__c = date.today(),
                                Vehicle__c = vhcl1.id,
                                Equipment__c = prd1.id);
            testCaseList.add(MntRequest);
        }
        insert testCaseList;
        List<Work_Part__c> wpList=new List<Work_Part__c>();
        for (Integer i=0;i<testCaseList.size();i++){
                                                Work_Part__c wpn = new Work_Part__c(Equipment__c = prd1.Id, Maintenance_Request__c = testCaseList[i].id);
            wpList.add(wpn);
        }
        insert wpList;
        for (Case k:testCaseList){
               k.Status = 'Closed'; 
        }
        Test.startTest();  
        update testCaseList; 
        Test.stopTest();
        system.assertEquals(300, [select count() from case where case.status='New']);
    }   
}