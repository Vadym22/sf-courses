import { LightningElement, track, wire } from 'lwc';
import getCourses from '@salesforce/apex/CourseController.getCourses';

export default class CourseList extends LightningElement {
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
}