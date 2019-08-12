trigger AssessmentTrigger on Assessment__c (after insert) {

    if(Trigger.isAfter && Trigger.isInsert){
        //get class Ids for each of the Assessments
        List<Id> classIds = new List<Id>();
        for(Assessment__c a : Trigger.new){
            classIds.add(a.Class__c);
        }
        
        //get a list of CEs related to the classes
        List<ClassEnrollment__c> ceList = ClassEnrollmentTriggerHelper.getCEsForClasses(classIds);
        
        //create grades associated with the assessments and CEs
        if(ceList.size() > 0){
            ClassEnrollmentTriggerHelper.createAndInsertGrades(Trigger.new, ceList);
        }
        
    }
    
}