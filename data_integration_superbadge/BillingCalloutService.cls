global with sharing class BillingCalloutService {
    //Implement business and callout logic methods here
    @future(callout=true)
    webservice static void  callBillingService(List<id> proList) {
        Project__c p1=new Project__c();
        Project__c p2=new Project__c();
        List<Project__c> projectList=new List<Project__c>();
        List<Project__c> projectList1=new List<Project__c>();
        for (Id i:prolist){
            p1=[select ProjectRef__c from Project__c where id=:i];
            projectList.add(p1);
            p2=[select Billable_Amount__c from Project__c where id=:i];
            projectList1.add(p2);
        }
        ServiceCredentials__c username=ServiceCredentials__c.getvalues('Username__c');
        String un=String.valueOf(username);
        ServiceCredentials__c password=ServiceCredentials__c.getvalues('Password__c');
        String pw=String.valueOf(password);
        String projectid=String.valueOf(projectList[0]);
        Double billamt=Double.valueOf(projectList[0]);
        BillingServiceProxy.project project = new BillingServiceProxy.project();
        project.projectid = projectid;
        project.billAmount = billamt;
        project.username = un;
        project.password = pw;
        BillingServiceProxy.InvoicesPortSoap11 invoiceCall = new BillingServiceProxy.InvoicesPortSoap11();
        // Make the callout and update the Status if callout is successful
        String response = invoiceCall.billProject(project);
        List<Project__c> projects = new List<Project__c>();
        if(response!=null && response.equalsIgnoreCase('OK')){
            projects = [Select Id, Status__c From Project__c Where ProjectRef__c = :projectid];
        }
        if (projects.size()>0){
            projects[0].Status__c = 'Billed';
            update projects;
        }
    }
}