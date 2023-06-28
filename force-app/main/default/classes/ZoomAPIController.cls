public without sharing class ZoomAPIController {
    @AuraEnabled(cacheable=true)
     public  Static String createMeeting(String Subject,String startSlot,Decimal Duration, String recordId) {
         String EndpointURL = 'https://api.zoom.us/v2/users/ajeet.kumar@utilitarianlab.com/meetings';
         String JWTToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6IndVSUVOeGp6UlBLR1ExVDE4bEhaTUEiLCJleHAiOjE2ODQ0ODEwNzAsImlhdCI6MTY4Mzg3NjI3MX0.IPXEzn6Yf_1jQx0hCLNbRWqu9pjRGeQQw4yaDthH6Rk';
         System.debug('Subject---->>> :'+Subject +' && startSlot --->>>:'+startSlot+' && Duration --->>> :'+Duration );
         Lead led = new Lead();
         try{
             if(!String.isBlank(Subject) && !String.isBlank(startSlot) && !String.isBlank(recordId)){
                 system.debug('startSlot ---->>'+startSlot+' & Duration ----->>'+startSlot);
                 ZoomAPIController.createMeetingWapper newWapper = new ZoomAPIController.createMeetingWapper();
                 newWapper.topic = Subject;
                 newWapper.type = 2;
                 newWapper.start_time = startSlot;
                 newWapper.duration = integer.valueOf(Duration);
                 newWapper.timezone = 'Asia/Kolkata';
                 string jsonString = JSON.serialize(newWapper);
                 String endPoint = EndpointURL;
                 HttpRequest req = new HttpRequest();
                 req.setBody(jsonString);
                 req.setMethod('POST');
                 req.setHeader('Content-type', 'application/json');
                 req.setHeader('Authorization', 'bearer '+JWTToken);
                 req.setEndpoint(endPoint); 
                 Http http = new Http();
                 HttpResponse res = http.send(req);
                 if(res.getStatusCode() == 201){
                    led = [SELECT Id,Name,Meeting_Link__c FROM Lead WHERE ID =: recordId LIMIT 1];
                     if(led.Meeting_Link__c == null){
                         ZoomResponseWrapper respWrapObj = ZoomResponseWrapper.parse(res.getBody());
                         if(respWrapObj.join_url !=null){
                            led.Meeting_Link__c = respWrapObj.join_url;
                             update led;
                             System.debug('Updated Lead Record :'+led);
                         }
                         System.debug('Apex Return Data ::' +respWrapObj.join_url);
                         return respWrapObj.join_url;
                     }
                 }else{
                     System.debug('res fail >>>' +res.getBody());
                     return 'res.getBody()'; 
                 }
             }
         }catch(Exception e){
             System.debug('Error Message :'+e.getMessage() + '& Error Line :'+e.getLineNumber());
             return null;
         }
         return null;
     }

     public class createMeetingWapper{
        Public String topic {get;set;}
        Public Integer type {get;set;}
        Public String start_time {get;set;}
        Public Integer duration {get;set;}
        Public String timezone {get;set;}
        Public String password {get;set;}
    }
}