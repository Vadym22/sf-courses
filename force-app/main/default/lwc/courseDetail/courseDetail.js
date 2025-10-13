import { LightningElement, api, wire } from 'lwc';
import { getRecord, deleteRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { navigate } from 'c/navigationUtil';
import isCourseAdmin from '@salesforce/apex/LearningController.isCourseAdmin';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import USER_ID from '@salesforce/user/Id';

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

    async connectedCallback() {
        try {
            this.isAdmin = await isCourseAdmin();
        } catch (error) {
            console.error('Error fetching user role', error);
        }
    }

    handleEdit() {
        navigate(this, 'Course__c', 'edit', this.recordId);
    }

    handleNew() {
        navigate(this, 'Course__c', 'new');
    }

    handleBack() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Learning_Home'
            }
        });
    }

    handleAssign() {
        console.log('handleAssign');
        const defaultValues = encodeDefaultFieldValues({
            Course__c: this.recordId,
            Assignee__c: this.isAdmin ? null : USER_ID
        });
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Course_Assignment__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }

    handleDelete() {
        deleteRecord(this.recordId)
            .then(() => {
                console.log('delete success');
                this.handleBack();
            })
            .catch(error => {
                console.log('delete error: ', error);
            });
    }
}
