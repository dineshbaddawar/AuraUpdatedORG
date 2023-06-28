public class LeadCreationOnQRScan {

     @AuraEnabled
    Public Static Lead LeadCreation(string firstName,String LastName,string Phone,string Email,Id recordId){
        
        Lead ld=new Lead();
        ld.FirstName=firstName;
        ld.LastName=LastName;
        ld.Phone=Phone;
        ld.Email=Email;
        ld.Company='Company';
        ld.Account__c=recordId;
        insert ld;
        System.debug('Lead Rec ::'+ld);
        return ld;
    }
}