({
	doInit : function(component, event, helper) {
        debugger;
		var action = component.get("c.getAccountListToExportCSV");
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.accList",data);
              //  let secondAction = component.get('c.downloadSelectedAccount');
              //  $A.enqueueAction(secondAction);
            }
        });
        $A.enqueueAction(action);
	},
    
    
    
    downloadSelectedAccount : function(component, event, helper){
        debugger;
        var recordList = component.get("v.accList");
        var csv = helper.convertListToCSV(component, recordList);
         // let secondAction = component.get('c.convertListToCSV');
        //  $A.enqueueAction(secondAction);
        if(csv == null){
            return ;
        }
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self';
        hiddenElement.download = 'AccountExportData.csv';;
        document.body.appendChild(hiddenElement);
        hiddenElement.click();
    },
    
    btnToggleButton : function(component, event, helper){
        debugger;
        var checkCmp = component.find("tglbtn").get("v.checked");
        component.set("v.ExportRecordWithId", checkCmp);
    }
   
})