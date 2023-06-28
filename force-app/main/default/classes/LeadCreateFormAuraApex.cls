public class LeadCreateFormAuraApex {

    
    public LeadCreateFormAuraApex(ApexPages.StandardSetController cntlr){
        
    }
     public PageReference redirectToLC(){
        String returnUrl = '/lightning/cmp/c__LeadCreateFormAura';
        PageReference pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
}