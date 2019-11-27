global class WarehouseSyncSchedule implements Schedulable{
    global void execute(System.SchedulableContext context){
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }
}