public class GlobalSobjectController {
    
    @AuraEnabled(cacheable=true)
    public Static List<genericObjectWrapper> getAllSobject(){
        try{
            List<genericObjectWrapper> wrapList = new List<genericObjectWrapper>();
            for(Schema.SObjectType objType : Schema.getGlobalDescribe().values()){
                system.debug('objType ==== >'+objType);
                System.debug('objType GetDescribe == >'+objType.getDescribe());
                Schema.DescribeSObjectResult objResult = objType.getDescribe();
                wrapList.add(new genericObjectWrapper(objResult.getName(), objResult.getLabel(), objResult.isCustom()));
            }
            if(!wrapList.isEmpty()){
                System.debug('wrapList Size ::'+wrapList.Size());
                return wrapList;
            }else{
                return null;
            }
        }catch(Exception e){
            System.debug('The Error '+e.getMessage());
            System.debug('Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Object> getRecords(String objectName){
        System.debug('Object Name ::'+objectName);
        try{
            String query  = 'SELECT Id,Name FROM '+objectName+ ' ORDER BY CreatedDAte DESC LIMIT 5';
            List<Object> objList = Database.query(query);
            System.debug('objList SIZE :::'+objList);
            if(!objList.isEmpty()){
                return objList;
            }else{
                return null;
            }
        }catch(Exception e){
            System.debug('The Error >> '+e.getMessage() + ' && Erron Line >> ' +e.getLineNumber());
        }
        return null;
    }
    
    public class genericObjectWrapper{
        @AuraEnabled public String objectName;
        @AuraEnabled public String objectLabel;
        @AuraEnabled public Boolean isCustom;
        
        genericObjectWrapper(String objectName, String objectLabel, Boolean isCustom){
            System.debug('objectName === >'+objectName +' && objectLabel == >'+objectLabel + ' && isCustom == >'+isCustom);
            this.objectName = objectName;
            this.objectLabel = objectLabel;
            this.isCustom = isCustom;
        }
    }
}