public without sharing class LeadCreation {
    public Campaign ledRec {get;set;}
    public String leadRecordString{get;set;}
    
    Public String statusList {get;set;}
    Public String educationList {get;set;}
    
    Public LeadCreation() {
        String recordId = Apexpages.currentPage().getParameters().get('id'); 
        ledRec = [SELECT Id,Name FROM Campaign WHERE ID =:recordId];
        System.debug('ledRec ::'+ledRec);
        leadRecordString=JSON.serialize(ledRec);
        
        statusList=JSON.serialize(Utility.getPicklistValuesWithNone('Lead', 'Status'));
        educationList=JSON.serialize(Utility.getPicklistValuesWithNone('Lead', 'Education__c')); 
    }
    
    @RemoteAction
    public Static string insertLeadDetails(String leadId,String fname, String lname,String  email, String phone, String education,String status,integer day, integer month, integer year ){
        
        Lead led = new Lead();
        if(fname !=null){
            led.FirstName = fname;
            
        }if(lname !=null){
            led.LastName = lname;
        }
        led.Email =email;
        if(phone !=null){
            led.Phone = phone;
        }
        if(education !=null){
            led.Education__c = education;
        }
        led.Status = status;
        led.Company = 'New';
        led.Alternate_Phone__c = '90989567810';
        if(year !=null && month !=null && day !=null){
            led.Passing_Year__c =Date.newInstance(year, month, day);
        }
        
        Insert led;
        System.debug('Lead Record INSERTED ==>'+led);
        if(led.id !=null){
            // LeadCreation.sendEmailAfterLeadInsert(led.id);
        }
        
        return 'SUCCESS';
    }
    
    Public Static void sendEmailAfterLeadInsert(String recordId){
        System.debug('recordId ===>'+recordId);
        if(!String.isBlank(recordId)){
            EmailTemplate temp = [SELECT Id,Subject,Body,HTMLValue FROM EmailTemplate WHERE Name ='Welcome Lead'];
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            Lead led = [SELECT Id,Name,Email FROM Lead WHERE Id=:recordId LIMIT 1];
            if(led.id !=null){
                String subject = temp.Subject;
                String plainTextBody = temp.body;
                String htmlBody = temp.HTMLValue;
                htmlBody = htmlBody.replace('{!Lead.Name}', led.Name);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                mail.setHtmlBody(htmlBody);
                mail.setSubject(subject);
                mail.setPlainTextBody(plainTextBody);
                System.debug('SetToAddress ===> '+led.Email);
                //  System.debug('SetCCAddress === >'+UserInfo.getUserEmail());
                mail.setToAddresses(new String[] {led.Email});
                //   mail.setCcAddresses(new String[] {UserInfo.getUserEmail()});
                mailList.add(mail);
            }
            if(!mailList.isEmpty()){
                System.debug('Email Sent SuccessFully !');
                Messaging.sendEmail(mailList);
            }
        }
        
    }
}