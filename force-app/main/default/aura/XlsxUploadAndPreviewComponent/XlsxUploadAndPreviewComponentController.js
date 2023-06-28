({
    handleUploadFinished : function(component, event, helper) {
        debugger;
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        if(file) {
            console.log("UPLOADED")
            var reader = new FileReader();
            reader.readAsText(file, 'UTF-8');
            reader.onload = function(evt) {
                var csv = evt.target.result;
                component.set("v.csvString", csv);
            }
        }
    },

    handleGetCSV : function(component, event, helper) {
          debugger;
        var csv = component.get("v.csvString");
        if(csv != null) {
            helper.createCSVObject(component, csv);
        }
    },

    cleanData : function(component, event, helper) {
          debugger;
        component.set("v.csvString", null);
        component.set("v.csvObject", null);
    },

    
})