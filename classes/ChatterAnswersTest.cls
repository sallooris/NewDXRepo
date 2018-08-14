@isTest
    public class ChatterAnswersTest {
        public static TestMethod String createAccountTest()
            {
                List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
                insert cs001List; 
                List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
                insert cs002List;
                Account a = new Account(name = 'Test Account' , ownerId = UserInfo.getUserId());
                a.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Business%' LIMIT 1].id;
                insert a;
                
                 String firstname = 'FirstName'; 
                 String lastname = 'LastName'; 
                 Id siteAdminId = UserInfo.getUserId();
                 
                 ChatterAnswers s = new ChatterAnswers();
                 s.createAccount(firstname,lastname,siteAdminId );


                 return a.id ;
            }
}