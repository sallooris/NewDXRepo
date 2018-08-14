global with sharing class INS_GeographyInfo implements vlocity_ins.VlocityOpenInterface2{
    
    public List<Map<String, String>> invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
   
        try{
            if(methodName == 'getCounty') {
                return getCounty(inputMap, outMap, options);
            }
        }catch(Exception e){
            System.debug(' exception '+e);
            throw e;
        }
        
        return null;
    }
    
    public List<Map<String, String>> getCounty(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        System.debug('The inputMap is' + inputMap.get('zipPage'));
        
        Map<String,Object> zipPage = (Map<String,Object>) inputMap.get('zipPage');
        String ZipCode = (String) zipPage.get('zipCode');
        List<Ins_Geography__c> County= [SELECT County__c, County_Code__c, Rating_Area__c FROM Ins_Geography__c WHERE (Zipcode__c LIKE : ZipCode) ORDER BY Zipcode__c];
        System.debug('The County is' + County);
        
        List<Map<String, String>> CountyList = new List<Map<String,String>>();   
        for (Ins_Geography__c c : County) {
            Map<String, String> CountyMap = new Map<String, String>();
            CountyMap.put('value', c.County__c);
            CountyMap.put('name', c.County_Code__c);
            CountyList.add(CountyMap);
        }
        System.debug('The CountyList is' + CountyList);
        outMap.put('options', CountyList);
        return CountyList;   
    }
}