public class cGoogleAppAuthenticationWithSalesforce {

  
    
    Public String redirectURL = 'https://www.linkedIn.com';
    public String clientId = '38222227038-h40jajd44ttoc5pel23s2kpt1knhsuf8.apps.googleusercontent.com';
    public cGoogleAppAuthenticationWithSalesforce(){
        
    }
    
    public PageReference DriveAuth(){
        String UrL = 'https://accounts.google.com/o/oauth2/auth?scope=https://www.googleapis.com/auth/drive&response_type=code&access_type=offline&redirect_uri='+redirectURL+'&client_id='+clientId;
        PageReference pg = new PageReference(UrL);
        System.debug('pg ::---->'+pg);
        return pg;
    }
}