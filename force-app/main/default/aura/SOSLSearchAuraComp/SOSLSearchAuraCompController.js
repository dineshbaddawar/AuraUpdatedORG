({
    doInit : function(component, event, helper) {
        debugger;
        component.set('v.accountColumns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', type: 'phone'}
        ]);
        component.set('v.contactColumns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Email', fieldName: 'Email', type: 'email'}
        ]);
            component.set('v.opportunityColumns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Stage Name', fieldName: 'StageName', type: 'text'},
            {label: 'Close Date', fieldName: 'CloseDate', type: 'date'}
        ]);
        component.set('v.leadColumns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Company', fieldName: 'Company', type: 'text'},
            {label: 'Email', fieldName: 'Email', type: 'email'}
        ]);
    },
    
    search : function(component, event, helper){
        debugger;
        let secondAction = component.get('c.searchMethod');
        $A.enqueueAction(secondAction)
        component.set("v.showSearchResults", true);
    },
    
    searchMethod: function(component , event , helper){
        debugger;
        var action = component.get("c.getSearchRecords");
        action.setParams({
            "searchKeyValue" : component.get("v.searchKey")
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.accountList", data[0]);
                component.set("v.contactList", data[1]);
                component.set("v.opportunityList", data[2]);
                component.set("v.leadList", data[3]);
               
            }
        });
        $A.enqueueAction(action);
    },
    
    hideSpinner : function(component, event, helper){
        component.set("v.Showspinner", false);
    },
    showSpinner : function(component, event, helper){
        component.set("v.Showspinner", true);
    },
})