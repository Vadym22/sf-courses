import { NavigationMixin } from 'lightning/navigation';

export const navigate = (component, objectApiName, action, recordId = null, defaultValues = null) => {
    let config;

    if (action === 'new') {
        config = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: objectApiName,
                actionName: 'new'
            },
            state: defaultValues
                ? { defaultFieldValues: defaultValues }
                : {}
        };
    } else if (action === 'view' || action === 'edit') {
        if (!recordId) {
            throw new Error(`recordId is required for ${action} action`);
        }
        config = {
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: objectApiName,
                actionName: action
            }
        };
    } else {
        throw new Error(`Unsupported action: ${action}`);
    }

    component[NavigationMixin.Navigate](config);
};
