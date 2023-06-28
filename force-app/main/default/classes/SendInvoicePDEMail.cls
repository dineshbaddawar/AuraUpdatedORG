public class SendInvoicePDEMail {
    
    @AuraEnabled 
    Public Static String sendCustomerPdfWithEmail(String recordId){
        Opportunity opp = [SELECT Id,Name,Billing_Contact__r.Name,Billing_Contact__r.Email,AccountId FROM Opportunity WHERE Id =:recordId];
        EmailTemplate temp = [SELECT Id,Subject,Body,HTMLValue FROM EmailTemplate WHERE Name ='On Invoice generation'];
        Account acc = [SELECT Id,Name FROM Account WHERE Id =: opp.AccountId];
        List<Contact> conList =   [SELECT Id,Name,Email FROM Contact WHERE AccountId =: acc.Id ];
        
        DateTime fileNo = System.now();
        fileNo.format('HH:mm:ssXXX');
        PageReference pdfPage = Page.InvoicePDF;
        pdfPage.getParameters().put('id',opp.Id);
        Blob pdfBody;
        pdfBody = pdfPage.getContent();
        
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName('Invoice'+fileNo+'pdf');
        attach.setInline(false);
        attach.Body = pdfBody;  
        
        String subject = temp.Subject;
        String plainTextBody = temp.body;
        for(Contact con : conList){
            System.debug('con Email ::'+con.Email);
            String htmlBody = temp.HTMLValue;
            htmlBody = htmlBody.replace('{!Opportunity.Name}', con.Name); 
            subject = subject.replace('{!Opportunity.Name}', opp.Name); 
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setHtmlBody(htmlBody);
            mail.setSubject(subject);
            mail.setPlainTextBody(plainTextBody);
            mail.setToAddresses(new String[] {con.Email});
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
            mailList.add(mail);
        }
        if(!mailList.isEmpty()){
            Messaging.sendEmail(mailList);
        }
        return opp.Id;
    }
}