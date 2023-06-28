import { LightningElement,api,track,wire } from 'lwc';
import attachFileToOppotunities from '@salesforce/apex/InvoicePDFCmpHelper.attachFileToOppotunities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class GeneratePDFLWC extends LightningElement {
     debugger;
  
     @api recordId;
     contacts;
     error;
     @api invoke() {
          console.log(this.recordId);
          alert(this.recordId)
     }
     
     handleSubmit() {
        //  alert("Hi")
          debugger;
          attachFileToOppotunities({ OpportunityId: this.recordId })
          .then((result) => {
               this.contacts = result;
               if (result != null) {
                    const evt = new ShowToastEvent({
                         title: 'SUCCESS',
                         message: '\u2022 Invoice Generated Successfully !',
                         variant: 'success',
                         mode: 'dismissable'
                     });
                    this.dispatchEvent(evt);
                    this.dispatchEvent(new CloseActionScreenEvent());
               }
              this.error = undefined;
          })
          .catch((error) => {
              this.error = error;
              this.contacts = undefined;
          });
     }

     
     closeQuickAction() {
          this.dispatchEvent(new CloseActionScreenEvent());
      }

}