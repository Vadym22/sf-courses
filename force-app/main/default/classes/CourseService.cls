public with sharing class CourseService {
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

    public class CourseAssignmentModel {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String assignmentId { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String description { get; set; }
        @AuraEnabled public String imageUrl { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public String score { get; set; }

        private CourseAssignmentModel(Course_Assignment__c assignment) {
            id = assignment.Course__r.Id;
            assignmentId = assignment.Id;
            name = assignment.Course__r.Name;
            description = assignment.Course__r.Description__c;
            imageUrl = assignment.Course__r.Course_image__c;
            status = assignment.Status__c;
            score = assignment.Score__c != null ? String.valueOf(assignment.Score__c) : null;
        }
    }

    public static List<CourseModel> mapToModelCourse(List<Course__c> courses) {
        List<CourseModel> result = new List<CourseModel>();
        for (Course__c c : courses) {
            result.add(new CourseModel(c));
        }
        return result;
    }

    public static List<CourseAssignmentModel> mapToModelCourseAssignment(List<Course_Assignment__c> assignments) {
        List<CourseAssignmentModel> result = new List<CourseAssignmentModel>();
        for (Course_Assignment__c assignment : assignments) {
            result.add(new CourseAssignmentModel(assignment));
        }
        return result;
    }

    public static List<CourseModel> getCourses() {
        List<Course__c> records = LearningSelector.getCourses();
        return mapToModelCourse(records);
    }

    public static List<CourseAssignmentModel> getMyCourses() {
        List<Course_Assignment__c> records = LearningSelector.getMyCourses(UserInfo.getUserId());
        return mapToModelCourseAssignment(records);
    }

    public static Boolean isCourseAdmin() {
        return LearningSelector.isCourseAdmin(UserInfo.getUserId());
    }

}
