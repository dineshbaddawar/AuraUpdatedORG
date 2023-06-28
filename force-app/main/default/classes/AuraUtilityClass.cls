public with sharing  class AuraUtilityClass {
    
    // Get Lead Record
    @AuraEnabled
    public Static lead getLeadRecordData(String recordId){
        System.debug('recordId ::'+recordId);
        lead led = [SELECT Id,FirstName,LastName,Phone,Company,Status FROM Lead Where Id =:recordId LIMIT 1];
        System.debug('lead Record ::'+led);
        return led;
    }
    // Create Lead Record Form
    @AuraEnabled
    public Static Lead createLeadRecord(String fName, String lName, String Phone, String company, String leadStatus){
        try{
            List<Lead> leadList = new List<Lead>();
            Lead led = new Lead();
            led.FirstName =fName;
            led.LastName = lName;
            led.Phone = phone;
            led.Company = company;
            led.Status = leadStatus;
            leadList.add(led);
            if(!leadList.isEmpty()){
                insert leadList;
                System.debug('Record ::'+leadList[0]);
            }        
            return leadList[0];
        }catch(Exception e){
            System.debug('Error ::'+e.getMessage() +' And Line ::'+e.getLineNumber());
        }
        return null;
    }
    
    // Custom Datatable where Custom Accoun Name is Showing
    @AuraEnabled
    public static List<Contact> customContactList(){
        List<Contact> conList = [SELECT Id,Name,Email,Phone,Account.Name FROM Contact WHERE CREATEDDATE = THIS_WEEK];
        System.debug('conList ::'+conlist.size());
        return conList;
    }
    
    // CRUD Operation Controller
    // get Contact
    @AuraEnabled
    public Static List<Contact> getContact(){
        List<Contact> retriveData = [SELECT Id,Name,Phone,Email FROM Contact WHERE CREATEDDATE = TODAY OR CREATEDDATE = YESTERDAY];
        system.debug('GET ::'+retriveData);
        return retriveData;
    }
    
    // =========================================================================================================================================================================
    
    //  Create Contact
    @AuraEnabled
    public Static Contact createContactData(String firstname, String lastname,  String phone, String email){
        Contact con = new Contact();
        con.FirstName = firstname;
        con.LastName = lastname;
        con.Phone = phone;
        con.Email = email;
        insert con;
        system.debug('INSERT ::'+con);
        return con;
    }
    
    // =========================================================================================================================================================================
    
    
    // Edit Contact
    @AuraEnabled
    public Static Contact getSelectedConDataByUsingId(String conId){
        return [SELECT Id,FirstName,LastName,Phone,Email FROM Contact WHERE Id =: conId];
    }
    
    // =========================================================================================================================================================================
    
    
    // Update Contact
    @AuraEnabled
    public Static Contact  updateContact(String conId,String firstname, String lastname, String phone, String email){
        Contact con = new Contact();
        con.Id = conId;
        con.FirstName = firstname;
        con.LastName = lastname;
        con.Email = email;
        con.Phone = phone;
        update con;
        system.debug('UPDATE ::'+con);
        return con;
    }
    
    // =========================================================================================================================================================================
    
    // Delete Contact
    @AuraEnabled
    public Static String deleteContact(String conId){
        Contact con = new Contact();
        con.Id = conId;
        delete con;
        system.debug('DELETE ::'+con);
        return 'DELETE';
    }
    
    // =========================================================================================================================================================================
    
    // Sending Email to Selected Contact Record using Aura Component
    // Class for get Selected Contact Record Id
    public List<Contact> selContactLst;
    public String contactsIds;
    
    public AuraUtilityClass(ApexPages.StandardSetController cntlr){
        selContactLst = cntlr.getSelected(); //get selected records from account list view
        contactsIds = '';  
        for(Contact con : selContactLst){
            contactsIds += con.Id + ','; //build list of ids string concatenated with comma                         
        }
        contactsIds = contactsIds.removeEnd(','); 
    }
    
    public PageReference redirectToLComp(){
        String returnUrl = '/lightning/cmp/c__SendListEmailComp?c__listofContacts='+contactsIds;
        PageReference pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    // Apex Class Controller
    @AuraEnabled
    public Static List<Contact> contactToSendEmail(List<String> contactIds){
        try{
            
            List<String> lstString = contactIds[0].split(',');
            
            System.debug('lstString ===>:'+lstString);
            List<Contact> getcontactWithEmail = [SELECT Id,Email,Name FROM Contact WHERE ID IN: lstString];
            //  System.debug('getcontactWithEmail ::'+getcontactWithEmail);
            EmailTemplate temp = [Select id, Subject, Body ,HTMLValue From EmailTemplate Where Name = 'Welcome Email'];
            List<Messaging.SingleEmailMessage> EmailList = new List<Messaging.SingleEmailMessage>();
            
            String subject = temp.Subject;
            String plainTextBody = temp.Body;
            for(Contact con : getcontactWithEmail){
                String htmlBody = temp.HtmlValue;
                htmlBody = htmlBody.replace('{!Contact.Name}', con.Name);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                mail.setHtmlBody(htmlBody);
                mail.setSubject(subject);
                mail.setPlainTextBody(plainTextBody);
                mail.setToAddresses(new String[] {con.Email});
                EmailList.add(mail);
            }
            if(!EmailList.isEmpty()){
                Messaging.sendEmail(EmailList);
            }
            return getcontactWithEmail;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // =========================================================================================================================================================================
    
    // Controller for Contact, Opportunity & Account Based on Lead Email or Phone using Aura Comp
    // Current Lead Record
    @AuraEnabled
    public Static Lead getLeadRecord(String leadRecId){
        Lead led =[SELECT Id,Name,Email,Phone FROM Lead WHERE Id =:leadRecId];  
        System.debug('Lead ::'+led);
        return led;
    }
    
    // Get Contact Based on Lead Phone or Email
    @AuraEnabled
    public Static List<Contact> getContactListBasedOnLeadPhoneorEmail(String leadPhone, String leadEmail){
        List<Contact> conList = [SELECT Id,Name,Email,Phone FROM Contact WHERE Phone =:leadPhone OR Email =:leadEmail LIMIT 10];
        System.debug('Contact ::'+conList);
        return conList;
    }
    
    // Get Opportunity Based on Lead Phone or Emai
    @AuraEnabled
    public Static List<Opportunity> getOpportunityListBasedOnLeadPhoneorEmail(String leadPhone, String leadEmail){
        List<Opportunity> oppList = [SELECT Id,Name,Email__c,Phone__c FROM Opportunity WHERE Phone__c =: leadPhone OR Email__c =: leadEmail LIMIT 10];
        System.debug('Opportunity ::'+oppList);
        return oppList;
    }
    
    // Get Account Based on Lead Phone or Email
    @AuraEnabled
    public Static List<Account> getAccountListBasedonLeadEmailorPhone(String leadPhone, String leadEmail){
        List<Account> accList = [SELECT Id,Name,Phone,Email__c FROM Account WHERE Phone =:leadPhone OR Email__c =: leadEmail LIMIT 10];
        System.debug('Account ::'+accList);
        return accList;
    }
    
    // =========================================================================================================================================================================
    
    
    // GlobalSearchHandler
    @AuraEnabled
    public static List<List<sObject>> getSearchRecords(String searchKeyValue){     
        try{
            List<List<sObject>> searchResult = [FIND :searchKeyValue IN ALL FIELDS RETURNING
                                                Account (Id, Name, Phone, Website),
                                                Contact(Id, Name, Email, MobilePhone LIMIT 10),
                                                Opportunity(Id, Name, StageName, CloseDate ),
                                                Lead(Id, Name, Email, Company)];
            System.debug('RESULT ::'+searchResult);
            return searchResult;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // =========================================================================================================================================================================
    
    
    // Controller for Downloading data in CSV Format
    @AuraEnabled
    public Static List<Account> getAccountListToExportCSV(){
        return [SELECT Id,Name,Type,Email__c,Rating,Phone,AnnualRevenue FROM Account  ORDER BY CREATEDDATE DESC LIMIT 10];
    }
    
    // =========================================================================================================================================================================
    
    
    // Controller for Dual PickList
    // Class #1
    @AuraEnabled
    public Static List<String> getPickListValuesMethod(String ObjectApi_name, String Field_Name){
        try{
            List<String> lstPickvals                        = new List<String>();
            Schema.SObjectType targetType                   = Schema.getGlobalDescribe().get(ObjectApi_name);
            Sobject Object_name                             = targetType.newSObject();
            Schema.sObjectType sobject_type                 = Object_name.getSObjectType(); 
            Schema.DescribeSObjectResult sobject_describe   = sobject_type.getDescribe();
            Map<String, Schema.SObjectField> field_map      = sobject_describe.fields.getMap();
            List<Schema.PicklistEntry> pick_list_values     = field_map.get(Field_Name).getDescribe().getPickListValues();
            
            for (Schema.PicklistEntry a : pick_list_values) {
                lstPickvals.add(String.ValueOf(a.getLabel()).trim());  
            }
            System.debug('lstPickvals>>>> ::'+lstPickvals);
            return lstPickvals;
        }Catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // Class #2
    // Updating the Current Record Opportunity
    @AuraEnabled
    public Static Opportunity updateOppPicklistValue(String recordId, String StageParam, String typeParam){
        try{
            Opportunity opp = new Opportunity();
            opp.id = recordId;
            opp.StageName = StageParam;
            opp.LeadSource = typeParam;
            update opp;
            return opp;
        }Catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // =========================================================================================================================================================================
    
    
    // Controller for RUD Operation
    // Class #1
    @AuraEnabled
    public Static List<Account> getAccountRecordList(){
        return [SELECT Id,Name,AccountNumber,Industry,Phone FROM Account WHERE CreatedDate = THIS_WEEK];
    }
    
    // Class #2
    @AuraEnabled 
    public Static void deleteAccountRecord(Account accRec){
        delete accRec;
    }
    
    // =========================================================================================================================================================================
    
    
    // Controller for Report in Aura Component
    @AuraEnabled
    public Static Integer gerReportCountByPassingReportApiName(String reportApiName){
        try{
            Report reportLIst = [SELECT Id,Name,DeveloperName FROM Report WHERE DeveloperName =:reportApiName LIMIT 1];    
            Reports.ReportResults results = Reports.ReportManager.runReport(reportLIst.Id, true);
            Reports.ReportFactWithDetails factReportDetails = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');
            List<Reports.SummaryValue> allSummary = factReportDetails.getAggregates();
            Integer reportCount = Integer.valueOf(allSummary[0].getValue());
            System.debug('allSummary ::'+reportCount);  
            return reportCount;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());  
        }
        return null;
    }
    
    
    // =========================================================================================================================================================================
    
    // Controlle for Datatable for Opportunity Invoice List which clikcable to redirect Record Detail Page
    // Set Datetime format in Lightning Datatable And Sort Column in Lightning Datatable
    @AuraEnabled
    public static List<Invoice__c> getInvoiceListFromOPp(String oppId){
        try{
            List<Invoice__c> invList = [SELECT Id,Name,Opportunity__c,Invoice_Date__c,Payment_Status__c,Invoice_Sent__c,CreatedDate FROM Invoice__c WHERE Opportunity__c =:oppId];
            System.debug('invList :::'+invList);
            return invList;
        }catch(Exception e){
            System.debug('The Error '+e.getMessage());
            System.debug('Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
    //  =========================================================================================================================================================================
    
    // Cloning the Record for Selected Fieldset Data using LWC
    // Controller for Clone Record
    @AuraEnabled
    public Static DataWrapper getFieldsFromFieldSetApex(String objectRecordId){
        DataWrapper valuesWrapper = new DataWrapper();
        try{
            Id recordId = Id.valueOf(objectRecordId);
            System.debug('recordId >>>>> ::'+recordId);
            String objectName = String.valueOf(recordId.getSObjectType());
            System.debug('objectName >>>> ::'+objectName);
            valuesWrapper.sObjectName = objectName;
            List<Schema.FieldSetMember> fieldsList =  SobjectType.Opportunity.FieldSets.FiledSet_Opp.getFields();
            System.debug('fieldsList>>>> ::'+fieldsList);
            List<String> fieldSet = new List<String>();
            for(Schema.FieldSetMember sf : fieldsList){
                fieldSet.add(String.valueOf(sf.sobjectfield));
            }
            System.debug('fieldSet>>>> :::'+fieldSet);
            String query ='SELECT ';
            query += String.join(FieldSet, ',');
            query += ' FROM Opportunity WHERE Id =: objectRecordId';            
            sObject exisitingRecord =  Database.query(query);
            System.debug('exisitingRecord NEW >>>>::'+exisitingRecord);
            String defaultValueJSON = JSON.serialize(exisitingRecord);
            valuesWrapper.fieldDefaultValues = defaultValueJSON;
            System.debug('valuevaluesWrapper >>> ::'+valuesWrapper);
            return valuesWrapper;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    public class DataWrapper{
        @AuraEnabled 
        public String sObjectName {get; set;}
        @AuraEnabled 
        public String fieldDefaultValues {get; set;} 
    }
    
    //   =========================================================================================================================================================================
    
    // Aura Clone Button for Custom Clone
    @AuraEnabled 
    public Static Opportunity oppCustomClone(String OppId){
        try{
            Opportunity oppRec = [SELECT Id,Name,StageName,CloseDate,Amount FROM Opportunity WHERE Id =: OppId LIMIT 1];
            System.debug('oppRec ::'+oppRec);
            return oppRec;
        }catch(Exception e){
            System.debug('The Error '+e.getMessage());
            System.debug('Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
    //   =========================================================================================================================================================================
    
    // File Upload using Aura Component
    @AuraEnabled
    public static Id SaveFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment attach = new Attachment();
        attach.parentId = parentId;
        attach.Body = EncodingUtil.base64Decode(base64Data);
        attach.Name = fileName;
        attach.ContentType = contentType;
        Insert attach;
        return attach.Id;
    }
    
        //   =========================================================================================================================================================================

    // File Upload on Site using Aura Component # 1
    // Method 1
    @AuraEnabled
    public static Id SaveFileFromSite(Id parentId, String fileName, String base64Data, String contentType) {
        try{
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            Attachment attach = new Attachment();
            attach.parentId = parentId;
            attach.Body = EncodingUtil.base64Decode(base64Data);
            attach.Name = fileName;
            attach.ContentType = contentType;
            Insert attach;
            
            Attachment attachRec = [SELECT Id, Name, Body, ContentType, ParentId,Attachment.OwnerId From Attachment where Id =:attach.Id LIMIT 1];
            System.debug('attachRec === >'+attachRec);
            
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S';
            cVersion.PathOnClient = attachRec.Name;
            cVersion.OwnerId = attachRec.OwnerId;
            cVersion.Title = attachRec.Name;
            cVersion.VersionData = attachRec.Body;
            cVersion.isMajorVersion = false;
            Insert cVersion;
            System.debug('cVersion === >'+cVersion);
            
            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            System.debug('conDocument == >'+conDocument);
            
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;
            cDocLink.LinkedEntityId = ParentId;
            cDocLink.ShareType = 'I';
            cDocLink.Visibility = 'AllUsers';
            Insert cDocLink;
            System.debug('cDocLink === >'+cDocLink);
            
            ContentDistribution contentDistribution = new ContentDistribution();
            contentDistribution.Name =cVersion.Title ;
            contentDistribution.ContentVersionId = cVersion.Id;
            contentDistribution.PreferencesAllowViewInBrowser = true;
            insert contentDistribution;
            System.debug('contentDistribution Id === >'+contentDistribution.Id);
            delete [SELECT id from Attachment where id=:attachRec.id];
            System.debug('contentDistribution.Id ==== >'+contentDistribution.Id);
            ContentDistribution con = [SELECT ContentDocumentId,Id,Name,DistributionPublicUrl FROM ContentDistribution where Id=:contentDistribution.Id];
            System.debug('URL ==>'+con.DistributionPublicUrl);
          return  contentDistribution.Id;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;       
    }
    
    
    // Send Recent Uploaded Document URL To Record Email & Alos Upload Document Upload
    // Method 2
    @AuraEnabled
    Public Static String sendDocumentPreviewURL(String recordId){
        Lead ledRec = new Lead();
        List<ContentDocumentLink> conLinkList = new List<ContentDocumentLink>();
        Set<Id> contDocIdSet = new Set<Id>();
        List<ContentDistribution> conDisList = new List<ContentDistribution>();
         Messaging.SingleEmailMessage mailTemp = new Messaging.SingleEmailMessage();
         EmailTemplate temp = new EmailTemplate();
         List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        try{
            ledRec = [SELECT Id,Name,Email FROM Lead WHERE Id=:recordId];
            if(!String.isBlank(ledRec.id)){
                conLinkList = [SELECT ContentDocumentId,Id,LinkedEntityId,ShareType FROM ContentDocumentLink where LinkedEntityId=:recordId];
                if(!conLinkList.isEmpty() && conLinkList.size()>0){
                   System.debug('conLinkList == >'+conLinkList);
                    for(ContentDocumentLink con : conLinkList){
                        contDocIdSet.add(con.ContentDocumentId);
                    }
                    System.debug('contDocIdSet == >'+contDocIdSet);
                    if(contDocIdSet.size()>0){
                        conDisList = [SELECT ContentDocumentId,DistributionPublicUrl,Id,Name,OwnerId,CreatedDate FROM ContentDistribution WHERE ContentDocumentId IN:contDocIdSet ORDER BY CreatedDate DESC LIMIT 1];
                        System.debug('conDisList == >'+conDisList[0].DistributionPublicUrl);
                        temp = [SELECT Id, Subject,Name, HtmlValue, Body FROM EmailTemplate WHERE Name ='PreView Upload File' LIMIT 1];
                        String htmlBody = temp.HTMLValue;
                        String plainTextBody = temp.body;
                        plainTextBody = plainTextBody.replace('{!Lead.Name}', ledRec.Name);
                        plainTextBody = plainTextBody.replace('{!Lead.Id}', ledRec.Id);
                         plainTextBody = plainTextBody.replace('{!ContentDistribution.DistributionPublicUrl}', conDisList[0].DistributionPublicUrl);
                        htmlBody = htmlBody.replace('{!Lead.Name}', ledRec.Name);
                        htmlBody = htmlBody.replace('{!Lead.Id}', ledRec.Id);
                        htmlBody = htmlBody.replace('{!ContentDistribution.DistributionPublicUrl}',conDisList[0].DistributionPublicUrl);
                        mailTemp.setHtmlBody(htmlBody);
                        mailTemp.setSubject(temp.subject);
                        mailTemp.setPlainTextBody(plainTextBody);
                        mailTemp.toAddresses = new String[] {ledRec.Email};
                        mailList.add(mailTemp);
                         if(!mailList.isEmpty()){
                              Messaging.sendEmail(mailList);
                             return ledRec.Email;
                         }
                    }
                }
            }
            
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    //   =========================================================================================================================================================================
    
    // Lead convert Aura Controller
    @AuraEnabled
    public static leadConverWrapper convertLead(string recordId){
        List<leadConverWrapper> wrapList = new List<leadConverWrapper>();
        system.debug('recordId-->' + recordId);
        // String leadId = '';
        for(Lead leadObj : [SELECT Id,Name,Email,isConverted FROM Lead WHERE Id =:recordId AND isConverted = false]){
            System.debug('leadObj :::'+leadObj);
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadObj.Id);
            lc.setDoNotCreateOpportunity(false);
            LeadStatus convertStatus = [SELECT Id, MasterLabel, IsConverted FROM LeadStatus WHERE IsConverted = true limit 1];
            System.debug('convertStatus ::'+convertStatus);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            try{
                leadConverWrapper wrap = new leadConverWrapper();
                Database.LeadConvertResult lcResults = Database.convertLead(lc);
                if(lcResults !=null){
                    wrap.accId = lcResults.getAccountId();
                    wrap.conId = lcResults.getContactId();
                    wrap.oppId = lcResults.getOpportunityId();
                    wrapList.add(wrap);
                }
                System.debug('lcResults :::'+lcResults);
                return wrapList[0];
            }catch(Exception e){
                System.debug('Error ::'+e.getMessage() + ' && Error Line ::'+e.getLineNumber());
            }
        }
        return null;
    }
    
    public class leadConverWrapper{
        @AuraEnabled public Id accId;
        @AuraEnabled public Id conId;
        @AuraEnabled public Id oppId;
    }
    
    //   =========================================================================================================================================================================
    // Get all Objects in Salesforce
    // Method 1
    @AuraEnabled
    Public Static List<String> getObjList(){
        List<String> objectList = new List<String>();
        List<Schema.SObjectType> objList = Schema.getGlobalDescribe().Values();     
        for(Schema.SObjectType obj : objList) {   
            if(obj.getDescribe().getName().contains('Account')){
                objectList.add(obj.getDescribe().getName());
            }
            if(obj.getDescribe().getName().contains('Opportunity')){
                objectList.add(obj.getDescribe().getName());
            }
            if(obj.getDescribe().getName().contains('Contact')){
                objectList.add(obj.getDescribe().getName());
            }
            if(obj.getDescribe().getName().contains('User')){
                objectList.add(obj.getDescribe().getName());
            }
            if(obj.getDescribe().getName().contains('Task')){
                objectList.add(obj.getDescribe().getName());
            }
            if(obj.getDescribe().getName().contains('Lead')){
                objectList.add(obj.getDescribe().getName());
            }
            if(obj.getDescribe().getName().contains('Case')){
                objectList.add(obj.getDescribe().getName());
            }
            if(obj.getDescribe().getName().contains('Invoice__c')){
                objectList.add(obj.getDescribe().getName());
            }
        }
        objectList.sort();
        for(String obj : objectList){
            System.debug('obj In String ---> '+obj);
        }
        System.debug('Object List Size ::'+objectList.size());
        return objectList;
    }
    
    // =========================================================================================================================================================================
    
    // Gel Object Fields from  Salesforce
    @AuraEnabled
    public Static List<String> getAllFieldsOfSobject(String SobjectApiName){
        List<String> getAllFieldslist = new List<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keyset() )
        {
            //  system.debug('fieldName->>'+fieldName); // This will give you the api name of the field name.
            getAllFieldslist.add(fieldName);
        }
        for(String field : getAllFieldslist){
            System.debug('field In String ---> '+field);
        }
        return getAllFieldslist;
    }
    
    
    // =========================================================================================================================================================================
    
    @AuraEnabled
    public Static Map<String, String> getListOfFieldsFromObject(String SobjectApiName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType myobjectSchema = schemaMap.get(SobjectApiName);
        Map<String, Schema.SObjectField> fieldMap = myobjectSchema.getDescribe().fields.getMap();
        Map<String, String> filedLabel_NameMap = new Map<String, String> ();
        for (String fieldName: fieldMap.keySet()) {
            //  filedLabel_NameMap.add(fieldMap.get(fieldName).getDescribe().getLabel());
            // System.debug('filedLabel_NameMap :::'+filedLabel_NameMap);
            //  filedLabel_NameMap.add(fieldName);
            // System.debug('filedLabel_NameMap ::'+filedLabel_NameMap);
            filedLabel_NameMap.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());
            System.debug('filedLabel_NameMap ::'+filedLabel_NameMap);
        }
        System.debug('filedLabel_NameMap Size ::'+filedLabel_NameMap.size());
        return filedLabel_NameMap;
    }
    
    // =========================================================================================================================================================================
    @AuraEnabled
    public Static List<Contact> geAccountRelatedContactList(String accountId){
        List<Contact> conList = [SELECT id,Name,Email FroM Contact Where AccountId =:accountid];
        System.debug('conList ===> '+conList.size());
        return conList;
    }
    
    // =========================================================================================================================================================================
   
    // Apex Class to get Object API Name List using Record for Record update
    @AuraEnabled
    public Static Product2 getObjectAPINameUsingRecordId(String productId){
        try{
            Product2 prod = new Product2();
            prod.id = productId;
            System.debug('prod === >'+prod);
            return prod;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
      return null;
    }
    
    // =========================================================================================================================================================================
    
    // Method for getting All ContentVersion from ContentDocument for Image Gallery
     @AuraEnabled
    public static List<ContentVersion> getAllContentsVersion() {
        Set<Id> contentIds = new Set<Id>();
        for (ContentDocument cont :[Select Id ,Title,FileType from ContentDocument WHERE FileType !='PDF']) {
            contentIds.add(cont.Id);
        }
        return [SELECT Id,Title FROM ContentVersion WHERE ContentDocumentId IN :contentIds];
    }
  

    // =========================================================================================================================================================================

    
}