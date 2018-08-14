/*******************************************************************************************
* Class Name  : SGA_AP32_UpdateCaseStageTechFields_test
* Created By  : IDC Offshore
* CreatedDate : 8/4/2017
* Description : This test class for SGA_AP32_UpdateCaseStageTechFieldsOnAcc
********************************************************************************************/
@isTest
private class SGA_AP32_UpdateCaseStageTechFields_test {
    private static final String STATE_VALUE = 'CO';
    //private static final String STAGE_VALUE = 'Products Loaded';
    //private static final String STAGE_SC_VALUE = 'Scrub Completed';
    private static final String STAGE_VALUE = 'Vendor Return';
    private static final String STAGE_SC_VALUE = 'Payment Processed';
	private static final String STATE_VALUE_NY = 'NY';        
    /************************************************************************
    * Method Name : createAndUpdateCasePositiveTest
    * Description : To test the stage and state changes 
    * 				 and creation/updation of case
    ************************************************************************/
    private testMethod static void createAndUpdateCasePositiveTest(){
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        //Application record creation
        vlocity_ins__Application__c testApplication = Util02_TestData.createApplicationForRelatedList(SG01_Constants.STATUSINENROLLMENTCOMPLETED, System.today() +5);
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        System.runAs(testUser){
            Test.startTest();
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            Database.insert(testApplication);
            
            Case testCase0 = Util02_TestData.insertSGACase(testAccount.Id,testApplication.Id);
            Insert testCase0; 
            
            Account accountObj0 = [SELECT id, Tech_Case_Stage_Is_PL__c, Tech_Case_Stage_Is_SC__c FROM Account where id=:testAccount.Id];
            
            Case updateCase0 = [select id,status,stage__c from case where id=:testCase0.id];
            updateCase0.Stage__c = STAGE_VALUE;
            update updateCase0;
            
            //Account accountObj1 = [SELECT id, Tech_Case_Stage_Is_PL__c, Tech_Case_Stage_Is_SC__c FROM Account where id=:testAccount.Id];
            
            Case updateCase1 = [select id,status,stage__c from case where id=:testCase0.id];
            updateCase1.BR_State__c = STATE_VALUE;
            update updateCase1;
            
            //Account accountObj2 = [SELECT id, Tech_Case_Stage_Is_PL__c, Tech_Case_Stage_Is_SC__c FROM Account where id=:testAccount.Id];
            //Inserting new case with Poducts Loaded and State CO
            Case testCase1 = Util02_TestData.insertSGACase(testAccount.Id,testApplication.Id);
            testCase1.Stage__c = STAGE_VALUE;
            testCase1.BR_State__c = STATE_VALUE;
            Insert testCase1; 

            //Account accountObj3 = [SELECT id, Tech_Case_Stage_Is_PL__c, Tech_Case_Stage_Is_SC__c FROM Account where id=:testAccount.Id];
            
            //Inserting new case with Poducts Loaded and State NY
            Case testCase2 = Util02_TestData.insertSGACase(testAccount.Id,testApplication.Id);
            testCase2.Stage__c = STAGE_VALUE;
            Insert testCase2; 

            //Account accountObj4 = [SELECT id, Tech_Case_Stage_Is_PL__c, Tech_Case_Stage_Is_SC__c FROM Account where id=:testAccount.Id];
            
            Case updateCase3 = [select id,status,stage__c from case where id=:testCase2.id];
            updateCase3.Stage__c = STAGE_SC_VALUE;
            updateCase3.BR_State__c = STATE_VALUE_NY;
            update updateCase3;
            
            //Account accountObj5 = [SELECT id, Tech_Case_Stage_Is_PL__c, Tech_Case_Stage_Is_SC__c FROM Account where id=:testAccount.Id];
            Test.stopTest();
            
        }
    }
}