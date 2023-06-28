({
	doInit : function(component, event, helper) {
		  debugger;
        var action = component.get("c.getAccountcount");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.contactCount", data.contactCount);
                component.set("v.opportunitycount", data.OpportunityCount);
                component.set("v.caseCount", data.caseCount);
            }
        });
        $A.enqueueAction(action);
	},
    
    callContactMethod : function(component, event, helper) {
        debugger;
        alert("Contact");
    },
    
    callOpportunityMethod : function(component, event, helper) {
        debugger;
        alert("Opportunity");
    },
    callCaseMethod : function(component, event, helper) {
        debugger;
        alert("Case");
    },
})