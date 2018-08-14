@isTest
public class DuplicateRecordItemAfterInsert_Test{
  private static testMethod void testDuplicateRules1()
  { 
       Postal_Code_County__c pCode = Util02_TestData.insertZipCode();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
       Database.insert(pCode);
       ID taskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'TS MASTER' AND SobjectType ='Lead' LIMIT 1].Id;
       pCode = [select Id, Name from Postal_Code_County__c where Id = :pCode.Id];  
       Lead ldObj=Util02_TestData.insertLead();
       ldObj.firstname = 'Bhaskar';
       ldObj.lastname = 'Bellapu';
       ldObj.email__c='brr@g.com';    
       ldObj.zip_code__c = pCode.Id;
       ldObj.customer_score__c='1';
       ldObj.RecordTypeId = taskRecordTypeId;
       Database.insert(ldObj);
       Lead ldObj1=Util02_TestData.insertLead();
       ldObj1.firstname = 'Bhaskar';
       ldObj1.lastname = 'Bellapu';
       ldObj1.email__c='brr@g.com';    
       ldObj1.zip_code__c = pCode.Id;
       ldObj1.customer_score__c='1';
       ldObj1.RecordTypeId = taskRecordTypeId;
       //Database.insert(ldObj1);
       Database.SaveResult sr = Database.insert(ldObj1, false);
       Set<Id> setDuplicateIds = new Set<id>();
       if (!sr.isSuccess()) {
            Datacloud.DuplicateResult duplicateResult;
            // Insertion failed due to duplicate detected
            for(Database.Error duplicateError : sr.getErrors()){
                duplicateResult = ((Database.DuplicateError)duplicateError).getDuplicateResult();
            }
            String duplicateRule = duplicateResult.getDuplicateRule();
            List<DuplicateRule> dupRuleList = [SELECT Id FROM DuplicateRule where masterlabel=:duplicateRule LIMIT 1];
            ID ids = dupRuleList[0].id;
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult sr2 = Database.insert(ldObj1, dml);
            DuplicateRecordSet drs = new DuplicateRecordSet();
            drs.DuplicateRuleId = ids;
            insert drs;
            DuplicateRecordItem dri = new DuplicateRecordItem();
            dri.DuplicateRecordSetId = drs.id;
            dri.RecordId = ldObj1.id;
            insert dri;
       }
    }
}