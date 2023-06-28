public class GeoLocationMapCmpController {
    
    @AuraEnabled
    public static List<Account> fetchAccountsForMap(){
        return [SELECT Id, Name, Geo_Location__Latitude__s, Geo_Location__Longitude__s, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account];
    }
    
}