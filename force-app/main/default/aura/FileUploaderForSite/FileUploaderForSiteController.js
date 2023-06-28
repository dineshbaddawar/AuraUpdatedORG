({
    
    doInit : function(component, event, helper) {
        debugger;
        var urlString = window.location.href;
        const urlParams = new URLSearchParams(urlString);
               
        var recordId = component.get("v.recordId");
        component.set("v.recordId",recordId);
    },
    handleFilesChange: function(component, event, helper) {
         debugger;
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
	handleSave : function(component, event, helper) {
	debugger;
        if (component.find("fileuplod").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
	},
    
       // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    }
     
})