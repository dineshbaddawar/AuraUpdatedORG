({
	doInit : function(component, event, helper) {
        debugger;
       var actions = [
            {label: 'View', name: 'view'},
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'}
        ]; 
        component.set('v.mycolumns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Industry', fieldName: 'Industry', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', type: 'phone'},
            {type: 'action', typeAttributes: { rowActions: actions } } 
        ]);
        
        var action = component.get("c.getAccountRecordList");
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.accListdata", data);
            }
        });
        $A.enqueueAction(action);
	},
    handleRowAction : function(component, event, helper){
        debugger;
        var action = event.getParam("action");
        switch (action.name){
            case 'view':
               // let secondAction = component.get('c.viewRecord');
               // $A.enqueueAction(secondAction);
               helper.viewRecord(component, event);
                break;
            case 'edit':
              //  let secondAction1 = component.get('c.editRecord');
              //  $A.enqueueAction(secondAction1);
               helper.editRecord(component, event);
                break;
            case 'delete':
                // let secondAction2 = component.get('c.deleteRecord');
               // $A.enqueueAction(secondAction2);
               helper.deleteRecord(component, event);
                  break;
        }
    },
    /*
    viewRecord : function(component, event, helper){
        debugger;
        var row = event.getParam('row');
        var recordId = row.Id;
    }, 
   
    editRecord : function(component, event, helper){
       // alert("Edit")
         debugger;
    },
        */
    
    

})