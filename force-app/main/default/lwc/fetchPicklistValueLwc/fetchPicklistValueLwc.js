import { LightningElement,track,wire,api } from 'lwc';
import pickListValueDynamically from '@salesforce/apex/TestCode.pickListValueDynamically';
import UpdateContactPickList from '@salesforce/apex/TestCode.UpdateContactPickList';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class FetchPicklistValueLwc extends LightningElement {
     @track picklistVal;
     @api recordId;
     contactdata;
 
@wire(pickListValueDynamically, {customObjInfo: {'sobjectType' : 'Contact'},
selectPicklistApi: 'LeadSource'}) selectTargetValues;
    
     selectOptionChanveValue(event) {   
          debugger;  
       this.picklistVal = event.target.value;
     }  

     handleLoad() {
          debugger;
          UpdateContactPickList({ recordId: this.recordId, pickValue: this.picklistVal })
          .then(result => {
               this.contactdata = result;
           })
           .catch(error => {
               this.error = error;
           });
           this.showSuccessToast();
          this.refreshPage();
          eval("$A.get('e.force:refreshView').fire();");
     }
     refreshPage() {
          debugger;
          this.dispatchEvent(new CloseActionScreenEvent());
          if(window && this.recordId) {
              window.location.href='/lightning/r/Contact/'+this.recordId+'/view';
          }
     }
     showSuccessToast() {
          const evt = new ShowToastEvent({
              title: 'SUCCESS',
              message: 'Record Updated Successfully !',
              variant: 'success',
              mode: 'dismissable'
          });
      }
}