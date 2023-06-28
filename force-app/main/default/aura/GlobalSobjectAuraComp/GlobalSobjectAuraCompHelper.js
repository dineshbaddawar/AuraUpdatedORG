({
	getObjectList : function(component) {
         debugger;
		var action = component.get("c.getAllSobject");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.allObjects", response.getReturnValue());
                component.set("v.filteredObjects", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
    
    getRecordList : function(component, selectedObject) {
         debugger;
        var action = component.get("c.getRecords");
        action.setParams({
            'objectName' : selectedObject
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data.length > 0) {
                    component.set("v.recordFound", true);
                    component.set("v.records", data);
                }
              
            }
        });
        $A.enqueueAction(action);
    }
})