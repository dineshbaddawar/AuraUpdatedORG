({
    doInit : function(component, event, helper) {
        debugger;
        
        var action = component.get("c.getCurrentContactPhone");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        
        
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.phoneValue", data.Phone);
                let callactionmethod = component.get("c.verifyPhoneApiMethod");
                $A.enqueueAction(callactionmethod);
                
            }
        })
        $A.enqueueAction(action);
    },
    
    verifyPhoneApiMethod : function(component, event, helper){
        var action = component.get("c.VerifyPhone");
        action.setParams({
            "phoneParam" : component.get("v.phoneValue")
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                var data = response.getReturnValue();
                if(data.phone_valid != false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Valid phone Number !',
                        message: 'This is a valid phone number from '+data.phone_region +' having '+data.carrier +' as carrier.',
                        duration:' 5000',
                        key: 'check',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'ERROR',
                        message:'Not a valid phone number !',
                        duration:' 5000',
                        key: 'error',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                
            }
        });
        $A.enqueueAction(action);
    }
})