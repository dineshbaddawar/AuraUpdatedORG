public class UploadFileCallout {
    
    @future(callout = true)
    public static void uploadFile(String fileName, Blob fileBody, String reqId, String ext) {
        
        HttpRequest req = new HttpRequest();
        String endPoint = 'callout:Target_Org'+Constants.UPLOAD_FILE;
        req.setEndpoint(endPoint + EncodingUtil.urlEncode(fileName, 'UTF-8'));
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer 00D6D0000000Wfc!ARwAQI4C8EeIxbLdiw.OaRcTZ8IiMCIUmn7ZHGvkVlSpFjOLbmaO3dYMBhU6tUD8KJWCYjA7FIZohhzq5FfnGiUbef2O3Kwc');
        req.setHeader('Content-Type', 'APPLICATION/OCTET-STREAM');
        req.setHeader('linkedEntityId', reqId);
        req.setHeader('FileExtension', ext);
        req.setBodyAsBlob(fileBody);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            System.debug('File uploaded successfully');
        } else {
            System.debug('Error uploading file: ' + res.getStatus());
        }
    }
}