public with sharing class AssignmentTriggerHandler {
  public static void handleAfterInsert(List<Course_Assignment__c> newAssignments) {

    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    Id emailTemplateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName='Assignment_Notification_Email' LIMIT 1].Id;
    Id notificationTypeId = [SELECT Id FROM CustomNotificationType WHERE DeveloperName='Assignment_Notification' LIMIT 1].Id;

    for(Course_Assignment__c a : newAssignments) {
      if(a.Assignee__c != null) {

        // ---------- EMAIL ----------
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(a.Assignee__c);
        mail.setTemplateId(emailTemplateId);
        mail.setSaveAsActivity(false);
        emails.add(mail);

        // ---------- BELL NOTIFICATION ----------
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle('You have been assigned to a course');
        notification.setBody('Course: ' + a.Course__c);
        notification.setSenderId(UserInfo.getUserId());
        notification.setNotificationTypeId(notificationTypeId);
        notification.setTargetId(a.Id);
        notification.send(new Set<String>{String.valueOf(a.Assignee__c)});
      }
    }

    if(!emails.isEmpty()) {
      Messaging.sendEmail(emails);
    }
  }
}
