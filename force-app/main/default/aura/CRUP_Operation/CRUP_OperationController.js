({
    doInit : function(component, event, helper) {
        debugger;
      //  alert("get Contact")
        var action = component.get("c.getContact");
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                var data = response.getReturnValue();
                component.set("v.conListData", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    openCreateContactModel : function(component, event, helper){
        
        component.set("v.CreateContactModel", true);
    },
    closeModelCreateContact : function(component, event, helper){
        component.set("v.CreateContactModel", false);
        component.set("v.editForm", false);
    },
    
    createContact : function(component, event, helper){
        debugger;
        
        var fname = component.find("firstName").get("v.value");
        var lname = component.find("lastName").get("v.value");
        var phone = component.find("phone").get("v.value");
        var email = component.find("email").get("v.value");
        var action = component.get("c.createContactData");
        action.setParams({
            "firstname" : fname,
            "lastname" : lname,
            "phone" : phone,
            "email" : email
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                helper.showCreateSuccess(component, event);
                $A.get('e.force:refreshView').fire();
                component.set("v.CreateContactModel", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    editContact : function(component, event, helper){
        debugger;
       //  alert("editContact ")
        var SelectedConID = event.currentTarget.dataset.conid;
        component.set("v.currentSelContactId", SelectedConID);
        component.set("v.CreateContactModel", true);
        component.set("v.editForm", true);
        var action = component.get("c.getSelectedConDataByUsingId");
        action.setParams({"conId" : SelectedConID});
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                component.set("v.getContact", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    updateContactButton : function(component, event, helper){
        debugger;
        //  alert("updateContact ")
        var firstname = component.find("editfirstName").get("v.value");
        var lastname = component.find("editlastName").get("v.value");
        var phone = component.find("editphone").get("v.value");
        var email = component.find("editemail").get("v.value");
        var conIdToPass = component.get("v.currentSelContactId");
        var action = component.get("c.updateContact");
        action.setParams({
            "conId" : conIdToPass,
            "firstname" : firstname,
            "lastname" : lastname,
            "phone" : phone,
            "email" : email
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
               
                 helper.showUpdateSuccess(component,event);
                $A.get('e.force:refreshView').fire();
                component.set("v.CreateContactModel", false);
                component.set("v.editForm", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteContactButton : function(component,event, helper){
        debugger;
        var action = component.get("c.deleteContact");
          var selConId = event.currentTarget.dataset.conid;
        action.setParams({
            "conId" : selConId
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                  helper.showDeleteWarning(component,event);
                $A.get('e.force:refreshView').fire();
                component.set("v.CreateContactModel", false);
                component.set("v.editForm", false);
            }
        });
         $A.enqueueAction(action);
    }
    
})