global with sharing class GeographyInfo {

    //public GeographyInfo() { } 
    
    @RemoteAction
    global static List<Geographical_Info__c> getCounty(String ZipCode) {
     List<Geographical_Info__c> County= [SELECT Id,Name,Area__c,County__c,RatingArea__c,SearchField__c,Zip_Code__c,State__c FROM Geographical_Info__c WHERE (Zip_Code__c LIKE : ZipCode) ORDER BY Zip_Code__c];
        return County;   
    }
}