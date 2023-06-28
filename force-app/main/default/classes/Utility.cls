public class Utility {
    
    //==============================================================================================================================================
    public static List<String> getPicklistValues(String ObjectApi_name, String Field_name){
        List<String> lstPickvals = new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values){
            lstPickvals.add(String.ValueOf(a.getLabel()).trim());
        }
        System.debug('lstPickvals Values Method 1 === :'+lstPickvals);
        return lstPickvals;
    }
    
    //==============================================================================================================================================
    
    public static List<String> getPicklistValuesWithNone(String ObjectApi_name, String Field_name){
        List<String> pickList = new List<String>{ '--None--' };
            pickList.addAll(getPicklistValues(objectApi_name, field_name));
        System.debug('pickList Values Method 2 == :'+pickList);
        return pickList;
    }
    
    //==============================================================================================================================================
    //AuraSpinner Example
    @AuraEnabled
    public static List <Account> fetchAccounts() {
        //Qyery 10 accounts
        List<Account> accList = [SELECT Id, Name, BillingState, 
                                 Website, Phone from Account LIMIT 10];
        //return list of accounts
        return accList;
    }
    
    //==============================================================================================================================================
    // Custom Lookup Controller
    @AuraEnabled
    Public Static List<Sobject> FetchLookupValues(String object_Api_Name,String searchKeyWord){
        try{
            List<Sobject> objectList = new List<Sobject>();
            List<Sobject> objectListQuery = new List<Sobject>();
            String searchText =  searchKeyWord + '%';
            String Query = 'SELECT Id,Name FROM '+object_Api_Name+' WHERE Name LIKE :searchText ORDER BY CreatedDate DESC LIMIT 10 ';
            System.debug('Query === >'+Query);
            objectListQuery = Database.query(Query);
            for(Sobject obj : objectListQuery){
                objectList.add(obj);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
            }
            System.debug('objectList === :'+objectList);
            return objectList;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    
}