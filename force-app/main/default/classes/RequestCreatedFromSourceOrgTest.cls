@isTest
public class RequestCreatedFromSourceOrgTest  
{
    public Static testMethod void testingRequestCreatedFromSourceOrg()
    {
         Source_Org_Configuration__c soc = new Source_Org_Configuration__c();
        soc.Enable_Integration_Logger__c = true;
        soc.Org_Id__c = '1234';
         insert soc;
         
        Request__c req = new Request__c();
         req.Subject__c = 'sub';
         String  requestId = 'abc';
        insert req;
       
        test.startTest();
        RequestCreatedFromSourceOrg.createCaseRequestInTargetOrg(req.Id);
        RequestCreatedFromSourceOrg.getContentVersionDetails(req.Id);
        RequestCreatedFromSourceOrg.getRequestDetails(req.Id);
        test.stopTest();
       
    }

}