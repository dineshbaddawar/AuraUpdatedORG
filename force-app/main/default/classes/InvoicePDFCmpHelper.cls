public class InvoicePDFCmpHelper {
    
    @AuraEnabled(continuation=true cacheable=true)
    public static String attachFileToOppotunities(Id OpportunityId) {
        try{
            Continuation con = new Continuation(40);
            
            List<Attachment> attachList = new List<Attachment>();
            PageReference pdfPage = Page.InvoicePDF;
            pdfPage.getParameters().put('id',OpportunityId);
            blob pdfBody;
            pdfBody = pdfPage.getContent();
            DateTime fileNo = System.now();
            fileNo.format('HH:mm:ssXXX');
            Datetime now = Datetime.now();
            Integer offset = UserInfo.getTimezone().getOffset(now);
            Datetime local = now.addSeconds(offset/1000);
            System.debug('Now New :'+local);
            
            Attachment attach = new Attachment();
            attach.Body = pdfBody;
            attach.Name = 'Invoice Pdf_'+local;
            attach.IsPrivate = false;
            attach.ParentId = OpportunityId;
            attach.ContentType = 'application/pdf';
            attachList.add(attach);
            
            insert attachList;
            system.debug('attachList'+attachList);
            return attachList[0].Id;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return 'ERROR';
        }
        
    }
}