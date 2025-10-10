import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getCourses from '@salesforce/apex/LearningController.getCourses';
import isCourseAdmin from '@salesforce/apex/LearningController.isCourseAdmin';
import { navigate } from 'c/navigationUtil';

export default class CourseList extends NavigationMixin(LightningElement) {
    courses;
    error;
    isAdmin;

    connectedCallback() {
        getCourses()
            .then(result => {
                this.courses = result;
            })
            .catch(error => {
                this.error = error;
                console.error('Error fetching courses', error);
            });

        isCourseAdmin()
            .then(result => {
                this.isAdmin = result;
            })
            .catch(error => {
                console.error('Error fetching user role', error);
            });
    }

    handleNew() {
        navigate(this, 'Course__c', 'new');
    }

    handleNavigate(event) {
        const recordId = event.target.dataset.id;
        navigate(this, 'Course__c', 'view', recordId);
    }

    handleApply() {
        console.log('Apply button clicked!');
    }
}