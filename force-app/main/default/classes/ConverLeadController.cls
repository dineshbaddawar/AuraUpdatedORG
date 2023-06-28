public class ConverLeadController {
    
    @AuraEnabled
    public static leadConverWrapper convertLead(string recordId){
        List<leadConverWrapper> wrapList = new List<leadConverWrapper>();
        system.debug('recordId-->' + recordId);
        // String leadId = '';
        for(Lead leadObj : [SELECT Id,Name,Email,isConverted FROM Lead WHERE Id =:recordId AND isConverted = false]){
            System.debug('leadObj :::'+leadObj);
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadObj.Id);
            lc.setDoNotCreateOpportunity(false);
            LeadStatus convertStatus = [SELECT Id, MasterLabel, IsConverted FROM LeadStatus WHERE IsConverted = true limit 1];
            System.debug('convertStatus ::'+convertStatus);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            try{
                leadConverWrapper wrap = new leadConverWrapper();
                Database.LeadConvertResult lcResults = Database.convertLead(lc);
                if(lcResults !=null){
                    wrap.accId = lcResults.getAccountId();
                    wrap.conId = lcResults.getContactId();
                    wrap.oppId = lcResults.getOpportunityId();
                    wrapList.add(wrap);
                }
                System.debug('lcResults :::'+lcResults);
                return wrapList[0];
            }catch(Exception e){
                System.debug('Error ::'+e.getMessage() + ' && Error Line ::'+e.getLineNumber());
            }
        }
        return null;
    }
    
    public class leadConverWrapper{
        @AuraEnabled public Id accId;
        @AuraEnabled public Id conId;
        @AuraEnabled public Id oppId;
    }
}