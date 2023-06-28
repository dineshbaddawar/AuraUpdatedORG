trigger BlockMoreThan2ContactsOnAccount on Contact (after insert) {
    
    
    
    
      if(trigger.isAfter && trigger.isInsert){
        TestCode.SendCustomNotification(trigger.new);
    }
    
    Set<Id> accountIds = new Set<Id>();
    for(Contact record: Trigger.new) {
        accountIds.add(record.AccountId);
    }
    System.debug('accountIds ::'+accountIds);
    accountIds.remove(null);
    Set<Id> morethan2Contacts = new Map<Id, AggregateResult>([SELECT AccountId Id FROM Contact WHERE AccountId = :accountIds GROUP BY AccountId HAVING COUNT(Id) > 1]).keySet();
    System.debug('morethan2Contacts ::'+morethan2Contacts);
    for(Contact record: Trigger.new) {
        if(moreThan2Contacts.contains(record.AccountId)) {
            record.AccountId.addError('You may not have more than 1 contacts per account.');
        }
    }
    
    /* Example 2
    trigger ContactTrigger on Contact (after insert, before Insert, before update, after update) {
    if ((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter) {
        Set<Id> setofAccountId = new Set<Id>();
        for(Contact objCon : trigger.new)
            setofAccountId.add(objCon.accountid)
        //Get all account contact related values
        Map<Id,Account> mapofAccIdToContacts = new Map<Id,Account>([Select Id,(Select Id From Contacts) From Account Where Id IN : setofAccountId]);
        for(Contact objCon : trigger.new){
            if(mapofAccIdToContacts.containskey(objCon.accountID) && mapofAccIdToContacts.get(objCon.accountID).Contacts.size() > 2)
                objCon.addError('cannot have more than 2 contacts per account');
        }
    }
}
     */
}