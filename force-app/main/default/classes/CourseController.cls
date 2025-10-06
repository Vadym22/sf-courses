public with sharing class CourseController {
    @AuraEnabled(cacheable=true)
    public static List<Course__c> getCourses() {
        return [SELECT Id, Name, Description__c, Course_image__c FROM Course__c ORDER BY Name];
    }
}