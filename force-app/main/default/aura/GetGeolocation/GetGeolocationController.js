({
	doInit : function(component, event, helper) {
        debugger;
		var action = component.get("c.getAddressofLead");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.address", data);
            }
        });
        $A.enqueueAction(action);
	},
    
    handleClick : function(component, event, helper) {
        debugger;
        
        var action = component.get("c.getLongandLat");
        action.setParams({
            "Addresss" : component.get("v.address"),
            "reocrdId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
               let jsonparsedata = JSON.stringify(data);
                component.set("v.lattituede", data.lat);
                component.set("v.longitutde", data.lang);
                let callmethod = component.get("c.updateLead");
                 $A.enqueueAction(callmethod);
            }
        });
        $A.enqueueAction(action);
    },
    
    updateLead : function(component, event, helper) {
        var action = component.get("c.updateGeolocation");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "lat" : component.get("v.lattituede"),
            "lng" : component.get("v.longitutde")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
    }
})