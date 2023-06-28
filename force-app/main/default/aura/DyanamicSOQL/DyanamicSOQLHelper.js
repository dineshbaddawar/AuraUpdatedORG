({
    getAllSobjectFields : function(component,event) {
        debugger;
        var action = component.get("c.getAllFieldsOfSobject");
        action.setParams({
            "SobjectApiName" : component.get("v.selObjectType")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.sobjectFieldList", data);
                console.log("data ",data)
              //  let thirdAction = component.get('c.CallMethod');           
               // $A.enqueueAction(thirdAction);
            }
        });
        $A.enqueueAction(action);
    },
    
    CallMethod : function(component, event, helper) {
        debugger;
        var action = component.get("c.getListOfFieldsFromObject");
        action.setParams({
            "SobjectApiName" :  component.get("v.selObjectType")
        })
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State == 'SUCCESS'){
                var result = response.getReturnValue();
               
                var plValues = [];
              
                 for ( key in result ) {
                    plValues.push({value:result[key], key:key});
                }
                
                  component.set("v.LeadTypeList", plValues);
                  console.log("plValues" ,plValues)
            }
        });
        $A.enqueueAction(action);
    },
})