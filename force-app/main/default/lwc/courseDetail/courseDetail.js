import { LightningElement, api, wire } from 'lwc';
import { getRecord, deleteRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import isCourseAdmin from '@salesforce/apex/LearningController.isCourseAdmin';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const FIELDS = [
    'Course__c.Name',
    'Course__c.Description__c',
    'Course__c.Course_image__c'
];

export default class CourseDetail extends NavigationMixin(LightningElement) {
    @api recordId;
    course = {};
    isAdmin;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredCourse({ error, data }) {
        if (data) {
            this.course = {
                id: data.id,
                name: data.fields.Name.value,
                description: data.fields.Description__c.value,
                imageUrl: data.fields.Course_image__c.value
            };
        } else if (error) {
            console.error(error);
        }
    }

     connectedCallback() {
        isCourseAdmin()
            .then(result => {
                this.isAdmin = result;
            })
            .catch(error => {
                console.error('Error fetching user role', error);
            });
     }

    handleEdit() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Course__c',
                actionName: 'edit'
            }
        });
    }

    handleNew() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Course__c',
                actionName: 'new'
            }
        });
    }

    handleBack() {
        console.log('handle back');
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Learning_Home'
            }
        });
    }

    handleDelete() {
        deleteRecord(this.recordId)
            .then(() => {
                console.log('delete success');
                // this.dispatchEvent(
                //     new ShowToastEvent({
                //         title: 'Success',
                //         message: 'Course deleted successfully',
                //         variant: 'success'
                //     })
                // );
                this.handleBack();
            })
            .catch(error => {
                console.log('delete error: ', error);
                // this.dispatchEvent(
                //     new ShowToastEvent({
                //         title: 'Error deleting record',
                //         message: error.body.message,
                //         variant: 'error'
                //     })
                // );
            });
    }
}
