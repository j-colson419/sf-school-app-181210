public class DuplicateChecker {

    public static List<Boolean> areUniqueGrades(List<Grade__c> grades){
        List<Boolean> resultsList = new List<Boolean>();
        List<Id> ceIds = new List<Id>();
        List<Id> assessmentIds = new List<Id>();
        for(Grade__c g : grades){
            ceIds.add(g.Class_Enrollment__c);
            assessmentIds.add(g.Assessment__c);
        }
        
        AggregateResult[] arList = [SELECT COUNT(Id), Class_Enrollment__c, 
                                    Assessment__c FROM Grade__c
                                    WHERE Class_Enrollment__c IN :ceIds
                                    AND Assessment__c IN :assessmentIds
                                    GROUP BY Class_Enrollment__c, Assessment__c];
        
        Integer previousSize = resultsList.size();
        for(Grade__c g : grades){
            for(AggregateResult ar : arList){
                if((Id)ar.get('Class_Enrollment__c') == g.Class_Enrollment__c
                   && (Id)ar.get('Assessment__c') == g.Assessment__c){
                       resultsList.add(False);
                       break;
                   } 
            }
            if(resultsList.size() == previousSize){
                resultsList.add(True); 
                previousSize++;
            }
			           
        }
        
        return resultsList;
    }
    
}