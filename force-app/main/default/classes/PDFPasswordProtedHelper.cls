public class PDFPasswordProtedHelper {
    
    public PageReference downloadPDF(){
        String password = generatePassword();
        // Load the PDF file
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        String pdfFileUrl = sfdcBaseURL+'/servlet/servlet.FileDownload?file=00P5h00000AVJN3EAP&operationContext=S1'; // Replace with the URL of your PDF file
        Blob pdfBlob = loadFileFromUrl(pdfFileUrl);
        System.debug('pdfBlob === >'+pdfBlob);
        
        // Encrypt the PDF file
        /*
        PdfDocument document = PdfReader.Open(new MemoryStream(pdfBlob), PdfDocumentOpenMode.Import);
        PdfSecuritySettings securitySettings = document.SecuritySettings;
        securitySettings.OwnerPassword = password;
        securitySettings.UserPassword = password;
        securitySettings.PermitAccessibilityExtractContent = false;
        securitySettings.PermitAnnotations = false;
        securitySettings.PermitAssembleDocument = false;
        securitySettings.PermitExtractContent = false;
        securitySettings.PermitFormsFill = true;
        securitySettings.PermitFullQualityPrint = false;
        securitySettings.PermitModifyDocument = false;
        securitySettings.PermitPrint = false;
        */
        return null;
    }
    
    public String generatePassword() {
        // Generate a random 8-character password
        String pass = String.valueOf(Crypto.getRandomInteger()).substring(0, 8);
        return pass;
    }
    
    public Blob loadFileFromUrl(String url) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Blob responseBody = response.getBodyAsBlob();
        System.debug('responseBody === >'+responseBody);
        return response.getBodyAsBlob();
    }
}