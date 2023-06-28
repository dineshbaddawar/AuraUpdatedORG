public without sharing class SubmitToRaiseQueriesController {

    @AuraEnabled
    public static string doCallout(String reqId){
        System.debug('reqId === >'+reqId);
        return RequestCreatedFromSourceOrg.createCaseRequestInTargetOrg(reqId);
    }
}