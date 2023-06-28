import { LightningElement,track,wire,api } from 'lwc';
import GETCONTACT from '@salesforce/apex/LwcUtilityClass.getContactName';
import { NavigationMixin } from 'lightning/navigation';
const delay = 400;
export default class SearchAccountLWC extends NavigationMixin(LightningElement)  {
     contactName;
     @track contactList = [];
     @track dataList = [];
     @wire(GETCONTACT, { conName: '$contactName' })
     retriveContact({ data, error }) {
          debugger;
          if (data) {
            console.log("data :::"+data)             
               this.dataList = data;
          } 
     }
     redirecttoaccount(event) {
          debugger;
          var contactId = event.target.dataset.id;
          this[NavigationMixin.Navigate]({
               type: "standard__recordPage",
               attributes: {
                 objectApiName: "Contact",
                 actionName: "view",
                 recordId: contactId
               }
             });
     }


     handleChange(event) {    
          var strname = event.target.value;
          window.clearTimeout(this.delayTimeout);
          this.delayTimeout= setTimeout(() => {
               this.contactName = strname;
          }, delay);
     }

}