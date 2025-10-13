public without sharing class AssignmentTriggerHandler {
  public static void handleAfterInsert(List<Course_Assignment__c> newAssignments) {
    AssignmentService.sendAssignmentNotifications(newAssignments);
  }
}
