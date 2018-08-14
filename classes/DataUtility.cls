/*
* Name:        DataUtility
* Purpose:    Utility class to create bulk data
* Vlocity, 8/2016
*/
@isTest
public class DataUtility {
    public static List<Opportunity> createoppBroker(Integer numOpps, Account acc,Contact con) {
        
        List<Opportunity> opps = new List<Opportunity>();
        
        for(Integer i=0;i<numOpps;i++) {
            Opportunity o = new Opportunity(
                Name = 'TestOpp'+i,
                AccountID = acc.Id,
                CloseDate = System.today()+1,
                Secondary_Disposition_new__c = 'Opportunity',
                Broker__c = con.Id,
                RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SG Quoting').getRecordTypeId(),
                StageName = 'Quote Provided'
            );
            opps.add(o);
        }
        
        return opps;
    }
    
    public static List<Opportunity> createoppPaidAgency(Integer numOpps, Account acc,Contact con) {
       
        List<Opportunity> opps = new List<Opportunity>();
        
        for(Integer i=0;i<numOpps;i++) {
            Opportunity o = new Opportunity(
                Name = 'TestOpp'+i,
                AccountID = acc.Id,
                CloseDate = System.today()+1,
                Secondary_Disposition_new__c = 'Opportunity',
                 PaidAgency__c = acc.Id,
                RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SG Quoting').getRecordTypeId(),
                StageName = 'Quote Provided'
            );
            opps.add(o);
        }
        
        return opps;
    }
    
    public static List<Opportunity> createoppGeneralAgency(Integer numOpps, Account acc,Contact con) {
       
        List<Opportunity> opps = new List<Opportunity>();
        
        for(Integer i=0;i<numOpps;i++) {
            Opportunity o = new Opportunity(
                Name = 'TestOpp'+i,
                AccountID = acc.Id,
                CloseDate = System.today()+1,
                Secondary_Disposition_new__c = 'Opportunity',
                 GeneralAgency__c = acc.Id,
                RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SG Quoting').getRecordTypeId(),
                StageName = 'Quote Provided'
            );
            opps.add(o);
        }
        
        return opps;
    }
}