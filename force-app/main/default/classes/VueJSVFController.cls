public class VueJSVFController {
    
    @RemoteAction
    public static List<Account> getAccounts() {
        return [SELECT Name, Phone, Website FROM Account LIMIT 5 ];
    }
    
    @RemoteAction
    public Static String DeleteAccountUsingId(String accountId){
        delete[SELECT Id FRoM Account Where Id =: accountId];
        return 'SUCCESS';
    }
    
    @RemoteAction
    public Static String DeleteAccountRecord(Account acc){
        delete acc;
        return 'SUCCESS';
    }

    @RemoteAction
    public Static Account updateSelectedAccount(String accName, String accPhone, String accwebsite,String accId){
        Account acc = new Account();
        acc.Id = accId;
        acc.name = accName;
        acc.Phone = accPhone;
        acc.Website = accwebsite;
        update acc;
        System.debug('Update Acc Record ::'+acc );
        return acc;
    }
}