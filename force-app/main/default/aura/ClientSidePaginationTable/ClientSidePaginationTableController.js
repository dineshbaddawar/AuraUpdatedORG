({
    init : function(component, event, helper) {
        debugger;
        helper.callActionAsPromise(component,helper,'c.getColumnsAndData',{
            'sObjectName': component.get('v.sObjectName'),
            'sObjectFieldsNames': component.get('v.sObjectFieldsNames')
        })
        .then(function(r) {
            component.set('v.columns', r.result.columns);            
            component.set('v.allData', r.result.data);
            component.set('v.filteredData', r.result.data);
            helper.preparePagination(component, r.result.data);   
        })
    },
    
    onNext: function(component, event, helper) {  
        debugger;      
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.setPageDataAsPerPagination(component);
    },
    
    onPrev: function(component, event, helper) {    
        debugger;    
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.setPageDataAsPerPagination(component);
    },
    
    onFirst: function(component, event, helper) {   
        debugger;     
        component.set("v.currentPageNumber", 1);
        helper.setPageDataAsPerPagination(component);
    },
    
    onLast: function(component, event, helper) {    
        debugger;    
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.setPageDataAsPerPagination(component);
    },
    
    onPageSizeChange: function(component, event, helper) {  
        debugger;      
        helper.preparePagination(component, component.get('v.filteredData'));
    },
    
    onChangeSearchPhrase : function (component, event, helper) {
        debugger;
        if ($A.util.isEmpty(component.get("v.searchPhrase"))) {
            let allData = component.get("v.allData");
            component.set("v.filteredData", allData);
            helper.preparePagination(component, allData);
        }
    },
    
    handleSearch : function (component, event, helper) {
        debugger;
        helper.searchRecordsBySearchPhrase(component);
    },
 })