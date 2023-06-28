({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.convertLead");
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                
                if(data !=null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'LEAD Converted Successfully !',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    
                    $A.get('e.force:refreshView').fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
})