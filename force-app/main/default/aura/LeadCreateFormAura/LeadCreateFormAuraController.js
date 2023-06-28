({
    onPageReferenceChange : function(component, event, helper) {
        debugger;
        var myPageRef = component.get("v.pageReference");
        var action = component.get("c.getPickListValuesMethod");
        action.setParams({
            "ObjectApi_name" : 'Lead',
            "Field_Name" : 'Status'
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.pickValues", data);
            }
        });
        $A.enqueueAction(action);
    },
    
    onChangeHandler : function(component, event, helper) {
        debugger
        var selPick =  component.find('field').get('v.value');
        component.set("v.pickValue", selPick);
    },
    
    clearClick : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    handleClick :  function(component, event, helper) {
        debugger;
        var action = component.get("c.createLeadRecord");
        var fname = component.find("first").get("v.value");
        var lname = component.find("last").get("v.value");
        var phone = component.find("phone").get("v.value");
        var company = component.find("company").get("v.value");
        var selectedPick = component.get("v.pickValue");
        
        action.setParams({
            "fName" : fname,
            "lName" :lname,
            "Phone" : phone,
            "company" :company,
            "leadStatus" : selectedPick
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                alert("Lead Created Successfully !")
//                component.set("v.CreatedleadId", data.Id);
                let thirdAction = component.get('c.showToast');
                $A.enqueueAction(thirdAction);
            }else{
                
            }
        })
        $A.enqueueAction(action);
    },
    
    showToast : function(component, event, helper) {
        debugger;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://utilitarianlabs7-auracompo-dev-ed.my.salesforce.com/'
        });
        urlEvent.fire();
    }
    
})