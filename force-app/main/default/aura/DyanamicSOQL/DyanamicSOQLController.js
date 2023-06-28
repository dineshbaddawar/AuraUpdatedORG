({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getObjList");
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.ObjetList", data);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    onChange: function (component, event, helper) {
        debugger;
        var selectedObject = component.find('objecttype').get('v.value');
        component.set("v.selObjectType",selectedObject);
        helper.CallMethod(component,event);
    }
    
   
    
})