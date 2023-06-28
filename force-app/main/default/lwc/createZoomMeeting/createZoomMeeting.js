import { LightningElement, api, track } from 'lwc';
import createMeeting from '@salesforce/apex/ZoomAPIController.createMeeting';
import { CloseActionScreenEvent } from 'lightning/actions';


export default class CreateZoomMeeting extends LightningElement {


     @api recordId;
     @track meetingSubject;
     @track meetingdatetime;
     @track meetingtime;

      connectedCallback(){

           setTimeout(() => {
          
           this.getRecordDetails();
          
           }, 300);
          
      }
     
     
     handleChangeSubject(event) {
          debugger;
          this.meetingSubject = event.target.value;
      }
     handleChangeDatetime(event) {
          debugger;
           this.meetingdatetime = event.target.value;
     }
     handleChangeDuration(event) {
          debugger;
          this.meetingtime = event.target.value;
      }

     handleSave() {
          debugger;
          
          createMeeting({ Subject:this.meetingSubject, startSlot:this.meetingdatetime, mDuration:this.meetingtime, rrecordId:this.recordId })
               .then(result => {
                   console.log('result---->'+result);
                    debugger;
          })
      }

      handleCancel()
      {
          this.closeAction();
      }
            closeAction(){
this.dispatchEvent(new CloseActionScreenEvent());
}
      
}