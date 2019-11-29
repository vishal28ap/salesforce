public class ProjectCalloutService {
    //??Invocable method so it can be used in Process Builder
	@InvocableMethod(label='Insert Opportunity' description='Inserts the opportunity')
	public static void postOpportunityToPMS(List<id> oppList){
        	List<opportunity> oppidlist=[select id,name,CloseDate,Amount from opportunity where id in :opplist Limit 1];
        	ID jobID = System.enqueueJob(new QueueablePMSCall(oppidlist));
    }
    //Key-value pair of opportunity data to be converted in JSON
    public static Map<String,Object> mapData(opportunity opp){
        Map<String,Object> mapdata = new Map<String,Object>();
        mapdata.put('opportunityId',string.valueOf(opp.Id));
        mapdata.put('opportunityName',string.valueOf(opp.Name));
        mapdata.put('accountName', String.valueOf([select Account.name from opportunity where id=:opp.Id]) );
        mapdata.put('closeDate', String.valueOf(opp.CloseDate.year())+'-'+String.valueOf(opp.CloseDate.month())+'-'+String.valueOf(opp.CloseDate.day()));
        mapdata.put('amount',opp.Amount);
        return mapdata;
    }
    //POST data to external service in JSON
    public static void postPMS(List<Opportunity> oppidlist){
        Opportunity opp=new Opportunity();
        opp=oppidlist[0];
        ServiceTokens__c token= ServiceTokens__c.getValues('ProjectServiceToken');//Servicetoken object Data taken from Custom Settings
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:ProjectService/'+ token); //ProjectService Connected App in App Manager(trailhead)
        request.setHeader( 'Content-Type', 'application/json' );
        String body=JSON.serialize(mapData(opp)); //convert map to JSON
        request.setBody(body);
        HttpResponse response = http.send(request);
        if(response.getStatusCode()==201){
           	opp.stagename='Submitted Project';
        }
        else{
           	opp.stagename='Resubmit Project';
        }
        update opp;
    }
    //Queable Inner Class. First method(constructor) should always be same as class name that is called in system.enqueue job
    //Database.AllowsCallouts used to allow API callouts
    public class QueueablePMSCall implements Queueable,Database.AllowsCallouts{
	private List<Opportunity> oppidlist; //declare the list as private to class to be called
        public QueueablePMSCall(List<opportunity> oppidlist) {
        	this.oppidlist=oppidlist; //declare input parameter as local variable
    	}
	public void execute(QueueableContext context) {
        	postPMS(oppidlist);
		}
    }
}
