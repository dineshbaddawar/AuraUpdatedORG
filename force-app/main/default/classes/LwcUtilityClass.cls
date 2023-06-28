public class LwcUtilityClass {
    
    // Custom Clone Opportunity Record Using FieldSet
    
    static final String SELECT_CLAUSE = 'SELECT ';
    static final String WHERE_CLAUSE = 'WHERE';
    
    @AuraEnabled(cacheable=true)
    public Static Opportunity getFieldFromFieldSet( String oppId){
        System.debug('OppIdddd-----'+oppId);
        List<Schema.FieldSetMember> FieldSetListFromOPp  = SobjectType.Opportunity.FieldSets.FiledSet_Opp.getFields();
        List<String> FieldSet = new List<String>();
        try{
            for(Schema.FieldSetMember fieldsToAdd : FieldSetListFromOPp){
                FieldSet.add(String.valueOf(fieldsToAdd.sobjectfield));
            }
            String query = SELECT_CLAUSE + String.join(FieldSet, ',');
            System.debug('OppIdddd-----'+query);
            query += ' FROM Opportunity '+ WHERE_CLAUSE+' Id =: oppId';
            return Database.query(query);
        }catch(Exception e){
            System.debug('The Error '+e.getMessage());
            System.debug('Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
    // ==============================================================================================================================================================
    
    // Class for Search Contact Name using LWC
    @AuraEnabled 
    public Static List<Contact> getContactUsingString(String searchText){
        try{
            String searchKey = '%' + searchText + '%';
            List<Contact> conList = [SELECT Id,Name,Phone,Email FROM Contact WHERE Name =: searchKey LIMIT 10];
            if(!conList.isEmpty()){
                System.debug('conList Size ::'+conList.Size());
                return conList;
            }else {
                return null;
            }
        }catch(Exception e){
            System.debug('The Error '+e.getMessage());
            System.debug('Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
    // Example
    @AuraEnabled(cacheable=true)
    public Static List<conWrapper> getContactName(String conName){
        String keyString = '%' + conName + '%';
        System.debug('keyString ::'+keyString);
        List<conWrapper> wrapList = new List<conWrapper>();
        conWrapper opp = new conWrapper();
        List<Contact> getConList = [SELECT Id,lastName,FirstName,Name,Email FROM Contact WHERE Name LIKE : keyString LIMIT 5];
        for(Contact wap : getConList){
            opp.Name = wap.Name;
            opp.Email = wap.Email;
            opp.Id = wap.Id;
            System.debug('wap ::'+wap);
            wrapList.add(opp);
        }
        System.debug('wrapList ::'+wrapList);
        return wrapList;
    }
    
    public class conWrapper{
        @AuraEnabled public String Name {get;set;}
        @AuraEnabled public String Email {get;set;}
        @AuraEnabled public String Id {get;set;}
    }
    
    // ==============================================================================================================================================================
    
    // Passing Selected Records from LWC Datatable to apex Using Imperative Method
    // Method 1
    @AuraEnabled 
    public Static List<Contact> getSelectedContactList(List<Contact> conList){
        try{
            for(Contact con : conList){
                if(con.FirstName == null){
                    con.FirstName = 'Default';
                }
            }
            update conList;
            System.debug('conList ::'+conList);
            return conList;
        }catch(Exception e){
            System.debug('The Error '+e.getMessage());
            System.debug('Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
    //==============================================================================================================================================================
    
    // Method to Getting By Default List of Contacts
    @AuraEnabled 
    public Static List<Contact> getContactListRecord(){
        try{
            List<Contact> conList = [SELECT Id,Name,Email,Phone FROM Contact ORDER BY CreatedDate DESC LIMIT 10];
            if(!conList.isEmpty()){
                System.debug('conList Data ::'+conList);
                return conList;
            }else{
                return null;
            }
            
        }catch(Exception e){
            System.debug('The Error '+e.getMessage());
            System.debug('Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
    //==============================================================================================================================================================
      @AuraEnabled 
    public Static AccountCountWrapper getAccountcount(String recordId){
        try{
            List<Contact> conList = [SELECt Id,Name,AccountId FRoM Contact Where AccountId =:recordId];
            List<Opportunity> oppList = [SELECT Id,Name,StageName,CloseDate,AccountId FROM Opportunity where AccountId =: recordId];
            List<Case> caseList = [SELECT Id,AccountId FRoM Case Where AccountId =: recordId];
            AccountCountWrapper wrap = new AccountCountWrapper();
            wrap.contactCount = conList.size();
            wrap.OpportunityCount = oppList.size();
            wrap.caseCount = caseList.size();
            System.debug('wrap Result ::'+wrap);
            return wrap;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }        
        return null;
    }
    
    public Class AccountCountWrapper{
        @AuraEnabled public integer contactCount;
        @AuraEnabled public integer OpportunityCount;
        @AuraEnabled public integer caseCount;
    }
    
}