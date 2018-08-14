public class Util04_BusinessTrack{
    public static string businessTrackValue;
    public static void retrieveBusinessTrackValue(List<Sobject> recList){
        Set<Id> recordTypeIds = New Set<Id>();
        Map<String,String> recordTypeBusinessTrackMap = New Map<String,String>();
        for(SObject s : recList){
            recordTypeIds.add(String.ValueOf(s.get('recordTypeID')));    
        }
        System.debug('*****recordTypeIds'+recordTypeIds);
        //added by Lakshmi Sheshadri for null check
        if(!recordTypeIds.isEmpty())
        recordTypeBusinessTrackMap = constructMap(recordTypeIds);
        for(Sobject s : recList){
            if(recordTypeBusinessTrackMap.containsKey(String.ValueOf(s.get('recordTypeID'))) && recordTypeBusinessTrackMap.get(String.ValueOf(s.get('recordTypeID'))) != null){
                if(s.get('Tech_BusinessTrack__c') != null || s.get('Tech_BusinessTrack__c') != recordTypeBusinessTrackMap.get(String.ValueOf(s.get('recordTypeID')))){
                    s.put('Tech_BusinessTrack__c',recordTypeBusinessTrackMap.get(String.ValueOf(s.get('recordTypeID')))); 
                }
                businessTrackValue = recordTypeBusinessTrackMap.get(String.ValueOf(s.get('recordTypeID'))); 
            }

        }
        System.debug('*****businessTrackValue'+businessTrackValue);
    }
    public static Map<String,String> constructMap(Set<Id> recordTypeIds){
        Map<String,String> recordTypeBusinessTrackMap = New Map<String,String>();
        List<RecordType> recordTypeList = New List<RecordType>();
        recordTypeList = [Select Name,id,SobjectType from RecordType where id in:recordTypeIds];
        System.debug('*****recordTypeList'+recordTypeList);
        if(!recordTypeList.isEmpty()){
            for(RecordType r : recordTypeList){
               recordTypeBusinessTrackMap.put(r.id,CS001_RecordTypeBusinessTrack__c.getValues(r.SobjectType+'_'+r.name).BusinessTrackName__c);   
            }
        }
        System.debug('*****recordTypeBusinessTrackMap'+recordTypeBusinessTrackMap);
        return recordTypeBusinessTrackMap;
    }
}