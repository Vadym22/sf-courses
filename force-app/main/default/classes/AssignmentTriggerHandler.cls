public with sharing class AssignmentTriggerHandler {
  public static void handleAfterInsert(List<Course_Assignment__c> newAssignments) {
    LearningService.sendAssignmentNotifications(newAssignments);
  }
}
