import { LightningElement,track,api } from 'lwc';
import getFieldLabel from '@salesforce/apex/TestCode.getFieldLabel';
import getPicklistOptions from '@salesforce/apex/TestCode.getPicklistOptions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class PickListSelectLWC extends LightningElement {

     @api objectName = 'Account';
     @track fieldName = 'Type';
     @track LabelName;
     @track optionValue = [];
		
//     connectedCallback() {
// 				debugger;
// 				getFieldLabel({
// 						objectName : this.objectName,
// 						fieldName : this.fieldLabelName
// 				})
// 				.then(data =>{
// 						this.LabelName = data;
// 				})
// 				.catch(error => {
// 				this.displayError(error);
// 			});
// 				getPicklistOptions({
// 						objectName : this.objectName,
// 						fieldName : this.selectedPicValue
// 				})
// 				.then(data =>{
// 						this.optionValue = data;
// 				})
// 					.catch(error => {
// 				this.displayError(error);
// 			});
// 		}

connectedCallback() {
	debugger;
	getFieldLabel({
		objectName: this.objectName,
			fieldName: this.fieldName
		})
		.then(data => {
			this.LabelName = data;
		})
		.catch(error => {
			this.displayError(error);
		});
}


}