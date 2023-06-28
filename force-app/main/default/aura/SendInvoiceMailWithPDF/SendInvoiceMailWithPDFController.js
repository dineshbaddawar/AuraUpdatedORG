({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.sendCustomerPdfWithEmail");
        var RecordOId = component.get("v.recordId");
        action.setParams({
            "recordId" : RecordOId
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Sending Invoice to Customer',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Something went wrong',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                
            }
            toastEvent.fire();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    }
})