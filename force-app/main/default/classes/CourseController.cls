public with sharing class CourseController {
    public class CourseModel {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String Description { get; set; }
        @AuraEnabled public String ImageUrl { get; set; }

        public CourseModel(Course__c c) {
            Id = c.Id;
            Name = c.Name;
            Description = c.Description__c;
            ImageUrl = c.Course_image__c;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<CourseModel> getCourses() {
        List<Course__c> courseRecords = [
            SELECT Id, Name, Description__c, Course_image__c
            FROM Course__c
            ORDER BY Name
        ];

        List<CourseModel> result = new List<CourseModel>();
        for (Course__c c : courseRecords) {
            result.add(new CourseModel(c));
        }
        return result;
    }
}