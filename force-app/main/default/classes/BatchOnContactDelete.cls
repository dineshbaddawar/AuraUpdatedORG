public with sharing class BatchOnContactDelete implements Database.batchable <Sobject> {
    
    public Database.QueryLocator Start(Database.batchableContext bc){
        String query = 'SELECT Id,Email,Phone,AccountId FROM Contact WHERE CreatedDate < LAST_N_DAYS:90 order by CreatedDate DESC';
        return Database.getQueryLocator(query);
    }
    public void Execute(Database.batchableContext bc, List<Contact> conList){
        System.debug('Query Record Size === >'+conList.size());
     List<Sobject_Records_Delete__b> sobjListToInsert = new List<Sobject_Records_Delete__b>();
     Set<Id> conIdSet = new Set<Id>();
        try{
            if(conList.size() > 0){
                for(Contact con : conList){
                    conIdSet.add(con.id);
                    Sobject_Records_Delete__b sobj = new Sobject_Records_Delete__b();
                    sobj.Contact__c = con.Id;
                    sobj.Current_RecordTime__c = System.now();
                    sobj.Email__c = con.Email;
                    sobj.Phone__c = con.Phone;
                    if(con.AccountId !=null){
                    sobj.Related_AccountId__c = con.AccountId;
                    }
                    sobjListToInsert.add(sobj);
                }

                if(sobjListToInsert.size() > 0){
                    Map<String, String> errorMap =new Map<String, String>();
                    Map<String, SObject> IdToSObjectMap = new Map<String, SObject>(); 
                    Database.SaveResult[] succesResults =  database.insertImmediate(sobjListToInsert);
                    System.debug('SUCCESS Big Object Record ==> '+succesResults);
                    System.debug('SUCCESS Big Object Size ==> '+succesResults.size());
                    Integer index = 0;
                    for(Database.SaveResult dsr : succesResults){
                        if(!dsr.isSuccess()){
                            for(Database.Error error : dsr.getErrors()){
                                String errMsg = error.getMessage();
                                errorMap.put('record '+index, errMsg);
                                IdToSObjectMap.put('record '+index, sobjListToInsert[index]);
                            }
                        }
                        index++;
                    }
                    Set<Id> failedRecordIDList = new Set<Id>();
                    if(!errorMap.isEmpty()){
                        for(String id  : errorMap.keySet()){
                            string err = errorMap.get(id);
                            SObject sr = IdToSObjectMap.get(id); 
                            String accountString = String.ValueOf(sr);
                            String failedRecordId = accountString.substringBetween('Id=', ',');
                            failedRecordIDList.add(failedRecordId);
                        } 
                    }   
                    System.debug('failedRecordIDList === >'+failedRecordIDList); 
                    List<Contact> conListToDelete = [SELECt Id,Name FROM Contact WHERE Id IN :conIdSet AND Id NOT IN :  failedRecordIDList];
                    if(conListToDelete.size()> 0){
                        Database.DeleteResult[] drList = Database.delete(conListToDelete, false);
                       // delete conListToDelete;
                    }
                }
            }
        }catch(Exception e){
                System.debug('The Error '+e.getMessage());
                System.debug('Erron Line '+e.getLineNumber());
            }
    }
    public void Finish(Database.batchableContext bc){

    }
}