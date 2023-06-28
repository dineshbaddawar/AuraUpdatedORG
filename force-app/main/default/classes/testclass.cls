public class testclass {
    
    public Static void AfterInsert(List<Lead> ledList){
        System.debug('Insert Record Details ===>'+ledList);
        if(ledList[0].Phone !=null || ledList[0].Email !=null || ledList[0].Alternate_Phone__c !=null || ledList[0].Alternate_Email__c !=null){
            testclass.getInsertedLeadRecord(ledList[0].Email,ledList[0].Phone,ledList[0].Alternate_Email__c,ledList[0].Alternate_Phone__c,ledList[0].Id);
        }
        
    }
    public Static void getInsertedLeadRecord(String email,String phone,String alterEmail,String alterPhone,String insertedRecordId){        
        if(!String.isBlank(email) || !String.isBlank(phone) || !String.isBlank(alterEmail) || !String.isBlank(alterPhone)){
            System.debug('email ==> '+email + ' && phone ====> '+phone + ' && alterEmail ===> '+alterEmail + ' && alterPhone ===> '+alterPhone);
            Set<Id> IdSetDeleteRecordLead = new Set<Id>();
            Set<Id> IdSetDeleteRecordOpportunity = new Set<Id>();
            List<Lead> oldListLeadEmailRecord = new  List<Lead>();
            List<Opportunity> oldOppEmailRecordList = new List<Opportunity>();
            oldListLeadEmailRecord = [SELECT Id,Email,Phone,Alternate_Phone__c,Alternate_Email__c FROM Lead] ;
            oldOppEmailRecordList = [SELECT Id,Name,Email__c,Phone__c FROM Opportunity WHERE Phone__c !=null AND Phone__c !=null];
            for(Lead led : oldListLeadEmailRecord){
                if (email !=null && led.Email !=null){
                    if(email == led.email ){
                        System.debug('Email Matched');
                        IdSetDeleteRecordLead.add(insertedRecordId);
                    }
                } else if(phone !=null && led.phone !=null  ){
                    if(phone == led.Phone){
                        System.debug('Phone Matched');
                        IdSetDeleteRecordLead.add(insertedRecordId);
                    }
                }else if(alterEmail !=null && led.Alternate_Email__c !=null){
                    if(alterEmail == led.Alternate_Email__c){
                        System.debug('Alternate_Email__c Matched');
                        IdSetDeleteRecordLead.add(insertedRecordId);
                    }
                }else if(alterPhone !=null && led.Alternate_Phone__c !=null){
                    if(alterPhone == led.Alternate_Phone__c){
                        System.debug('Alternate_Phone__c Matched');
                        IdSetDeleteRecordLead.add(insertedRecordId);
                    }
                }
            }
            
            for(Opportunity opp: oldOppEmailRecordList){
                if(phone == opp.Phone__c){
                    System.debug('Opportunity Email Matched');
                    IdSetDeleteRecordOpportunity.add(insertedRecordId);
                }else if(email == opp.Email__c){
                    System.debug('Opportunity Phone Matched');
                    IdSetDeleteRecordOpportunity.add(insertedRecordId);
                }
            }
            
            System.debug('IdSet ID Lead ==> '+IdSetDeleteRecordLead);
            System.debug('IdSet Lead ==> '+IdSetDeleteRecordLead.size());
            if(IdSetDeleteRecordLead.size() > 0){
                delete [SELECT Id,Name FROM Lead WHERE Id IN:IdSetDeleteRecordLead]; 
            }
            System.debug('IdSet ID Opportunity ==> '+IdSetDeleteRecordLead);
            System.debug('IdSet Opportunity ==> '+IdSetDeleteRecordLead.size());
            if(IdSetDeleteRecordOpportunity.size() > 0){
                delete [SELECT Id,Name FROM Opportunity WHERE Id IN:IdSetDeleteRecordOpportunity]; 
            }
            
        }
    }
    
    @AuraEnabled
    public Static Account getRecorDetailsfrom(String recordId){
        Account acc = [SELECT Id,Name,Rating,Phone FROM Account Where Id =:recordId LIMIT 1];
        
        // Map<String,<String>> MapWithSetionFiled_Value = new Map<String,Map<String,String>>();
        Map<String,List<String>> SectionWithfiledName = new Map<String,List<String>>();
        
        System.debug('acc === >'+acc);
        return acc;
    }
    
    @AuraEnabled
    public Static Product2 getProductDetails(String recordId){
        Product2 acc = [SELECT Id,Name,Family,Type FROM Product2 Where Id =:recordId LIMIT 1];
        System.debug('acc === >'+acc);
        return acc;
    }
    
    public Static void sendEmailToLead(List<Lead> newleadList){
        try{
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for(Lead led : newleadList){
                String[] toAddresses = new String[] {led.Email};
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toAddresses);
                mail.setSubject('New Account Created: ');
                mail.setPlainTextBody('A new User has been');
                emails.add(mail);
            }
            Messaging.sendEmail(emails);
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            
        }
        
    }
}