({
    doInit : function(component, event, helper) {
        debugger;
        var recordData = [];
        var action = component.get("c.getRecorDetailsfrom");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var datalist = [];
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                if ( result != null) {
                    for (var key in result) {
                        datalist.push({ key: key, value:(result)[key] });
                        component.set("v.fieldApiNameList", datalist);
                    }  	
                    debugger;
                    console.log('key',datalist);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    handleOnSuccess : function(component, event, helper) {
        debugger;
        var params = event.getParams(); //get event params
        var recordId = params.response.id; //get record id
        console.log('Record Id - ' + recordId); 
    }
    
    
})