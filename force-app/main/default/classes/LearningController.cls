public with sharing class LearningController {

    @AuraEnabled
    public static List<CourseService.CourseModel> getCourses() {
        return CourseService.getCourses();
    }

    @AuraEnabled
    public static Boolean isCourseAdmin() {
        return CourseService.isCourseAdmin();
    }
}