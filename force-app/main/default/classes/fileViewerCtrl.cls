public class fileViewerCtrl {

    @AuraEnabled 

    public static List<contentDocument> fetchContentDocument(){
      //  List<ContentDocumentLink> content = [SELECT ContentDocument.title, ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: propId];
      //  System.debug('content ::'+content);
      //  return content;
            
          return  [Select id,Title,FileType,CreatedBy.Name,ContentSize From contentDocument LIMIT 1000];

    }
    
    @AuraEnabled
    public static string getAttachmentId(string propId){
        return [SELECT Id, Name FROM Attachment WHERE ParentID =: propId Order by LastModifiedDate desc LIMIT 1].Id;
    }

}