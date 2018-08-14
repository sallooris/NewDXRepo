/*************************************************************
Class Name : BR_AP02_CreateCTIActivityOnCase_Test
Date Created : 07-Sep-2015
Created By   : Nagarjuna Kaipu
Description  : Used to test BR_AP02_CreateCTIActivityOnCase class, Case After insert & Update triggers, CaseComment After Insert & Update triggers
**************************************************************/
@isTest
public class BR_AP02_CreateCTIActivityOnCase_Test
{
    static TestMethod void testCTIProgressActivity()
    {
        User testUser = BR_Util01_TestMethods.CreateTestUser();
        insert testUser;

        List<CS001_RecordTypeBusinessTrack__c> cs001List = BR_Util01_TestMethods.createBusinessTrack();
        insert cs001List; 
        
        Call_Info__c cinfo = BR_Util01_TestMethods.CreateCallInfo();
        system.debug('call info create time = '+cinfo.CreatedDate);
        system.debug('call info end date = '+cinfo.BR_Phone_Number__c);
        system.debug('call info lastmodified date = '+cinfo.LastModifiedDate);

        Case c = BR_Util01_TestMethods.CreateCase();
        system.debug('case call id create time = '+c.Call_Id_Create_Time__c);
        //c.BR_Tech_Case_RoutingAddress__c = 'standarduser@testorg.com';
        CaseComment cc = BR_Util01_TestMethods.CreateCaseComment();

        try
        {
        	System.runAs(testUser)
//            System.runAs()
			{
                Test.startTest();
                cinfo.OwnerId = testUser.Id;
                insert cinfo;
                insert c;
                System.debug('Case is: '+c);
                c.Priority = 'Urgent';
                update c;
                cc.parentId = c.Id;
                insert cc;   
                cc.CommentBody = 'Naga Comments';
                update cc;
                
                Task t = [SELECT BR_Call_ID__c FROM TASK WHERE WHATID =: c.ID LIMIT 1];
                System.assertEquals(t.BR_Call_ID__c, 'NAGA12345');
                Test.stopTest();
            }
        }
        catch(Exception ex)
        {
              System.debug('Exception in Test Class: '+ex.getMessage());
        }
    }
}