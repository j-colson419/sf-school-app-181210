public class GradeCalculationHelper {

    
    public static void updateClassGradeAverage(List<Grade__c> newGrades){
        List<Id> CeIds = new List<Id>();
        for(Grade__c gradeRecord : newGrades){
            CeIds.add(gradeRecord.Class_Enrollment__c);
        }
        AggregateResult[] aggResults = [SELECT AVG(Grade__c)average, Class_Enrollment__c
                                         FROM Grade__c
                                         WHERE Class_Enrollment__c IN :CeIds
                                         GROUP BY Class_Enrollment__c];
        
        List<ClassEnrollment__c> CEsToUpdate = new List<ClassEnrollment__c>();
        for(AggregateResult ar : aggResults){
            CEsToUpdate.add(new ClassEnrollment__c(Id = (Id)ar.get('Class_Enrollment__c'), ClassGrade__c = (Decimal)ar.get('average')));
        }
        
        update CEsToUpdate;
        
    }//end of updateClassGradeAverage method
    
    
    
}