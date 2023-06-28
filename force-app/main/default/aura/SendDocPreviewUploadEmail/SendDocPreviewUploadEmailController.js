({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.sendDocumentPreviewURL");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var data = response.getReturnValue();
                if(data !=null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Email Send Successfully !',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    $A.get('e.force:refreshView').fire();
                }else{
                    var errors = action.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            var errormsg = errors[0].message;
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Error',
                                message:errormsg,
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'error',
                                mode: 'pester'
                            });
                            toastEvent.fire();
                            var dismissActionPanel = $A.get("e.force:closeQuickAction");
                            dismissActionPanel.fire();
                        }
                    }
                }
            } else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (state=== "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
            
        });
        $A.enqueueAction(action);
    }
})