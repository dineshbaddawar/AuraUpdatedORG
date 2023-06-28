({
	doInit : function(component, event, helper) {
        debugger;
        component.set("v.isOpenQuickAction",true);
        debugger;
        helper.callAction( component, 'c.getFieldLabel', {
            	'objectName' : component.get('v.objectName'),
            	'fieldName'  : component.get('v.fieldName')
        	}, function( data ) {
            component.set('v.label', data);
        });
        helper.callAction( component, 'c.getPicklistOptions', {
            	'objectName' : component.get('v.objectName'),
            	'fieldName'  : component.get('v.fieldName')
        	}, function( data ) {
            component.set('v.options', data);
        });
	},
    
    onchangeHandler : function(component, event, helper) {
        debugger;
      //  alert("Hi")
        var getValue = component.get("v.value");
        component.set("v.selPickValue", getValue);
    },
    
    UpdatehandleClick : function(component, event, helper){
        debugger;
        var SelctedValue = component.get("v.selPickValue");
        var action = component.get("c.updateAccountPickValue");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "pickValue" : SelctedValue
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
               // alert("SUCCESS")
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
               // helper.showSuccessToast(component);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                     "type": 'success',
                    "message": "The Record updated successfully."
                });
                toastEvent.fire();
                component.set("v.isOpenQuickAction",false);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
})