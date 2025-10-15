import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getMyCourses from '@salesforce/apex/LearningController.getMyCourses';

export default class MyCourses extends NavigationMixin(LightningElement) {
    _courses;
    _error;

    @wire(getMyCourses)
    wiredCourses({ data, error }) {
        if (data) {
            this._courses = data;
            this._error = undefined;
        } else if (error) {
            this._error = error;
            this._courses = undefined;
        }
    }
    handleCourseClick(event) {
        const courseId = event.currentTarget.dataset.courseId;
        const course = this._courses.find(c => c.id === courseId);
        console.log('Clicked course:', courseId, course.name);
        console.log('Assignment ID:', course.assignmentId);
        // TODO: Logic
    }
}