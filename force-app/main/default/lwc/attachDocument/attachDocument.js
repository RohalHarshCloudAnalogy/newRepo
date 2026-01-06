import { LightningElement,api } from 'lwc';
import attachFile from '@salesforce/apex/fetchAccount.attachFile';


export default class AttachDocument extends LightningElement {
    @api recordId;
    imageUrl;
  
    get acceptedFormats(){
        return ['.pdf','.jpg','.png'];
    }

    handleFilesUploaded(event) {
        const uploadedFile = event.target.files[0]; // event.detail.files[0] is incorrect for lightning-input
        if (!uploadedFile) return;

        const reader = new FileReader(); //inbuild tool which is use to read file and also use to fetch the base64

        reader.onload = () => {
            
            this.imageUrl = reader.result;
            const base64 = reader.result.split(',')[1];
            const fileName = uploadedFile.name;

            // Now call Apex inside onload
            attachFile({
                accId: this.recordId,
                base64Data: base64,
                files: fileName
            })
            .then(result => {
                console.log('Upload successful', result);
            })
            .catch(error => {
                console.error('Upload failed', error);
            });
        };

        reader.readAsDataURL(uploadedFile); // Start reading the file
    }


}