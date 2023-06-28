({
	doInit : function(component, event, helper) {
		debugger;
        var recordId = component.get("v.recordId");
	},
     handleOnSuccess: function (component, event, helper) { 
		debugger;
		var params = event.getParams(); 
		var recordId = params.response.id;
		if (recordId != null) {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
			    title : 'SUCCESS',
			    message: 'Product Updated Successfully !',
			    duration:' 5000',
			    key: 'info_alt',
			    type: 'success',
			    mode: 'pester'
			});
			toastEvent.fire();
			window.location.href='/lightning/r/Product2/'+recordId+'/view';
		}

	},

	handleError: function (cmp, event, helper) {
		alert("ERROR")
		debugger;
		var error = event.getParams(); 
		var errorMessage = event.getParam("message"); 
	 },

	 CancelEdit: function (component, event, helper) {
		var recordId = component.get("v.recordId");
		debugger;
		window.location.href='/lightning/r/Product2/'+recordId+'/view';
	}
})