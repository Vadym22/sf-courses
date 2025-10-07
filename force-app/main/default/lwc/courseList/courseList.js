import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getCourses from '@salesforce/apex/CourseController.getCourses';

export default class CourseList extends NavigationMixin(LightningElement) {
    @track courses;
    @track error;

    @wire(getCourses)
    wiredCourses({ error, data }) {
        if (data) {
            this.courses = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.courses = undefined;
        }
    }

    handleNavigate(event) {
        const recordId = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Course__c',
                actionName: 'view'
            }
        });
    }
}