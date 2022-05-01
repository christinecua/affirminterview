trigger ContactTrigger on Contact (before insert, before update) {
    
    ContactTriggerHandler contacthandler = new ContactTriggerHandler();

    if(Trigger.isBefore) {
        if (Trigger.isInsert){
            contacthandler.beforeInsert(Trigger.new);
        }
        else if (Trigger.isUpdate){
            contacthandler.beforeUpdate(Trigger.new);
        }
    }
}