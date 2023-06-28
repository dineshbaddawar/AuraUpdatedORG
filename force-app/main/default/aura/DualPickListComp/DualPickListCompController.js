({
    doInit : function(component, event, helper) {
        debugger;	
        var action = component.get("c.getPickListValuesMethod");
        var objName ='Opportunity';
        var fieldName = 'LeadSource';
        action.setParams({
            "ObjectApi_name" : objName,
            "Field_Name" : fieldName
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.TypePick", data);
                let secondAction = component.get('c.getStageName');
                $A.enqueueAction(secondAction);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    closeModel : function(component, event, helper){
        debugger;
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    onChangeeFiledValue : function(component, event, helper){
        debugger;
        var selType = component.find("oppType").get("v.value");
        component.set("v.selTypeValue", selType);
        var selStage = component.find("oppStage").get("v.value");
        component.set("v.selStageType", selStage);
    },
    
    getStageName : function(component, event, helper){
        debugger;
        var action = component.get("c.getPickListValuesMethod");
        var objName = 'Opportunity';
        var fieldName = "StageName";
        action.setParams({
            "ObjectApi_name" : objName,
            "Field_Name" : fieldName
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.StagePick", data);
            }
        });
        $A.enqueueAction(action);
    },
    
    updateOppField: function(component, event, helper){
        debugger;
        var recId = component.get("v.recordId");
        var action = component.get("c.updateOppPicklistValue");
        action.setParams({
            "recordId" : recId,
            "StageParam" : component.get("v.selStageType"),
            "typeParam" : component.get("v.selStageType")
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                 dismissActionPanel.fire();
                let secondAction = component.get('c.showSuccess');
                $A.enqueueAction(secondAction);
                 $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
      showSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Record updated Successfully !',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
})