({
    onPageReferenceChange : function(component, event, helper) {
        debugger;
        var myPageRef = component.get("v.pageReference");
        var label = $A.get("$Label.c.AllAccountListView");
        var AccountRecord = myPageRef.state.c__listofAccounts;
        component.set("v.AccountSelectedId" ,AccountRecord);
        if(AccountRecord.length <0 || AccountRecord == ""){
            alert("Warning")
            helper.showWarning(component, event);
            var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "AllAccountListView" : label,
                "listViewName" : "All Accounts",
                "scope" : "Account"
            });
            navEvent.fire();
        } else {
            var action = component.get("c.DeleteSelectedAccountIds");
            var selectedAccountId = component.get("v.AccountSelectedId");
            action.setParams({
                accountIdSet: selectedAccountId
            });
            action.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    var data = response.getReturnValue();
                    component.set("v.deleteRecordSuccesscount",data);
                    helper.successMessage(component, event); 
                    var navEvent = $A.get("e.force:navigateToList");
                    navEvent.setParams({
                        "AllAccountListView" : label,
                        "listViewName" : "All Accounts",
                        "scope" : "Account"
                    });
                    navEvent.fire();
                }
                
            });
            $A.enqueueAction(action);
        }
    }
})