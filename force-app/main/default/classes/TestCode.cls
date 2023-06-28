public class TestCode {
    // SALESFORCESCOOL
    // Wrapper Class 
    public Static Wrappper TestData(String ParamPhone){
        DateTime fileNo = System.now();
        fileNo.dateGmt();
        System.debug('fileNo dateGmt::'+fileNo);
        fileNo.time();
        System.debug('fileNo : Time ::'+fileNo);
        fileNo.format('HH:mm:ssXXX');
        Wrappper wrap = new Wrappper();
        Account accEmailList = [SELECT Id,Phone FRoM Account WHERe Phone =:ParamPhone Limit 1];
        Opportunity opp = [SELECT Amount,AccountId FROM Opportunity WHERE AccountId =: accEmailList.Id Limit 1];
        
        List<Contact> conPhoneList = [SELECT Id,Phone FROM Contact WHERE Phone =:ParamPhone];
        String accPhone = accEmailList.Phone;
        System.debug('accPhone ::'+accPhone);
        wrap.oppId = opp.Amount;
        System.debug('Amount ::'+wrap.oppId);
        wrap.accList = accEmailList;
        wrap.conList = conPhoneList;
        System.debug('wrap ::'+wrap);
        return wrap;
    }
    
    
    public class Wrappper{
        Account accList {get;set;}
        List<Contact> conList {get;set;} 
        Double oppId {get;set;}
    }
    // ============================================================================================================================================================
    // Custom Notification Class
    
    public Static void SendCustomNotification(List<Contact> conList ){
        try{
            System.debug('conList>>>>::'+conList);
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='MyCustomeNotification']; 
            for(Contact con : conList){
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                notification.setTitle('Record Created Successfully !');
                notification.setBody('Name :'+con.FirstName +' '+con.LastName+' ID :'+con.Id);        
                notification.setNotificationTypeId(notificationType.id);
                notification.setTargetId(con.id);
                notification.send(new Set<String>{Userinfo.getUserId()});
            }
            
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
    // ===========================================================================================================================================================
    // Get start and end date of current month in apex
    /*
Date startdate = Date.Today().toStartofMonth();
Date enddate = startdate.addDays(Date.daysInMonth(startdate.year(), startdate.month())-1);
System.debug('Start^^'+startdate);
System.debug('End^^'+enddate);
*/
    // ===========================================================================================================================================================
    // Controller for Server Side Pagination in Lightning Datatable
    @AuraEnabled
    public Static List<Account> getAccountList(Integer pageSize, Integer pageNumber){
        System.debug('pageSize ::'+pageSize +' pageNumber ::'+pageNumber);
        integer offset = (pageNumber - 1) * pageSize;
        System.debug('offset :::'+offset);
        List<Account> accList = [SELECT Id,Name,Email__c FROM Account LIMIT :pageSize OFFSET :offset];
        System.debug('accList :::'+accList);
        return accList;
    }
    
    // ===========================================================================================================================================================
    
    // Controller for Client Side Pagination With Search in Lightning Datatable
    
    @AuraEnabled
    public static Map<String, Object> getColumnsAndData(String sObjectName, List<String> sObjectFieldsNames) {
        try{
            Map<String, Schema.SObjectField> m = Schema.describeSObjects(sObjectName.split(','))[0].fields.getMap();
            List<Object> columns = new List<Object>();
            for ( String fieldName: sObjectFieldsNames ) {
                Schema.DescribeFieldResult dfr = m.get( fieldName ).getDescribe();
                Map<String, Object> column = new Map<String, Object>{
                    'label' => dfr.getLabel(),
                        'fieldName' => dfr.getName(),
                        'type' => String.valueOf( dfr.getType() ).toLowerCase(),
                        'sortable'=>true
                        };
                            columns.add( column );
            }
            String query = 'SELECT ' + String.join( sObjectFieldsNames, ', ') + ' FROM ' + sObjectName;
            List<SObject> records = Database.query( query );
            return new Map<String, Object>{
                'columns' => columns,
                    'data' => records
                    };
                        } 
        catch(Exception ex) {            
            return new MAP<string,object>{'Exception'=>ex.getMessage()};
                }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //   ===========================================================================================================================================================
    // PickList Controller
    // Given an API object and field name, returns the configured field label to display to users.    
    @AuraEnabled(cacheable=true)
    public static String getFieldLabel( String objectName, String fieldName ) {
        System.debug( 'Getting field label: objectName=' + objectName + ', fieldName=' + fieldName );
        String label = Schema.getGlobalDescribe().get( objectName ).getDescribe().fields.getMap().get( fieldName ).getDescribe().getLabel();       
        System.debug( 'label= ' + label );
        return label;
    }
    
    //Given an API object and field name, returns list of the picklist values for use in select input.
    @AuraEnabled(cacheable=true)
    public static List<PicklistOption> getPicklistOptions( String objectName, String fieldName ) {
        System.debug( 'Getting picklist options: objectName=' + objectName + ', fieldName=' + fieldName );
        List<PicklistOption> options = new List<PicklistOption>();
        for ( PicklistEntry entry : Schema.getGlobalDescribe().get( objectName ).getDescribe().fields.getMap().get( fieldName ).getDescribe().getPicklistValues() ) {
            options.add( new PicklistOption( entry.getLabel(), entry.getValue() ) );
        }
        System.debug( 'options=' + options );
        return options;
    }
    //The system class PicklistEntry is not aura enabled so cannot be returned from @AuraEnabled method.
    // Workaround is to define our own class with aura enabled properties.
    public class PicklistOption {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }
        public PicklistOption( String label, String value ) {
            this.label = label;
            this.value = value;
        }
    }
    
        //   ===========================================================================================================================================================

    
    @AuraEnabled(cacheable=true)
    public Static  List<Account> getUpdateAccountType(String recordId, String selAccountTypeValue){
        try{
            List<Account> accList = new List<Account>();
            Account acc = new Account();
            acc.id = recordId;
            acc.type = selAccountTypeValue;
            accList.add(acc);
            if(!accList.isEmpty()){
                update accList;
            }
            // System.debug('accRec After :::'+acc);
            return accList;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber()); 
        }
        return null;
    } 
    
    // update Above Class
    @AuraEnabled
    public Static String updateAccountPickValue(String recordId, String pickValue){
        try{
            Account acc = new Account();
            acc.id = recordId;
            if(pickValue !=null){
                acc.Type = pickValue;
            }
            update acc;
            System.debug('acc ::'+acc);
            return 'SUCCESSS';
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber()); 
        }
        return 'ERROR';
    }
    
        //   ===========================================================================================================================================================

    
    // Test Code
    
    @AuraEnabled(cacheable=true)
    public Static List<PickListwrapper> pickListValueAndLabel(Sobject objectApiName, String SelfieldName){
        Schema.DescribeSObjectResult objDescribe = objectApiName.getSObjectType().getDescribe();
        map < String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap(); 
        list < Schema.PicklistEntry > custPickValues = customFieldMap.get(SelfieldName).getDescribe().getPickListValues();
        List<PickListwrapper> wrapList = new List<PickListwrapper>();
        for(Schema.PicklistEntry fieldValue : custPickValues){
            PickListwrapper wrap = new PickListwrapper();
            wrap.fieldLabel = fieldValue.getLabel();
            wrap.fieldValue = fieldValue.getValue();
            wrapList.add(wrap);
        }
        System.debug('wrapList :::'+wrapList);
        return wrapList;
    }
    
    public class PickListwrapper{
        @AuraEnabled
        public String fieldLabel {get;set;}
        @AuraEnabled
        public String fieldValue {get;set;}
        
    }
    
        //   ===========================================================================================================================================================

    
    // LWC CODE
    
    //fetch picklist values from custom object in lwc
    @AuraEnabled(cacheable=true)
    public static List < customValueWrapper > pickListValueDynamically(sObject customObjInfo, string selectPicklistApi) {
        Schema.DescribeSObjectResult objDescribe = customObjInfo.getSObjectType().getDescribe();     
        map < String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap();      
        list < Schema.PicklistEntry > custPickValues = customFieldMap.get(selectPicklistApi).getDescribe().getPickListValues();
        list < customValueWrapper > customObjWrapper = new list < customValueWrapper > ();
        for (Schema.PicklistEntry myCustPick: custPickValues) {
            customValueWrapper selectOptionValueWrapper = new customValueWrapper();
            selectOptionValueWrapper.custFldlabel = myCustPick.getLabel();
            selectOptionValueWrapper.custFldvalue = myCustPick.getValue();
            customObjWrapper.add(selectOptionValueWrapper);
        }
        
        return customObjWrapper;
        
    }
    // wrapper class 
    public with sharing class customValueWrapper {
        @auraEnabled public string custFldlabel {get;set;}
        @auraEnabled public string custFldvalue {get;set;}
    }
    
        //   ===========================================================================================================================================================

    @AuraEnabled
    public Static Contact UpdateContactPickList(String recordId, string pickValue){
        System.debug('recordId :::'+recordId +' pickValue :::'+pickValue);
        try{
            Contact con = new Contact();
            con.id = recordId;
            con.LeadSource = pickValue;
            update con;
            return con;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return null;
        }
        
    }
    //   ===========================================================================================================================================================
    
    @AuraEnabled //get Opportunity Industry Picklist Values
    public static Map<String, String> getIndustry(){
        Map<String, String> options = new Map<String, String>();
        //get Account Industry Field Describe
        Schema.DescribeFieldResult fieldResult = Account.Industry.getDescribe();
        //get Account Industry Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
   
        //   ===========================================================================================================================================================

    public Static  Map<String,String> getOpportunityPickList(){
        Map<String,String> pickOptionsMap1 = new Map<String,String>();
        Map<String,String> pickOptionsMap2 = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult1 = Opportunity.StageName.getDescribe(); 
        Schema.DescribeFieldResult fieldResult12 = Opportunity.type.getDescribe();
        List<Schema.PicklistEntry> pickList1 = fieldResult1.getPicklistValues();
        System.debug('pickList1 ::'+pickList1);
        List<Schema.PicklistEntry> pickList2 = fieldResult12.getPicklistValues();
        System.debug('pickList2 ::'+pickList2);
        for(Schema.PicklistEntry pick1 : pickList1){
             pickOptionsMap1.put(pick1.getLabel(), pick1.getValue());
        }
        System.debug('pickOptionsMap1 ::'+pickOptionsMap1);
        for(Schema.PicklistEntry pick2 : pickList2){
            pickOptionsMap2.put(pick2.getLabel(),pick2.getValue());
        }
         System.debug('pickOptionsMap2 ::'+pickOptionsMap2);
        return null;
    }
    
    
       //   ===========================================================================================================================================================
 
  
}