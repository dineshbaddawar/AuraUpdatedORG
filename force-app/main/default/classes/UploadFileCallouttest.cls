@isTest()
public class UploadFileCallouttest  implements HttpCalloutMock
{
    public HttpResponse respond(HTTPRequest req)
    {
     HttpResponse res = new HttpResponse();
     res.setStatus('OK');
     res.setStatusCode(200);
     res.setBody('Salesforcescool');
     return res;
   }
    public Static testMethod void UploadFileCallouttest()
    {
      //  String fileName = 'abc';
     //   Blob fileBody = def. ;
      //  String reqId ='123';
      //  String ext='ext';
        
        Request__c req = new Request__c();
         req.Subject__c = 'sub';
         String  requestId = 'abc';
        insert req;
         ContentVersion contentVersion = new ContentVersion(Title = 'Penguins',PathOnClient = 'Penguins.ext',VersionData = Blob.valueOf('Test Content'),IsMajorVersion = true);
        insert contentVersion;
        if(Test.isRunningTest())
        {
            test.startTest();
            Test.setMock(HttpCalloutMock.class, new UploadFileCallouttest());
            UploadFileCallout.uploadFile(contentVersion.Title,contentVersion.VersionData,req.Id,contentVersion.PathOnClient);
            test.stopTest();
      } else
      {
          system.debug('qwert');
      }
       
    }

}