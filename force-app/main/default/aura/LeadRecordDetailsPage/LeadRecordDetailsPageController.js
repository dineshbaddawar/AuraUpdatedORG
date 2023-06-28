({
	doInit : function(component, event, helper) {
        debugger;
		var action = component.get("c.getLeadRecordData");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var State =response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.leadRecord", data);
            }
        });
        $A.enqueueAction(action);
	}
})