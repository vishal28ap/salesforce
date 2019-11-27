public class MaintenanceRequestHelper {
        
    public static void updateWorkOrders(List<Case> closedCase){  
        Map<Id, Date> mainCycleDays = getMainDate();
   		List<Case> newCase = new List<Case>();
    		for (Case newCase2 : closedCase) {
            			newCase.add(new Case(type = 'Routine Maintenance',
                                status = 'New',
                                origin = 'Web',
                                Subject = 'Reminder',
                                Date_Reported__c = date.today(),
                                Vehicle__c = newCase2.Vehicle__c,
                                Equipment__c = newCase2.Equipment__c,
                                Date_Due__c = mainCycleDays.get(newCase2.id)));   
        	}
        insert newCase;
        List<Work_part__c> wpList= New List<Work_part__c>();
        for (Case newC: newCase){
            Work_part__c wp=new Work_Part__c();
            wp.Maintenance_Request__c =newC.id;
        }
        insert wpList;
    }
    
    private static Map<ID, Date> getMainDate(){
        List<Case> closedCase = [select ID from Case Where status = 'Closed' and Type IN ('Repair', 'Routine Maintenance')];
        Map<id,AggregateResult> minCycleDay2 = new Map<id,AggregateResult>([Select Maintenance_Request__r.id,min(Equipment__r.Maintenance_Cycle__c) day FROM Work_Part__c WHERE Equipment__r.Maintenance_Cycle__c != null AND Maintenance_Request__c IN :closedCase group by Maintenance_Request__r.id]);
		Map<id,Date> minCycleDay3 = new Map<id,Date>();
		for (case c1:closedCase){
			Integer days = integer.valueOf(minCycleDay2.get(c1.id).get('day'));
			Date newDateCycle=date.today()+days;
			minCycleDay3.put(c1.id,newDateCycle);
        }
		return minCycleDay3;
    }
}