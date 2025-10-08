import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getCourses from '@salesforce/apex/LearningController.getCourses';
import isCourseAdmin from '@salesforce/apex/LearningController.isCourseAdmin';

export default class CourseList extends NavigationMixin(LightningElement) {
    @track courses;
    @track error;
    isAdmin;

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

    @wire(isCourseAdmin)
    wiredUser({ error, data }) {
        if (data !== undefined) {
            this.isAdmin = data;
        } else if (error) {
            console.error('Error fetching user role', error);
        }
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

    handleApply() {
        console.log('Apply button clicked!');
    }
}