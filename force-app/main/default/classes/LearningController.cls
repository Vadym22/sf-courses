public with sharing class LearningController {

    @AuraEnabled
    public static List<CourseService.CourseModel> getCourses() {
        return CourseService.getCourses();
    }

    @AuraEnabled(cacheable=true)
    public static List<CourseService.CourseAssignmentModel> getMyCourses() {
        return CourseService.getMyCourses();
    }

    @AuraEnabled
    public static Boolean isCourseAdmin() {
        return CourseService.isCourseAdmin();
    }
}