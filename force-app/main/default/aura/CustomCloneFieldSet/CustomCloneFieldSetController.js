({
    doInit : function(component, event, helper) {
        debugger;
        let action = component.get('c.getFieldsFromFieldSetApex');
        var recordId = component.get('v.recordId');
        action.setParams({
            objectRecordId : recordId
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            console.log("State",State)
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                var defaultValuesString = JSON.parse(data.fieldDefaultValues);
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    'entityApiName': objectName,
                    'defaultFieldValues': defaultValuesString
                });
            }
        });
        $A.enqueueAction(action);
    },
    
})