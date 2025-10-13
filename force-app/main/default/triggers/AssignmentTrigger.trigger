trigger AssignmentTrigger on Course_Assignment__c (after insert) {
    if(Trigger.isAfter && Trigger.isInsert) {
        AssignmentTriggerHandler.handleAfterInsert(Trigger.new);
    }
}