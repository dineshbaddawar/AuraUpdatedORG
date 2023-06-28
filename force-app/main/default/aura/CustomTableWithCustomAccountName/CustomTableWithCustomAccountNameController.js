({
	doInit : function(component, event, helper) {
       
        var recordID = component.get("v.recordId");
        component.set("v.accId", recordID);
        debugger;
		var action = component.get("c.customContactList");
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State  === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.conList", data);
            }
        })
        $A.enqueueAction(action);
	},
})