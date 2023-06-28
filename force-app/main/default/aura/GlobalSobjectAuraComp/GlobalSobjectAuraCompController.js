({
    
	doInit : function(component, event, helper) {
        debugger;
		component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Action', type: 'button', initialWidth: 135, typeAttributes: 
            {label: 'View', name: 'view_details', title: 'Click to View or Edit Details'}}
        ]);
        
        helper.getObjectList(component);
	},
    
    /**
     * This function will be called on object selection change
     * It fetches record list from that object
     * */
    onObjectSelectionChange : function(component, event, helper) {
         debugger;
        var selectedObject = component.find("objectList").get("v.value");
        console.log("SELECT OBJECT ::"+selectedObject);
        //hide show details component
        component.set("v.showDetails", false);
        //fetch records
        helper.getRecordList(component, selectedObject);
    },
    
    /**
     * This function will be called on object selection change
     * It fetches record list from that object
     * */
    onModeChange : function(component, event, helper) {
         debugger;
        var recordFormMode = component.find("modeList").get("v.value");
        console.log("Current Mode ::"+recordFormMode);
        if(recordFormMode === "ReadOnly Mode"){
        	component.set("v.recordFormMode", "readonly");
        } else{
           	component.set("v.recordFormMode", "view");
        }
    },
    
    /**
     * This function will be called on object type selection change
     * It will filter object list as per user's selection
     * */
    onTypeChange : function(component, event, helper) {
         debugger;
        var selectedObjectType = component.find("typeList").get("v.value");
         console.log("SELECT Object Type ::"+selectedObjectType);
        var filteredObjects = [];
        if(selectedObjectType === "Standard Objects"){
            filteredObjects = component.get("v.allObjects").filter(function(value){
                return value.isCustom === false;
            });
        } else if(selectedObjectType === "Custom Objects"){
            filteredObjects = component.get("v.allObjects").filter(function(value){
                return value.isCustom === true;
            });
        } else{
            filteredObjects = component.get("v.allObjects");
        }
        component.set("v.filteredObjects", filteredObjects);
    },
    
    /**
     * This method will be called when View button is clicked in data table
     * */
    handleRowAction : function (component, event, helper) {
         debugger;
        var action = event.getParam('action');
        var record = event.getParam('row');
        switch (action.name) {
            case 'view_details':
                component.set("v.selectedRecord", record.Id);
                component.set("v.selectedObject", component.find("objectList").get("v.value"));
                break;
        }
        
        if(component.get("v.selectedRecord")){
            //Show component details
            component.set("v.showDetails", true);
        }
    },
})