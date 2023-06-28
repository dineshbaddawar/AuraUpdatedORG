public with sharing class DeleteContactBulk {
    
    public List<Contact> selContactLst;
    public String contactsIds;
    
    
    public DeleteContactBulk(ApexPages.StandardSetController cntlr){
        selContactLst = cntlr.getSelected(); //get selected records from account list view
        contactsIds = '';  
        for(Contact con : selContactLst){
            contactsIds += con.Id + ','; //build list of ids string concatenated with comma                         
        }
        contactsIds = contactsIds.removeEnd(','); 
    }
    
    public PageReference redirectToLC(){
        String returnUrl = '/lightning/cmp/c__DeleteContactCheckbox?c__listofContacts='+contactsIds;
        PageReference pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    @AuraEnabled
    public Static String DeleteSelContact(List<String> conIdSetToDel){
        Integer deletedRecordCount= 0;
        try{
            List<String> lstString = conIdSetToDel[0].split(',');  
            List<Contact> conList = [SELECT Id,Name FROM Contact WHERE ID IN :lstString ];
            Database.DeleteResult[] drList = Database.delete(conList, false);
            for(Database.DeleteResult dr : drList) {
                if (dr.isSuccess()) {
                    System.debug('Successfully deleted account with ID: ' + dr.getId());
                    deletedRecordCount=deletedRecordCount+1;
                }
                else {              
                    for(Database.Error err : dr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
            System.debug('deletedRecordCount === >'+deletedRecordCount);
            return String.valueOf(deletedRecordCount);
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    
}