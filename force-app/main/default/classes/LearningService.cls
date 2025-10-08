public with sharing class LearningService {
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