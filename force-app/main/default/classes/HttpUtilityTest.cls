@isTest
public class HttpUtilityTest implements HttpCalloutMock
{
     static HttpRequest    httprequest;
     static HttpResponse   httpresponse ;
     public HttpResponse respond(HTTPRequest req)
    {
        httprequest = req;
     httpresponse  = new HttpResponse();
     httpresponse.setStatus('OK');
     httpresponse.setStatusCode(200);
     httpresponse.setBody('Salesforcescool');
     // httpresponse = res;  
     return httpresponse;
   }
    public static testmethod void testingHttpUtility()
    {
        Integration_Log__c logger = new Integration_Log__c();
        logger.HTTP_Method__c = 'post';
        logger.Integration_Type__c = 'CALLOUT';
        logger.Start_Date_And_Time__c = System.now();
        logger.End_Date_And_Time__c = System.now();
      // insert logger;
        String endpoint  = 'callout:Target_Org'+Constants.CREATE_CASE;
        Map<String,String> headerMap = new Map<String,String>();
        headerMap.put('Authorization','Bearer 00D6D0000000Wfc!ARwAQI4C8EeIxbLdiw.OaRcTZ8IiMCIUmn7ZHGvkVlSpFjOLbmaO3dYMBhU6tUD8KJWCYjA7FIZohhzq5FfnGiUbef2O3Kwc');
        headerMap.put('Content-Type','application/json');
        if(Test.isRunningTest())
        {
            test.startTest();
             Test.setMock(HttpCalloutMock.class, new HttpUtilityTest());
             HttpUtility.getInstance();
               HttpUtility htut = new HttpUtility();
               htut.httpReqHelper(headerMap, 'POST', '{"orgid":"1234","caseCls":{"type":null,"subject":"sub","status":null,"priority":null,"description":null}}', endPoint);
               htut.createLog(logger,httprequest,httpresponse);
            test.stopTest();
      } else
      {
          system.debug('qwert');
      }
        
    }

}