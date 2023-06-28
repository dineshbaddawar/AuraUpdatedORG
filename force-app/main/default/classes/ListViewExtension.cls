public class ListViewExtension {
    public List<Account> selAccounts;
    public String accountIds;
    
    // Constructor
    public ListViewExtension(ApexPages.StandardSetController cntlr){
        selAccounts = cntlr.getSelected(); //get selected records from account list view
        accountIds = '';  
        for(Account acc : selAccounts){
            accountIds += acc.Id + '-'; //build list of ids string concatenated with comma                         
        }
        accountIds = accountIds.removeEnd('-'); 
        System.debug('accountIds >>>>::'+accountIds);
    } 
    
    public PageReference redirectToLC(){
        //'/lightning/cmp/c__LightningComponentName?c__listofAcounts=parameters'
        String returnUrl = '/lightning/cmp/c__ListViewCMP?c__listofAccounts='+accountIds;
        PageReference pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
 }