public with sharing class LearningSelector {

    public static List<Course__c> getCourses() {
        return [
            SELECT Id, Name, Description__c, Course_image__c
            FROM Course__c
            ORDER BY Name
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