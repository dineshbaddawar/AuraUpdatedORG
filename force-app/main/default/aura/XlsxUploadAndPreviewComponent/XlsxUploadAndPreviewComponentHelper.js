({
    createCSVObject : function(cmp, csv) {
          debugger;
        var action = cmp.get('c.getCSVObject');
        action.setParams({
            csv_str : csv
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
	    if(state == "SUCCESS") {
		cmp.set("v.csvObject", response.getReturnValue());
	    }
        });
        $A.enqueueAction(action);
    },
})