public with sharing class LearningService {
    public class CourseModel {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String description { get; set; }
        @AuraEnabled public String imageUrl { get; set; }

        private CourseModel(Course__c c) {
            id = c.Id;
            name = c.Name;
            description = c.Description__c;
            imageUrl = c.Course_image__c;
        }
    }

    public static List<CourseModel> mapToModel(List<Course__c> courses) {
        List<CourseModel> result = new List<CourseModel>();
        for (Course__c c : courses) {
            result.add(new CourseModel(c));
        }
        return result;
    }

    public static List<CourseModel> getCourses() {
        List<Course__c> records = LearningSelector.getCourses();
        return mapToModel(records);
    }

    public static Boolean isCourseAdmin() {
        return LearningSelector.isCourseAdmin(UserInfo.getUserId());
    }

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
            Id emailTemplateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :EMAIL_TEMPLATE_NAME LIMIT 1].Id;
            
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
            Id notificationTypeId = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = :NOTIFICATION_NAME LIMIT 1].Id;
            
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