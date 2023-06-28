public without sharing class HttpUtility {
    
    static Source_Org_Configuration__c orgObj;
    static HttpUtility httpUtilityInstance;
    public HttpUtility() {}

    public static HttpUtility getInstance() {
        if(httpUtilityInstance == null) {
            httpUtilityInstance = new HttpUtility();
            orgObj = Source_Org_Configuration__c.getInstance();
        }
        return httpUtilityInstance;
    }

    public  Map<String,String> httpReqHelper(Map<String,String> headerMap, String method, String jsonBody, String endPoint) {
        
        Map<String,String> respMap = new Map<String,String>();
        
        Integration_Log__c logger = new Integration_Log__c();
        logger.HTTP_Method__c = method;
        logger.Integration_Type__c = 'CALLOUT';
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(endPoint);
        httpRequest.setMethod(method);
        httpRequest.setBody(jsonBody);
        httpRequest.setTimeout(Integer.valueOf(Constants.Request_TimeOut));
        
        System.debug('Endpoint---'+httpRequest.getEndpoint());

        if(!headerMap.isEmpty()){
            for(String key : headerMap.keySet()){
                httpRequest.setHeader(key,headerMap.get(key)); 
            }
        }
        try {
            Http http = new Http();
            logger.Start_Date_And_Time__c = System.now();
            HTTPResponse response = http.send(httpRequest);
            logger.End_Date_And_Time__c = System.now();
            
            respMap.put('code',String.valueOf(response.getStatusCode()));
            respMap.put('status',response.getStatusCode() == 200 || response.getStatusCode() == 201?'Success':'Failure');
                        
            if(orgObj != null && orgObj.Enable_Integration_Logger__c)
                createLog(logger, httpRequest, response);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                respMap.put('message',response.getBody());
                return respMap;
            }
            
            respMap.put('message',response.getBody());

            return respMap;
            
        }catch (Exception e) {
            System.debug('--- e-message '+ e.getMessage());
            System.debug('--- e-line-no '+ e.getLineNumber());
            HandleBusinessException.captureError('HttpUtility', 'httpReqHelper', e);
            
            respMap.put('code','404');
            respMap.put('status','Failure');
            respMap.put('message',e.getMessage()+'At Line No -- ' + e.getLineNumber());
            return respMap;
        }

    }

    public void createLog(Integration_Log__c logger, HttpRequest httpReq, HttpResponse httpRes) {
        if(httpReq != null) {
            logger.Request_Body__c = httpReq.getBody();
            logger.EndPoint__c = httpReq.getEndPoint();
        }
        if(httpRes != null) {
            logger.Response_Body__c = httpRes.getBody();
            logger.Response_Status_Code__c = httpRes.getStatusCode();
        }
        insert logger;
    }
}