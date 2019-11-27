public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        //ToDo: complete this method to make the callout (using @future) to the
        //      REST endpoint and update equipment on hand.
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
            List<Product2> prod = new list<product2>();
            for (Object o: results){
                Map<String, Object> results2 = (Map<String, Object>) o;
                Product2 prod1 = new Product2();
                prod1.Replacement_Part__c=true;
                prod1.Cost__c=Integer.valueOf(results2.get('cost'));
                prod1.Current_Inventory__c=Integer.valueOf(results2.get('quantity'));
                prod1.Lifespan_Months__c=Integer.valueOf(results2.get('lifespan'));
                prod1.Maintenance_Cycle__c=Integer.valueOf(results2.get('maintenanceperiod'));
                prod1.Warehouse_SKU__c=String.valueOf(results2.get('sku'));
                prod1.ProductCode = (String)results2.get('_id');
                prod1.Name = (String) results2.get('name');
                prod.add(prod1);         
            }
            if (prod.size()>0){
                upsert prod Warehouse_SKU__c;
            }
        }
    }
}