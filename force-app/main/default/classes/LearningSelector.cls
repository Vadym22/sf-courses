public with sharing class LearningSelector {

    public static List<Course__c> getCourses() {
        return [
            SELECT Id, Name, Description__c, Course_image__c
            FROM Course__c
            ORDER BY Name
        ];
    }

    public static List<Course_Assignment__c> getMyCourses(Id userId) {
        return [
            SELECT Id, Status__c, Score__c, Course__r.Id, Course__r.Name, Course__r.Description__c, Course__r.Course_image__c
            FROM Course_Assignment__c
            WHERE Assignee__c = :userId
            ORDER BY Status__c, Course__r.Name
        ];
    }

    public static Boolean isCourseAdmin(Id userId) {
        return [
            SELECT COUNT() 
            FROM PermissionSetAssignment 
            WHERE AssigneeId = :userId 
            AND PermissionSet.Name = :LearningConstants.COURSE_ADMIN_PERMISSION_SET
        ] > 0;
    }
}