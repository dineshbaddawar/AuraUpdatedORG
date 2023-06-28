({
    doInit: function (component, event, helper) { 
        debugger;
        component.set('v.columns', [
            {label: 'Name', fieldName: 'linkName',type: 'url',sortable:true, 
            typeAttributes:{label: { fieldName: 'Name' }, target: '_blank'}},
            { label: 'Invoice Sent', fieldName: 'Invoice_Sent__c', type: 'boolean', sortable: true },
            {label: 'Invoice Date', fieldName: 'Invoice_Date__c',type: 'date',
            typeAttributes:{month: "2-digit",day: "2-digit",year: "numeric"}},
            {label: 'Created Date', fieldName: 'CreatedDate',type: 'date',sortable:true,
             typeAttributes:{day:'numeric',month:'short',year:'numeric',hour:'2-digit',minute:'2-digit',second:'2-digit',hour12:true}}
        ]);

        var action = component.get("c.getInvoiceListFromOPp");
        var recordId = component.get("v.recordId");
        action.setParams({
            "oppId": recordId
        }); 
        action.setCallback(this, function (response) {
            var State = response.getState();
            if (State === "SUCCESS") {
                var results=response.getReturnValue(); 
                if (results.length > 0) {
                    results.forEach(function (record) {
                        record.linkName = '/' + record.Id;
                    });
                    component.set("v.results", results);
                }
               
            }
        });
        $A.enqueueAction(action);
    },
    sortColumn: function (component, event, helper) {
        debugger;
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortedDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        let secondAction = component.get('c.sortData');
        $A.enqueueAction(secondAction);
    },

    sortData: function (component, fieldName, sortDirection) {
        debugger;
        var fName = fieldName;
        var data = component.get("v.results");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortByfield(fieldName, reverse))
        component.set("v.results", data);
    },
    sortByfield: function (field, reverse) {
        debugger;
        var key = function (x) { return x[field] };
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
})