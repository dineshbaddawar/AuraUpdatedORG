({
	helperMethod : function(component) {
		 debugger;
		var action = component.get("c.getAccountList");
        component.set("v.isLoading", true);
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        action.setParams({
            "pageSize" : pageSize,
            "pageNumber" : pageNumber
        });
        action.setCallback(this, function(response){
            component.set("v.isLoading", false);
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                if(data.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                }else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", data.length);
                component.set("v.accList",data);
            }
        })
        $A.enqueueAction(action);
	},
})