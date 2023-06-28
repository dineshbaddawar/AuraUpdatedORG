({
    doAction : function(component, event) {
        debugger;
        var paramsVariable = event.getParam('arguments');
        if (paramsVariable) {
            var value1 = paramsVariable.param1;
            var value2 = paramsVariable.param2;
        }
    },
})