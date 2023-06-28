global class cAuthURIForApiREq {
    
    global String AuthenticationURI = '';
    
    public cAuthURIForApiREq(String ClientKey, String redirect_uri){
        String key = EncodingUtil.urlEncode(ClientKey, 'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri, 'UTF-8');
        
        String  authuri = 'https://accounts.google.com/o/oauth2/auth?'+
            'client_id='+key+
            '&response_type=code'+
            '&scope=https://www.googleapis.com/auth/drive'+
            '&redirect_uri='+uri+
            '&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&'+
            '&login_hint=dbaddawar@gmail.com&'+
            'access_type=offline';
        AuthenticationURI=authuri;
        System.debug('AuthenticationURI ::--->'+AuthenticationURI);
    }
}