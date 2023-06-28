({
    onAction : function(component, event, helper) {
        debugger;
        // alert("HI")
        var AccountIdVar = component.get("v.recordId");
        var objCompB = component.find('compB'); 
        var data =   objCompB.sampleMethod(AccountIdVar, "Data from the Second parameter");
    },
})