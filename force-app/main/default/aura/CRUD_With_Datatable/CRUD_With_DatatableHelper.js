({
	 viewRecord : function(component, event) {
         debugger;
        var row = event.getParam('row');
        var recordId = row.Id;
        var viewRec=$A.get("event.force:navigateToSObject");
        viewRec.setParams({
            "recordId": recordId,
            "slideDevName": "detail"
        });
        viewRec.fire();
    },
    editRecord : function(component, event) {
        debugger;
        var row = event.getParam('row');
        var recordId = row.Id;
        $A.get("e.force:editRecord").setParams({"recordId": recordId}).fire();
    },  
    deleteRecord : function(component, event, helper){
        debugger;
        //var accountRec = event.getParam('row'); 
        var accountRec = event.getParam('row');
        var action = component.get("c.deleteAccountRecord");
        action.setParams({
            "accRec" : accountRec
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var rows = component.get("v.accListdata");
                var rowIndex = rows.indexOf(accountRec);
                rows.splice(rowIndex,1);
                component.set("v.accListdata",rows);
                this.showToast("Success!","success","The Record has been delete successfully.");
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    }, 
     showToast:function(title,type,message){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({"title": title,"type": type,"message": message}).fire();
        }
        else{
            alert("ERROR");
        }
    },
    
})