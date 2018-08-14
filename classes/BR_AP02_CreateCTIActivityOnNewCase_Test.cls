@isTest
public class BR_AP02_CreateCTIActivityOnNewCase_Test
{
    static TestMethod void testCTIProgressActivity()
    {
        User testUser = BR_Util01_TestMethods.CreateTestUser();
        insert testUser; 
        try
        {
            System.runAs(testUser)
            {
                List<CS001_RecordTypeBusinessTrack__c> cs001List = BR_Util01_TestMethods.createBusinessTrack();
                insert cs001List; 
    
                Call_Info__c cinfo = BR_Util01_TestMethods.CreateCallInfo();
                Case c = BR_Util01_TestMethods.CreateCase();
    
                cinfo.OwnerId = testUser.Id;
                insert cinfo;
                Test.setCreatedDate(cinfo.Id, system.now().addHours(-1));        
                Test.startTest();
                insert c;
                System.debug('Case is: '+c);

                Task tk = BR_Util01_TestMethods.CreateTask();
                Task t = [SELECT BR_Call_ID__c FROM TASK WHERE WHATID =: c.ID LIMIT 1];
                System.assertEquals(t.BR_Call_ID__c, 'NAGA12345');
                
                //
				Call_Info__c cinfo1 = BR_Util01_TestMethods.CreateCallInfo();
				insert cinfo1;
				System.debug('cinfo1 callid : '+cinfo1.BR_Call_Id__c);
				testUser.Broker_Current_Call_Id__c = cinfo1.BR_Call_Id__c;
				update testUser; 
				cinfo1.BR_End_Date__c = System.now().addMinutes(1);
				update cinfo1;
                Test.stopTest();
            }
        }
        catch(Exception ex)
        {
              System.debug('Exception in Test Class: '+ex.getMessage());
        }
    }
}