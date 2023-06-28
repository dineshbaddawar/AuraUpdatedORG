public class MapTechnicalDocumentApexClass {
    Public Product2 ProductRec{get;set;}
    public String userPhone {get;set;}
    Public Date CurrentDate{get;set;}
    Public OpportunityLineItem OppLineItemRec{get;set;}
    public List<TechnicalVFMetadata__mdt> techvfmetadata {get;set;}
    public  Map<String,List<String>> sectionAndApiFieldMap {get;set;}
    public static Map<String,String> mapofFieldAPINameBYFieldLabel{get;set;}
    public static map<String,String> mapofFieldAPINameByFieldValue{get;set;}
    Public Static Map<String,String> MapofLabelAndValue {get;set;}
    Public Static Map<String, Map<String,String>> SectionNameWithFieldandValue {get;set;}
    Public MapTechnicalDocumentApexClass(ApexPages.StandardController ctrl){
        String ProductId =  ApexPages.currentPage().getParameters().get('Id');   
        OppLineItemRec=[Select Id,Product2Id,Quantity,OpportunityId,Product2.Type__c From OpportunityLineItem Where Id=:ProductId];
        OpportunityLineItem OppLRec=[Select Id,Product2.Name,Product2.Type__c,Product2.Family,Product2Id,OpportunityId From OpportunityLineItem Where Id=:ProductId];
        ProductRec=[Select Id,Name,HSN_Code__c,Damper_Length__c,Damper_Length_Unit__c,Family,Actuator_Inbuilt_With__c, Actuator_Body_Material__c,Model_Number__c,Valve_Size__c,Ambient_Temperature_Humidity__c,Body_Material_del__c  From Product2 where Id =:OppLRec.Product2Id];        
        if(ProductRec.Ambient_Temperature_Humidity__c!=null){
            String ProductAmbientTemperatureHumidity=ProductRec.Ambient_Temperature_Humidity__c;
            if(ProductAmbientTemperatureHumidity.contains('-')){
                ProductAmbientTemperatureHumidity =ProductAmbientTemperatureHumidity.replace('-','- ');
                ProductRec.Ambient_Temperature_Humidity__c=ProductAmbientTemperatureHumidity;
            } 
        }   
        if(ProductRec.Model_Number__c!=null){
            String ProductModel=ProductRec.Model_Number__c;
            if(ProductModel.contains('-')){
                ProductModel =ProductModel.replace('-','- '); 
                ProductRec.Model_Number__c=ProductModel;
            }
        } 
        sectionAndApiFieldMap = new Map<String,List<String>>();
        CurrentDate=system.today();
        userPhone = [SELECT Phone FROM User WHERE Id =: UserInfo.getUserId()].Phone;
        techvfmetadata = [SELECT MasterLabel,Id,Field_Api_Name__c,Section_Name__c,Squence_No__c FROM TechnicalVFMetadata__mdt ORDER BY Squence_No__c ASC];
        for(TechnicalVFMetadata__mdt mtd : techvfmetadata){
            List<String> VALVEFieldList = mtd.Field_Api_Name__c.split(',');
            sectionAndApiFieldMap.put(mtd.Squence_No__c + mtd.Section_Name__c, VALVEFieldList);
        }
        mapofFieldAPINameBYFieldLabel = new Map<String,String>();
        mapofFieldAPINameByFieldValue = new Map<String,String>();
        if(!sectionAndApiFieldMap.isEmpty()){
            for(String str : sectionAndApiFieldMap.keySet()){
                for(String mapKey : sectionAndApiFieldMap.get(str)){
                    mapofFieldAPINameBYFieldLabel.put(mapKey,(String)Schema.getGlobalDescribe().get('Product2').getDescribe().fields.getMap().get(mapKey).getDescribe().getLabel());
                    mapofFieldAPINameByFieldValue.put(mapKey,String.valueOf(ProductRec.get(mapKey)));
                }
            }
            MapofLabelAndValue = new Map<String,String>();
            for(String key : mapofFieldAPINameBYFieldLabel.keySet()){
                if(!MapofLabelAndValue.containsKey(mapofFieldAPINameBYFieldLabel.get(key))){
                    MapofLabelAndValue.put(mapofFieldAPINameBYFieldLabel.get(key),mapofFieldAPINameByFieldValue.get(key));
                }
            }
        }  
        SectionNameWithFieldandValue = new Map<String, Map<String, string>> ();
        for(String metaSectionName : sectionAndApiFieldMap.keyset()){
            map<String, string> LablenameWithvalue = new Map<String, string>();
            for(String str : sectionAndApiFieldMap.get(metaSectionName)){
                string fieldvalue = string.valueof(ProductRec.get(str));
                if(fieldvalue != null){
                    LablenameWithvalue.put(mapofFieldAPINameBYFieldLabel.get(str),fieldvalue );                    
                }
            }
            if(!SectionNameWithFieldandValue.containsKey(string.valueOf(metaSectionName))){
                if(!LablenameWithvalue.isempty()){
                    String outputString = string.valueOf(metaSectionName).replaceAll('null', ' ');
                    SectionNameWithFieldandValue.put(outputString, LablenameWithvalue);
                }  
            }
        }
        System.debug('KEYSET === >'+SectionNameWithFieldandValue.keySet());
        System.debug('SectionNameWithFieldandValue === >'+SectionNameWithFieldandValue);
    }
}