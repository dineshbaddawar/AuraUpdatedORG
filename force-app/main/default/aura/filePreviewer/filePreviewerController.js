({

    /*call apex controller method “fetchContentDocument" to get salesforce file records*/

    doInit : function(component, event, helper) {
     debugger;
        var action = component.get("c.fetchContentDocument");
        action.setParams({
            propId  : component.get("v.recordId")
        })

        action.setCallback(this, function(response) {

            var state = response.getState();

            if (state === "SUCCESS") { 
                var data = response.getReturnValue();

                component.set("v.lstContentDoc", response.getReturnValue());

            }

            else if (state === "INCOMPLETE") {

                // do something

            }

                else if (state === "ERROR") {

                    var errors = response.getError();

                    if (errors) {

                        if (errors[0] && errors[0].message) {

                            console.log("Error");

                        }

                    } else {

                        console.log("Unknown error");

                    }

                }

        });

        $A.enqueueAction(action);  

    },

    getSelected : function(component,event,helper){
     debugger;
        // display model and set seletedDocumentId attribute with selected record Id   

        component.set("v.hasModalOpen" , true);

        component.set("v.selectedDocumentId" , event.currentTarget.getAttribute("data-Id")); 

         },

    closeModel: function(component, event, helper) {

        // for Close Model, set the “hasModalOpen" attribute to “FALSE"  

        component.set("v.hasModalOpen", false);

        component.set("v.selectedDocumentId" , null); 

    },
})