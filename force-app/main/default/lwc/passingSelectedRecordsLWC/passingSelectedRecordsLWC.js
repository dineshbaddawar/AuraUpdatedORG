import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContactListRecord from '@salesforce/apex/LwcUtilityClass.getContactListRecord';
const columns = [
     { label: 'Label', fieldName: 'Name' },
     { label: 'Email', fieldName: 'Email', type: 'email' },
     { label: 'Phone', fieldName: 'Phone', type: 'phone' }
 ];

export default class PassingSelectedRecordsLWC extends LightningElement {
     @track data = [];
     @track error;
     columns = columns;
     
     connectedCallback() {
          debugger;
          getContactListRecord()
               .then(result => {
                    console.log("result ::", result);
                    this.data = result;
               })
               .catch(error => {
                    this.error = error;
               });
     }

     rowhandleSelection(event) {
          debugger;
          const selectedRows = event.detail.selectedRows;
          var tempdata = selectedRows.filter(row => !row.Phone || !row.Email);
          if (tempdata && tempdata.length > 0) {
               const evt = new ShowToastEvent({
                    title: 'ERROR',
                    message: '\u2022 Please select records having value of all fields',
                    variant: 'error'
                });
               this.dispatchEvent(evt);
          }
          // Display that fieldName of the selected rows
          for (let i = 0; i < selectedRows.length; i++) {
              alert('You selected: ' + selectedRows[i].Name);
          }
          console.log("selectedRows ::", selectedRows);
     }
}