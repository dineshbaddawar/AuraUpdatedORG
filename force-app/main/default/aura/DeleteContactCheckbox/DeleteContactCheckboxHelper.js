({
	 showWarning : function(component, event) {
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'ERROR',
            message:'Please select a Record !',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },	
     successMessage : function(component, event) {
        debugger;
         var deletecount = component.get("v.deletedrecordCount");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'SUCCESS',
            message: deletecount +' Record has been Deleted Successfully !',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },	
})