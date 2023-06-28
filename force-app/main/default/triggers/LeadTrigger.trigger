trigger LeadTrigger on Lead (after insert,before insert) {
    if(trigger.isAfter && trigger.isInsert){
      // DeleteAccountBulk.CheckDuplicatedLead(trigger.new,trigger.oldMap);
       //DeleteAccountBulk.BeforeDeleteCheck(trigger.new,trigger.oldmap);
         testclass.AfterInsert(trigger.new);
        testclass.sendEmailToLead(trigger.new);
    }
    if(trigger.isBefore && trigger.isInsert){
       // DeleteAccountBulk.BeforeDeleteCheck(trigger.new,trigger.oldmap);
    }
}