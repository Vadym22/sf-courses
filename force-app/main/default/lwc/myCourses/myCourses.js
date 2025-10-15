import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getMyCourses from '@salesforce/apex/LearningController.getMyCourses';
import { navigate } from 'c/navigationUtil';

export default class MyCourses extends NavigationMixin(LightningElement) {
    courses;
    error;

    @wire(getMyCourses)
    wiredCourses({ data, error }) {
        if (data) {
            this.courses = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.courses = undefined;
        }
    }
    handleCourseClick(event) {
        const courseId = event.currentTarget.dataset.courseId;
        const course = this.courses.find(c => c.id === courseId);
        console.log('Clicked course:', courseId, course.name);
        console.log('Assignment ID:', course.assignmentId);
        // TODO: Logic
    }
}