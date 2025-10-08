public with sharing class LearningSelector {

    public static List<Course__c> getCourses() {
        return [
            SELECT Id, Name, Description__c, Course_image__c
            FROM Course__c
            ORDER BY Name
        ];
    }

    public static Boolean isCourseAdmin(Id userId) {
        Set<String> userPermissionSets = new Set<String>();
        
        for (PermissionSetAssignment psa : [
            SELECT PermissionSet.Name 
            FROM PermissionSetAssignment 
            WHERE AssigneeId = :userId
        ]) {
            userPermissionSets.add(psa.PermissionSet.Name);
        }
        
        return userPermissionSets.contains('Course_Admin');
    }
}