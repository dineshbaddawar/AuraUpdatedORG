public class TaxExemptionForm {
    public List<Invoice__c> invoiceRecList {get;set;}
    public Opportunity oppRec {get;set;}
    
    public TaxExemptionForm(ApexPages.StandardController controller) {
        String oppId = ApexPages.currentPage().getParameters().get('Id');
        
        oppRec=[select Account.Id,CloseDate,Name,Billing_Contact__r.Name,MainCompetitors__c,TrackingNumber__c, Account.Name,Account.BillingStreet,Account.BillingCity,Account.BillingState, Account.ShippingCity,Amount,LeadSource,ExpectedRevenue, 
                Billing_Contact__r.MailingStreet,Billing_Contact__r.MailingCity,Billing_Contact__r.MailingState,Billing_Contact__r.MailingPostalCode,Billing_Contact__r.MailingCountry,StageName,NextStep,
                Account.ShippingStreet,Account.ShippingState,Account.ShippingCountry from Opportunity where Id=:oppId];
        invoiceRecList = [SELECT Id,Name,Invoice_Amount__c,Invoice_Date__c,Due_Date__c,Opportunity__c,Payment_Status__c FROM Invoice__c WHERE Opportunity__c =:oppId];
        System.debug('invoiceRecList ::'+invoiceRecList);
    }
}