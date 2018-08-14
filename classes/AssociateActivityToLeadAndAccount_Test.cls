@isTest 
//(SeeAllData=true)
public with sharing class AssociateActivityToLeadAndAccount_Test 
{
    static TestMethod void testActivityAssociation()
    {
        User testUser = BR_Util01_TestMethods.CreateTestUser();
        insert testUser;
 
		List<CS001_RecordTypeBusinessTrack__c> cs001List = BR_Util01_TestMethods.createBusinessTrack();
        insert cs001List; 
           
		// create campaign
		List<RecordType> recList = [SELECT Id, name FROM RECORDTYPE WHERE Name = 'TS MASTER' and sObjectType = 'Campaign'];
		
		Campaign camp = new Campaign (Name = 'C100', StartDate = Date.ValueOf('2000-06-01 00:00:00'), EndDate = Date.ValueOf('2099-06-01 00:00:00'), RecordTypeId = recList[0].Id, IsActive = true, State__c = 'CA', Toll_Free_Number__c = '(888) 555-3333');
		Campaign camp2 = new Campaign (Name = 'C100', StartDate = Date.ValueOf('2000-06-01 00:00:00'), EndDate = Date.ValueOf('2099-07-01 00:00:00'), RecordTypeId = recList[0].Id, IsActive = true, State__c = 'CA', Toll_Free_Number__c = '(888) 555-3333');
		Campaign camp3 = new Campaign (Name = 'C100', StartDate = Date.ValueOf('2000-06-01 00:00:00'), EndDate = Date.ValueOf('2099-08-01 00:00:00'), RecordTypeId = recList[0].Id, IsActive = true, State__c = 'UK', Toll_Free_Number__c = '(888) 555-1111');
 		Campaign camp4 = new Campaign (Name = 'C200', StartDate = Date.ValueOf('2000-06-01 00:00:00'), EndDate = Date.ValueOf('2099-08-01 00:00:00'), RecordTypeId = recList[0].Id, IsActive = true, State__c = 'OH', Toll_Free_Number__c = '(888) 555-9999');
		Campaign camp5 = new Campaign (Name = 'C100', StartDate = Date.ValueOf('2000-06-01 00:00:00'), EndDate = Date.ValueOf('2099-08-01 00:00:00'), RecordTypeId = recList[0].Id, IsActive = true, State__c = 'UK', Toll_Free_Number__c = '(888) 555-1111');
		
 		List<RecordType> taskrecList = [SELECT id FROM RECORDTYPE WHERE sObjectType = 'Task' AND Name = 'Inbound/Outbound Call Activity'];
        system.debug('taskrecList[0].Id = '+taskrecList[0].Id);
        Task tk = new Task(Activity_Type__c = 'Inbound Call', DNIS__c = '(888) 555-3333', RecordTypeId = taskrecList[0].Id, ANI__c = '1112223333');
		
		Lead ld = new Lead(Firstname = 'LdTestF1', Inbound_Activity_Id__c ='34242', LastName = 'LdTestL1', State__c = 'CA', Call_ID__c = '123451', Zip_Code__c = 'a0ye000000910yHAAQ', Phone = '(111) 222-3333', Work_Phone__c = '(111) 222-3333', Mobile_Phone__c = '(111) 222-3333');
		
		Account acc = new Account(Firstname = 'AcTestF1', LastName = 'AcTestL1', Inbound_Activity_Id__c ='34242', State__c = 'CA', Customer_Stage__c = 'New Lead', Date_of_Birth__c = Date.ValueOf('1988-05-28'), Phone = '(444) 555-6666', Work_Phone__c = '(444) 555-6666', Mobile_Phone__c = '(444) 555-6666');
 
        try
        {
            System.runAs(testUser)
            {
	            Test.startTest();
	    		insert camp;
	            insert camp2;
	            tk.OwnerId = testUser.Id;
	            insert tk;
				System.debug('task id: '+tk.Id);
	            insert ld;
	            System.debug('lead id: '+ld.Id);
	            ld.Mobile_Phone__c = '(111) 222-4444';
	            ld.Inbound_Activity_Id__c = null;
	            AssociateActivityToLeadAndAccount.currObjId = null;
	            update ld;
				AssociateActivityToLeadAndAccount.currObjId = null;
				insert camp4;
				Task tk2 = new Task(Activity_Type__c = 'Inbound Call', DNIS__c = '(888) 555-9999', RecordTypeId = taskrecList[0].Id,  ANI__c = '4445556666');
	            tk2.OwnerId = testUser.Id;
	            insert tk2;
	            System.debug('task 2 id: '+tk2.Id);
	            insert acc;
				System.debug('acc id: '+acc.Id);
				AssociateActivityToLeadAndAccount.currObjId = null;
	           	acc.Inbound_Activity_Id__c = null;
	            acc.Tobacco_User__c = 'Yes';
	           	system.debug('before update account');
	            update acc;
	            system.debug('after update account - test');
	            AssociateActivityToLeadAndAccount.currObjId = null;
	            insert camp3;
	            insert camp5;
	            Task tk3 = new Task(Activity_Type__c = 'Inbound Call', DNIS__c = '(888) 555-1111', RecordTypeId = taskrecList[0].Id,  ANI__c = '4445556666');
	            tk3.OwnerId = testUser.Id;
	            insert tk3;
	            FeedItem fi = new FeedItem (Body = 'test feed', ParentId=ld.Id); 
	            insert fi;
	            AssociateActivityToLeadAndAccount.currObjId = null;
	            FeedComment fc = new FeedComment (CommentBody = 'test comment', FeedItemId=fi.Id);
	            insert fc;
				Test.stopTest();
	        }
		}
        catch(Exception ex)
        {
              System.debug('Exception in Test Class:AssociateActivityToLeadAndAccount_Test '+ex.getMessage());
        }
    }
}