public with sharing class AssignmentService {
    
    public static void sendAssignmentNotifications(List<Course_Assignment__c> assignments) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Course_Assignment__c assignment : assignments) {
            if(assignment.Assignee__c == null) {
                continue;
            }
            
            Messaging.SingleEmailMessage mail = createAssignmentMail(assignment);
            if(mail != null) {
                emails.add(mail);
            }
            
            createAssignmentNotification(assignment);
        }
        
        if(!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
    
    private static Messaging.SingleEmailMessage createAssignmentMail(Course_Assignment__c assignment) {
        try {
            Id emailTemplateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :LearningConstants.ASSIGNMENT_NOTIFICATION_EMAIL LIMIT 1].Id;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(assignment.Assignee__c);
            mail.setTemplateId(emailTemplateId);
            mail.setSaveAsActivity(false);
            
            return mail;
        } catch(Exception e) {
            System.debug('Error creating email for assignment: ' + assignment.Id + ' - ' + e.getMessage());
            return null;
        }
    }
    
    private static void createAssignmentNotification(Course_Assignment__c assignment) {
        try {
            Id notificationTypeId = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = :LearningConstants.ASSIGNMENT_NOTIFICATION LIMIT 1].Id;
            
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle('You have been assigned to a course');
            notification.setBody('Course: ' + assignment.Course__c);
            notification.setSenderId(UserInfo.getUserId());
            notification.setNotificationTypeId(notificationTypeId);
            notification.setTargetId(assignment.Id);
            notification.send(new Set<String>{String.valueOf(assignment.Assignee__c)});
        } catch(Exception e) {
            System.debug('Error creating notification for assignment: ' + assignment.Id + ' - ' + e.getMessage());
        }
    }
}
