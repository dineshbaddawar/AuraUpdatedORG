({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getLeadRecord");
        var currentRecordLeadID = component.get("v.recordId");
        action.setParams({
            "leadRecId" : currentRecordLeadID
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.LeadRec",response.getReturnValue());
                component.set("v.leadPhone", response.getReturnValue().Phone);
                component.set("v.leadEmail", response.getReturnValue().Email);
                // this.getContact(component, event, helper);
                let secondAction = component.get('c.getContact');
                $A.enqueueAction(secondAction);
            }
        });
        $A.enqueueAction(action);
    },
    
    getContact : function(component, event, helper){
       debugger;
        var action = component.get("c.getContactListBasedOnLeadPhoneorEmail");
        action.setParams({
            "leadPhone" : component.get("v.leadPhone"),
            "leadEmail" : component.get("v.leadEmail")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.ContactRec", response.getReturnValue());
                 let thirdAction = component.get('c.getOpportunity');
                $A.enqueueAction(thirdAction);
            }
        });
          $A.enqueueAction(action);
    },
    
    getOpportunity :  function(component, event, helper){
        debugger;
        var action = component.get("c.getOpportunityListBasedOnLeadPhoneorEmail");
        action.setParams({
            "leadPhone" : component.get("v.leadPhone"),
            "leadEmail" : component.get("v.leadEmail")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.OpportunityRec", response.getReturnValue());
                 let fourthdAction = component.get('c.getAccount');
                $A.enqueueAction(fourthdAction);
            }
        });
        $A.enqueueAction(action);
    },
    
    getAccount : function(component, event, helper){
        debugger;
       var action = component.get("c.getAccountListBasedonLeadEmailorPhone");
        action.setParams({
            "leadPhone" : component.get("v.leadPhone"),
            "leadEmail" : component.get("v.leadEmail")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.AccountRec", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
})