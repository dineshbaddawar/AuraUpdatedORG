public class ProducDetailsVFController {
    
    public List<TechnicalVFMetadata__mdt> techvfmetadataList {get;set;} // Meta Details
    Public Map<String,List<String>> sectionAndApiFieldMap {get;set;}  // Section Name and FieldAPI Name Map
    public static Map<String,String> mapofFieldAPINameBYFieldLabel{get;set;} // API Name and Its Label
    public static map<String,String> mapofFieldAPINameByFieldValue{get;set;} // API Name and Its Value
    Public Static Map<String,String> MapofLabelAndValue {get;set;}          // Label and Its Value
    Public Static Map<String, Map<String,String>> SectionNameWithFieldLabelandValue {get;set;}  // Section Name and Label / Value

    public  String oppLineItemId {get;set;}
    public Product2 getProductDetails {get;set;}
    public OpportunityLineItem OppLineitemDetails {get;set;}
    
    public ProducDetailsVFController(ApexPages.StandardController ctrl){
        oppLineItemId = ctrl.getId();
        system.debug('oppLineItemId ===> '+oppLineItemId);
        try{
            if(!String.isBlank(oppLineItemId)){
                techvfmetadataList = [SELECT MasterLabel,Id,Field_Api_Name__c,Section_Name__c FROM TechnicalVFMetadata__mdt];
                sectionAndApiFieldMap = new Map<String,List<String>>();
                for(TechnicalVFMetadata__mdt tech : techvfmetadataList){
                    List<String> FieldList = tech.Field_Api_Name__c.split(',');
                    System.debug('FieldList ===> '+FieldList);
                    sectionAndApiFieldMap.put(tech.Section_Name__c,FieldList);
                }
                OppLineitemDetails = [SELECT Id,Product2.Name,Product2.Type__c,Product2.Family,Product2Id,OpportunityId From OpportunityLineItem Where Id=:oppLineItemId];
                if(!String.isBlank(OppLineitemDetails.Product2Id )){
                    getProductDetails = [SELECT Id,Name,ProductCode,Family,Description,StockKeepingUnit,QuantityUnitOfMeasure,HSN_Code__c,Model_Number__c,Actuator_Body_Material__c,Actuator_Inbuilt_With__c,Damper_Length__c,Damper_Length_Unit__c FROM Product2 WHERE Id=:OppLineitemDetails.Product2Id];
                    
                }
                mapofFieldAPINameBYFieldLabel = new Map<String,String>();
                mapofFieldAPINameByFieldValue = new Map<String,String>();
                if(!sectionAndApiFieldMap.isEmpty()){
                    for(String str : sectionAndApiFieldMap.keySet()){
                      //  System.debug('str ==== >'+str);
                        for(String mapKey : sectionAndApiFieldMap.get(str)){
                         //   System.debug('mapkey === >'+mapKey);
                        String LabelValue =  (String)Schema.getGlobalDescribe().get('Product2').getDescribe().fields.getMap().get(mapKey).getDescribe().getLabel();

                           mapofFieldAPINameBYFieldLabel.put(mapKey,LabelValue);
                          mapofFieldAPINameByFieldValue.put(mapKey,String.valueOf(getProductDetails.get(mapKey)));
                        }
                    }
                }
                System.debug('API NAME & LABEL ===>'+mapofFieldAPINameBYFieldLabel);
                System.debug('API NAME & VALUE ===> '+mapofFieldAPINameByFieldValue);
            }
            
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());   
        }  
    }
}