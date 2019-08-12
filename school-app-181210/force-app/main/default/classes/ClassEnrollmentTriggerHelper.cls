public class ClassEnrollmentTriggerHelper {

    public static List<Assessment__c> getAssessmentsForClasses(List<Id> classIds){
        List<Assessment__c> assessmentList = new List<Assessment__c>();
        assessmentList = [SELECT Id, Class__c 
                          FROM Assessment__c 
                          WHERE Class__c IN :classIds];
        return assessmentList;
    }
    
    public static List<ClassEnrollment__c> getCEsForClasses(List<Id> classIds){
        List<ClassEnrollment__c> ceList = new List<ClassEnrollment__c>();
        ceList = [SELECT Id, Class__c 
                          FROM ClassEnrollment__c 
                          WHERE Class__c IN :classIds];
        return ceList;
    }

    public static void createAndInsertGrades(List<Assessment__c> asmntList, List<ClassEnrollment__c> ceList){
        
        List<Grade__c> newGrades = new List<Grade__c>();
        
        for(ClassEnrollment__c ce : ceList){
            for(Assessment__c a : asmntList){
                if(ce.Class__c == a.Class__c){
                    Grade__c newG = new Grade__c();
                    newG.Class_Enrollment__c = ce.Id;
                    newG.Assessment__c = a.Id;
                    newGrades.add(newG);
                    //the below line is the same as the above 4 lines
                    //newGrades.add(new Grade__c(Class_Enrollment__c = ce.Id, Assessment__c = a.Id));
                }
            }//end of inner for loop
        }//end of outer for loop
        
        insert newGrades;
        
    }//end of createAndInsertGrades Method
    
    
}//end of helper class