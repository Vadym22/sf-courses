public with sharing class LearningController {

    public static List<LearningService.CourseModel> getCourses() {
        return LearningService.getCourses();
    }

    public static Boolean isCourseAdmin() {
        return LearningService.isCourseAdmin();
    }
}