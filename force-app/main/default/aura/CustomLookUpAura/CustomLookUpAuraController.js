({
    doInit : function(component, event, helper) {
        debugger;
        // let thirdAction = component.get('c.saveRecord');
        // $A.enqueueAction(thirdAction);
    },
    
    saveRecord : function(component, event, helper){
        debugger;
        var action = component.get("c.insertContactOnAccountRecordPage");
        var firstname = component.get("v.firstname");
        action.setParams({
            "currentaccountid" : component.get("v.recordId"),
            "firstname" : component.get("v.firstname"),
            "lastname" : component.get("v.lastname"), 
            "phone" : component.get("v.phone"),
            "email" : component.get("v.email")
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var  data = response.getReturnValue();
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    title : 'Success', message: 'Record Created Successfully !', duration:' 5000', key: 'info_alt', type: 'success', mode: 'pester' 
                });
                resultsToast.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                 $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
})