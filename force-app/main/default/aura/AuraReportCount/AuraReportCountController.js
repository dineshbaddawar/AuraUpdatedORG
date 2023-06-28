({
	doInit : function(component, event, helper) {
        debugger;
		var action = component.get("c.gerReportCountByPassingReportApiName");
        action.setParams({
            "reportApiName" : component.get("v.reportApiNameFromPage")
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.reportCount",data);
            }
        });
        $A.enqueueAction(action);
	},
})