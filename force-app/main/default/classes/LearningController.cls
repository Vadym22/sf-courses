public with sharing class LearningController {

    @AuraEnabled
    public static List<LearningService.CourseModel> getCourses() {
        return LearningService.getCourses();
    }

    @AuraEnabled
    public static Boolean isCourseAdmin() {
        return LearningService.isCourseAdmin();
    }
}