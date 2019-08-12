trigger GradeTrigger on Grade__c (before insert, after insert, after update, after delete, after undelete) {

    /* Best Practice #1 - only have ONE trigger per sObject */
    /* Best Practice #2 - bulkify your triggers */
    /* Best Practice #3 - use context variables to determine path of logic */
    /* Best Practice #4 - all business logic should be contained OUTSIDE of the Trigger */
    
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete)){
        //1. check to see if the grade record has a non-null grade__c value
        List<Grade__c> hasGradeValue = new List<Grade__c>(); //to store records that do have a grade value
        for (Grade__c gradeRecord : Trigger.new){
            if(gradeRecord.grade__c != null){
                hasGradeValue.add(gradeRecord);
            }
        }
        
        //2. if it does then update the classGrade__c field on the 
        //		related ClassEnrollment__c record
        if(hasGradeValue.size() > 0){
        	GradeCalculationHelper.updateClassGradeAverage(hasGradeValue);
        }
        
    } else if (Trigger.isAfter && Trigger.isDelete){
        //1. check to see if the grade record has a non-null grade__c value
        List<Grade__c> hasGradeValue = new List<Grade__c>(); //to store records that do have a grade value
        for (Grade__c gradeRecord : Trigger.old){
            if(gradeRecord.grade__c != null){
                hasGradeValue.add(gradeRecord);
            }
        }
        
        //2. if it does then update the classGrade__c field on the 
        //		related ClassEnrollment__c record
        if(hasGradeValue.size() > 0){
        	GradeCalculationHelper.updateClassGradeAverage(hasGradeValue);
        }
    } else if (Trigger.isBefore && Trigger.isInsert){
        //Trigger.new[0].Class_Enrollment__c.addError('Testing Add Error on Class Enrollment Field');
    	List<Boolean> resultsList = DuplicateChecker.areUniqueGrades(Trigger.new);
        for(Integer i = 0; i < resultsList.size(); i++){
            if(!resultsList[i]){
                Trigger.new[i].addError('A grade record has already been created '
                                        +'for this Student on this Assessment.');
            }
        }
    }
    
    
    
}