public with sharing class LearningController {

    public static string methodName(){
        try {
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<LearningService.CourseModel> getCourses() {
        return LearningService.getCourses();
    }

    public static Boolean isCourseAdmin() {
        return LearningService.isCourseAdmin();
    }
}