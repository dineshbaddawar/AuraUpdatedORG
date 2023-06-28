public class InvoicePDFController {
    
    public id OpportunityID {get;set;}
    public List<OpportunityLineItem> oppProductList {get;set;}
    public Invoice__c billInfoForInvoice {get;set;}
    public Opportunity oppDetails {get;set;}
    public aggregateResult TotalQty {get;set;}
    public String AmountInWords {get;set;}
    public List<Invoice__c> paidAmountFromInvoice {get;set;}
    
    
    public string CreatedDate {get;set;}    
    public Double dueAmount {get;set;}
    public Double padiAmountInvoice {get;set;}
    public Double OpportunityAmount {get;set;}
    
    
    public InvoicePDFController(ApexPages.StandardController controller)
    {
        
        string id= ApexPages.currentPage().getParameters().get('id');
        System.debug('IDDD :'+id);
        if(id!=null)
        {
            this.OpportunityID=id;
            this.oppProduct();
            DateTime todaysDate = System.today();
            CreatedDate = todaysDate.format('dd-MM-yyyy');
            System.debug(CreatedDate);
        }
    }
    public void oppProduct()
    {
        this.oppProductList=[Select Id, Description, Quantity, UnitPrice,ServiceDate, TotalPrice from OpportunityLineItem where OpportunityID=:this.OpportunityID order by CreatedDate asc];
        
        this.oppDetails=[select Account.Id, Account.Name,Account.BillingStreet,Account.BillingCity,Account.BillingState, Account.ShippingCity,Amount, 
                         Account.ShippingStreet,Account.ShippingState,Account.ShippingCountry from Opportunity where Id=:this.OpportunityID LIMIT 1];
        this.OpportunityAmount = oppDetails.Amount;
        system.debug('this.oppDetails::'+this.oppDetails);
        this.paidAmountFromInvoice = [Select Name, Invoice_Date__c, Payment_Status__c, Amount__c from Invoice__c  where Opportunity__c = :this.OpportunityID AND Payment_Status__c ='Paid'];
        this.padiAmountInvoice  = 0;
        for(Invoice__c inv  : this.paidAmountFromInvoice){
            this.padiAmountInvoice = this.padiAmountInvoice + inv.Amount__c;
        }
       
        this.dueAmount = this.OpportunityAmount - this.padiAmountInvoice;
         Integer i = Integer.valueOf(this.dueAmount);
        AmountInWords = NumberToText.convert(i);
        
    }
}