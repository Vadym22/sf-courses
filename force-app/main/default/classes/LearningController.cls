public with sharing class LearningController {

    @AuraEnabled(cacheable=true)
    public static List<LearningService.CourseModel> getCourses() {
        return LearningService.getCourses();
    }

    @AuraEnabled(cacheable=true)
    public static Boolean isCourseAdmin() {
        return LearningService.isCourseAdmin();
    }
}