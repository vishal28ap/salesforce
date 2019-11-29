public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
	@InvocableMethod(label='Insert Opportunity' description='Inserts the opportunity')
	public static void postOpportunityToPMS(List<id> oppList){
        List<opportunity> oppidlist=[select id from opportunity where id in :opplist Limit 1];
        ID jobID = System.enqueueJob(new QueueablePMSCall(oppidlist));
    }
    
    public class QueueablePMSCall implements Queueable,Database.AllowsCallouts{
		private List<Opportunity> oppidlist;
        Public Map<String,Object> listr = new Map<String,Object>();
        public QueueablePMSCall(List<opportunity> oppidlist) {
        	Opportunity opp = new Opportunity();
        	opp=oppidlist[0];
        	listr.put('opportunityId',opp.Id);
        	listr.put('opportunityName',opp.Name);
        	listr.put('accountName',[select Account.name from opportunity where id=:opp.Id]);
        	listr.put('closeDate',opp.CloseDate);
        	listr.put('amount',opp.Amount);   
    	}
		public void execute(QueueableContext context) {
            ServiceTokens__c token= ServiceTokens__c.getValues('ProjectServiceToken');
            string finalToken=token.Token__c;
        	Http http = new Http();
        	HttpRequest request = new HttpRequest();
        	request.setMethod('POST');
        	request.setEndpoint('callout:ProjectService/'+ finalToken); //ProjectService external app in Amm Manager(trailhead)
        	request.setHeader( 'Content-Type', 'application/json' );
        	String body=JSON.serialize(listr);
        	request.setBody(body);
        	HttpResponse response = http.send(request);
        	Opportunity opp1 = new Opportunity();
        	opp1=oppidlist[0];
        	if(response.getStatusCode()==201){
            	opp1.stagename='Submitted Project';
            	upsert opp1;
        	}
        	else{
            	opp1.stagename='Resubmit Project';
            	upsert opp1;
        	}
		}
    }
}
