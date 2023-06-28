trigger TriggerOnTask on Task (before insert,after insert, before update,after update,after delete,before delete,after undelete) {

    if(trigger.isBefore && trigger.isInsert){
        System.debug('Before Insert');
        TriggerHandlerClass.updateTaskPriority(trigger.new, trigger.newmap,trigger.old,trigger.oldMap);
    }
    if(trigger.isBefore && trigger.isUpdate){
        System.debug('Before Update');
        TriggerHandlerClass.updateTaskPriority(trigger.new, trigger.newmap,trigger.old,trigger.oldMap);
    }
}