({
	GetAssignmentgroup: function (cmp, evt) {
		debugger;
		var action = cmp.get('c.QueryAssignmentGroup');
		// Create a callback that is executed after 
		// the server-side action returns
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				// Alert the user with the value returned 
				// from the server
				var serverResponse = response.getReturnValue();
				var AssignGroupmap = [];
				for(var key in serverResponse.AssignGroupMapWrap){
                    AssignGroupmap.push({key: key, value: serverResponse.AssignGroupMapWrap[key].Name});
                }
				cmp.set("v.AssignGroupList", AssignGroupmap);
				cmp.set("v.AllTaskListview", serverResponse.AllTasklistview);
				// You would typically fire a event here to trigger 
				// client-side notification that the server-side 
				// action is complete
			}
			else if (state === "INCOMPLETE") {
				// do something
			}
			else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " +
							errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
			//var dismissActionPanel = $A.get("e.force:closeQuickAction");
			//dismissActionPanel.fire();
		});

		// optionally set storable, abortable, background flag here
		// A client-side action could cause multiple events, 
		// which could trigger other events and 
		// other server-side action calls.
		// $A.enqueueAction adds the server-side action to the queue.
		$A.enqueueAction(action);
	},
    
     showWarning : function(component, event) {
         debugger;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning',
            message: 'Please Select Task Records ',
            duration:' 5000',
            key: 'info_alt',
            type: 'warning',
            mode: 'sticky'
        });
         toastEvent.fire();
    },	
})