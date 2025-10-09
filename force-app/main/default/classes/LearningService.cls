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
        Id currentUserId = UserInfo.getUserId();
        return LearningSelector.isCourseAdmin(currentUserId);
    }
}