public class VeriPhoneController {
    //https://api.veriphone.io/v2/verify?phone=+918446557829&key=EBAE45C7AF374A92AA788AE391FCEFB6
    @AuraEnabled(cacheable=true)
    public static VeriPhoneDescriptorWrapper VerifyPhone(String phoneParam){
        String endpoint = Label.veriphoneURL + 'phone='+phoneParam+'&key='+Label.veriphoneAPIKEY;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        System.debug('request :::'+request);
        HttpResponse response = http.send(request);
        System.debug('===> Response ::c'+response.getBody());
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        System.debug('results :::'+results);
        return new VeriPhoneDescriptorWrapper().parseJSON(response.getBody());
    }
    
    @AuraEnabled
    public Static Contact getCurrentContactPhone(String recordId){
        Contact con = [SELECT Id,Phone FROM Contact Where Id =:recordId];
        System.debug('Current Record ::'+con);
        return con;
    }
}