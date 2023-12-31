public class ProtectPDFDocument {  
    
    String API_KEY = Label.PDF_Api_Key;
    String fileName = 'Payment Receipt - Online Bill(LT)'; // File name "sample.pdf" which is available in Files.
    String currentTime = String.valueOf(System.now());
    string DestinationFile =  'PasswordProtected_'+currentTime+'_.pdf'; //This is the Desitantion File Name.
    List<ContentVersion> getAllContentVersion = [SELECT Id,Title FROM ContentVersion];
   
    // Passwords to protect PDF document
    // The owner password will be required for document modification.
    // The user password only allows to view and print the document.
    string OwnerPassword = '123456';
    string UserPassword = 'dinesh2023';

    // Encryption algorithm. 
    // Valid values: 'RC4_40bit', 'RC4_128bit', 'AES_128bit', 'AES_256bit'.
    string EncryptionAlgorithm = 'AES_128bit';

    public void startProcessing(){
        ContentVersion cv = [select Title, VersionData from ContentVersion where Title = :fileName limit 1];
        Blob SourceFile  = cv.VersionData;
        
        try{
            //1. Prepare URL for "Get Presigned URL" API call
            string url = 'https://api.pdf.co/v1/file/upload/get-presigned-url?contenttype=application/octet-stream&name=:fileName'; 
            HttpRequest req = new HttpRequest();
            req.setHeader('x-api-key', API_KEY);
            req.setEndpoint(url);
            req.setMethod('GET');
            req.setTimeout(60000);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            if(res.getStatusCode() == 200) {
                System.Debug('res ' + res);
                Map<String, Object> deserializedBody =  (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                system.debug('deserializedBody == >'+deserializedBody);
                Boolean isError = Boolean.ValueOf(deserializedBody.get('error'));
                if(isError == false){
                    // Get URL to use for the file upload
                    String uploadUrl = String.ValueOf(deserializedBody.get('presignedUrl'));
                    // Get URL of uploaded file to use with later API calls
                    String uploadedFileUrl = String.ValueOf(deserializedBody.get('url'));
                    // 2. UPLOAD THE FILE TO CLOUD.
                    if(uploadFile(API_KEY, uploadUrl, SourceFile)){
                        // 3. Add Password to Uploaded file and download.
                        AddProtectionToInputPDF(API_KEY, DestinationFile, uploadedFileUrl, OwnerPassword, UserPassword, EncryptionAlgorithm);
                    }
                }
            }
            else{
                System.debug('Error Response === > ' + res.getBody() + ' &&  Status === >' + res.getStatus() + ' && Response String === >' + res.toString()); 
            }
        }
        catch(Exception ex){
            String errorBody = 'Message: ' + ex.getMessage() + ' -- Cause: ' + ex.getCause() + ' -- Stacktrace: ' + ex.getStackTraceString();
            System.Debug(errorBody);
        }
    }
    
    @TestVisible
    public static boolean uploadFile(String API_KEY, String url, Blob sourceFile){
        HttpRequest req = new HttpRequest();
        req.setHeader('x-api-key', API_KEY);
        req.setHeader('Content-Type', 'application/octet-stream');
        req.setEndpoint(url);
        req.setMethod('PUT');
        req.setTimeout(60000);
        req.setBodyAsBlob(sourceFile);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if(res.getStatusCode() == 200) {
            System.Debug(res);
            return true;
        }
        else{
            System.debug('Error Response ' + res.getBody());
            System.Debug(' Status ' + res.getStatus());
            System.Debug(' Status Code' + res.getStatusCode());
            System.Debug(' Response String' + res.toString());
            return false;
        }
    }
    
    public static void AddProtectionToInputPDF(String API_KEY, String DestinationFile, String uploadedFileUrl, String ownerPassword, String userPassword, String encryptionAlgorithm){
        Map<string, object> parameters = new Map<string, object>();
        parameters.put('name', DestinationFile);
        parameters.put('url', uploadedFileUrl);
        parameters.put('ownerPassword', ownerPassword);
        parameters.put('userPassword', userPassword);
        parameters.put('encryptionAlgorithm', encryptionAlgorithm);
        string jsonPayload = Json.serialize(parameters);
        String url = 'https://api.pdf.co/v1/pdf/security/add';
        HttpRequest req = new HttpRequest();
        req.setHeader('x-api-key', API_KEY);
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setTimeout(60000);
        req.setBody(jsonPayload);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if(res.getStatusCode() == 200) {
            System.Debug(res);
            Map<String, Object> deserializedBody =  (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            Boolean isError = Boolean.ValueOf(deserializedBody.get('error'));
            if(isError == false){
                String resultFileUrl = String.ValueOf(deserializedBody.get('url'));
                downloadPDFAndStore(resultFileUrl, DestinationFile);
            }
        }
        else{
            System.debug('Error Response ' + res.getBody());
            System.Debug(' Status ' + res.getStatus());
            System.Debug(' Status Code' + res.getStatusCode());
            System.Debug(' Response String' + res.toString());
        }
    }
    
    @TestVisible
    private static void downloadPDFAndStore(String extFileUrl, String DestinationFile)
    {
        Http h = new Http(); 
        HttpRequest req = new HttpRequest(); 
        extFileUrl = extFileUrl.replace(' ', '%20'); 
        req.setEndpoint(extFileUrl); 
        req.setMethod('GET'); 
        req.setHeader('Content-Type', 'application/pdf');
        req.setCompressed(true); 
        req.setTimeout(60000); 
        //Now Send HTTP Request
        HttpResponse res  = h.send(req); 
        if(res.getStatusCode() == 200) 
        {
            blob fileContent = res.getBodyAsBlob();
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
            conVer.PathOnClient = DestinationFile + '.pdf'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = DestinationFile; // Display name of the files
            conVer.VersionData = fileContent;
            insert conVer;
            System.Debug('Success');
        }
        else
        {
            System.debug('Error Response ' + res.getBody());
            System.Debug(' Status ' + res.getStatus());
            System.Debug(' Status Code' + res.getStatusCode());
            System.Debug(' Response String' + res.toString());
        }
    }
}