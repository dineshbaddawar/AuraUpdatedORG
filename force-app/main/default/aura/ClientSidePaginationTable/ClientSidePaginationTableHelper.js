({
    callActionAsPromise : function(component, helper, actionName, params) {
        debugger;
        return new Promise($A.getCallback(function(resolve, reject) {
            let action = component.get(actionName);
            action.setParams(params);
            action.setCallback(helper, function(actionResult) {
                if (actionResult.getState() === 'SUCCESS') {
                    resolve({'component':component, 'helper':helper, 'result':actionResult.getReturnValue()});
                } else {
                    let errors = actionResult.getError();
                    reject(new Error(errors && Array.isArray(errors) && errors.length === 1 ? errors[0].message : JSON.stringify(errors)));
                }
            });
            $A.enqueueAction(action);
        }));
    },
    
    preparePagination: function (component, records) {
        debugger;
        let countTotalPage = Math.ceil(records.length/component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        this.setPageDataAsPerPagination(component);
    },
 
    setPageDataAsPerPagination: function(component) {
        debugger;
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let filteredData = component.get('v.filteredData');
        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++){
            if (filteredData[x]) {
                data.push(filteredData[x]);
            }
        }
        component.set("v.data", data);
    },
    
    searchRecordsBySearchPhrase : function (component) {
        debugger;
        let searchPhrase = component.get("v.searchPhrase");
        if (!$A.util.isEmpty(searchPhrase)) {
            let allData = component.get("v.allData");
            let filteredData = allData.filter(record => record.Name.includes(searchPhrase));
            component.set("v.filteredData", filteredData);
            this.preparePagination(component, filteredData);
        }
    },
    
 })