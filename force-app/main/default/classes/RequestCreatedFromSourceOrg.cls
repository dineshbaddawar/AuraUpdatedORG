public class RequestCreatedFromSourceOrg {
    
    public static String createCaseRequestInTargetOrg(String requestId){
        String endpoint  = 'callout:Target_Org'+Constants.CREATE_CASE;
        System.debug('endpoint === >'+endpoint);
        Map<String,String> headerMap = new Map<String,String>(); // This ORG Access Token
        headerMap.put('Authorization','Bearer 00D5h000006cu5z!ARsAQOZs2.t8UM8mpVRWxtBPrRVAE77O3YauKZV7CGmukzcJ4jCv5v5JMHbC12vtW1hgxPxXPiPEpGhLnyUpzf7WQpJC7C6F');
        headerMap.put('Content-Type','application/json');
        
        System.debug('HeaderMap===== >'+headerMap);
        Request__c req = getRequestDetails(requestId);
        String jsonBody = JSON.serialize(createCaseWrapper(req));
        System.debug('Body======'+jsonBody); 
        Map<String,String> respMap = HttpUtility.getInstance().httpReqHelper(headerMap,'POST',jsonBody,endPoint);
        if (respMap.get('code') == '302') {
            String redirectUrl = respMap.get('Location');
            System.debug('redirectUrl == >'+redirectUrl);
        }

        if(respMap.get('code')!='200' && respMap.get('code')!='201'){
            return 'Failed - API STATUS CODE - '+respMap.get('code')+respMap.get('message');
        }
        else{
           
            return 'Success';
        }
        
    }
    
    public static Request__c getRequestDetails(String requestId){
        return [SELECT Id, Name, Subject__c, Status__c, Priority__c, Type__c, Description__c, Origin__c, Reason__c FROM Request__c WHERE Id=: requestId];
    }
    
  
    
    public static caseCreationWrapper createCaseWrapper(Request__c reqRec){

        Source_Org_Configuration__c orgObj = Source_Org_Configuration__c.getInstance();
        caseCreationWrapper wrap = new caseCreationWrapper();
        wrap.orgid = orgObj.Org_Id__c;
        cls_case csWrapper = new cls_case();
        csWrapper.subject = reqRec.Subject__c;
        csWrapper.status = reqRec.Status__c;
        csWrapper.priority = reqRec.Priority__c;
        csWrapper.type = reqRec.Type__c;
        csWrapper.description = reqRec.Description__c;
        
        wrap.caseCls = csWrapper;
        return wrap;
    }
    
    public class caseCreationWrapper{
        public String orgid;	
        public cls_case caseCls;
    }
    public class cls_case {
        public string subject;
        public string status;
        public string priority;
        public string type;
        public string description;
    } 
}