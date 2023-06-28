({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    uploadHelper : function(component, event) {
        debugger;	
        var fileInput = component.find("fileuplod").get("v.files");
        var file = fileInput[0];
        var self = this;
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function(){
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            self.uploadProcess(component, file, fileContents);
        }); 
        objFileReader.readAsDataURL(file);
    }, 
    
    uploadProcess: function(component, file, fileContents) {
        debugger;
        var startPosition = 0;
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        debugger;
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action= component.get("c.SaveFileFromSite");
        var oppId = component.get("v.recordId");
        action.setParams({
            "parentId" : component.get("v.recordId"),
            "fileName" : file.name,
            "base64Data" : encodeURIComponent(getchunk),
            "contentType" : file.type,
            "fileId" : attachId
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                if(data !=null){
                    this.LightningAlert.open({
                        message: 'File Uploaded successfully !',
                        theme: 'success',
                        label: 'SUCCESS!',
                    }).then(function() { 
                        console.log('alert is closed');
                       // window.location.href = 'https://webgate.ec.europa.eu/sante-xmlgate/ui/help/Content/Resources/Images/Upload%20successful.jpg'; 
                    });
                    $A.get('e.force:refreshView').fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                }
                
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        });
        $A.enqueueAction(action);
    }
})