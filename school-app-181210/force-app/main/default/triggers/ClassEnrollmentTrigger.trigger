trigger ClassEnrollmentTrigger on ClassEnrollment__c (after insert, after update, after delete, after undelete) {

    if(Trigger.isAfter && Trigger.isInsert){
        //get class Ids for each of the Class Enrollments
        List<Id> classIds = new List<Id>();
        for(ClassEnrollment__c ce : Trigger.new){
            classIds.add(ce.Class__c);
        }
        //get a list of assessments related to those classes
        List<Assessment__c> asmntList = ClassEnrollmentTriggerHelper.getAssessmentsForClasses(classIds);
        
        //create grades associated with the assessments and CEs
        if(asmntList.size() > 0){
            ClassEnrollmentTriggerHelper.createAndInsertGrades(asmntList, Trigger.new);
        }
        
    }
    
}