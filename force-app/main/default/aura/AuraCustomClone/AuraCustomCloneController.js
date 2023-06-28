({
    doInit : function(component, event, helper) {
        debugger;
        var recordId = component.get("v.recordId");
        var action = component.get("c.oppCustomClone");
        action.setParams({
            "OppId" : recordId
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                var createRecordEvent = $A.get('e.force:createRecord');
                createRecordEvent.setParams({
                    'entityApiName' : 'Opportunity',
                    'defaultFieldValues' : {
                        'Name' : data.Name,
                        'StageName' : data.StageName,
                        'CloseDate' : data.CloseDate,
                        'Amount' : data.Amount
                    }
                })
                createRecordEvent.fire();
            }else{
                console.log("ERROR")
            }
        });
        $A.enqueueAction(action);
    },
})