/****************************************************************************
Class Name  :  QuoteCanvasExt_Test
Date Created:  20-April-2015
Created By  :  Arun/Daryl
Description :  This class will be used for testing the  QuoteCanvasExt 
Change History :    
****************************************************************************/
@isTest
public class QuoteCanvasExt_Test{
    
    static testmethod void testCanvasTest() {
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        QuoteCanvasExt_Test utilinsertObj = new QuoteCanvasExt_Test();
        Account testAccount = QuoteCanvasExt_Test.insertAccount();
        insert testAccount;
        Household_Member__c houseHold = QuoteCanvasExt_Test.insertHousehold(testAccount);
        insert houseHold;
        
        Test.setCurrentPageReference(new PageReference('Page.PTBIntegrationPilot'));        
        System.currentPageReference().getParameters().put('ParentId', testAccount.id);
        System.currentPageReference().getParameters().put('HouseholdMemberIds', houseHold.id);
        System.currentPageReference().getParameters().put('HouseholdMemberRoles','Applicant');
        ApexPages.StandardController sc = new ApexPages.standardController(testAccount);
        QuoteCanvasExt controller = new QuoteCanvasExt(sc);
        String retVal = controller.GetaccountJSON();
        System.debug(retVal);
        String assertVal = '{AccountId:\''+testAccount.Id+'\',HouseholdMemberIds:\''+houseHold.Id+'\',HouseholdMemberRoles:\'Applicant\'}';
        System.assertEquals(assertVal, retVal); 
        pagereference ref = controller.backMethod();
      }     
         public static Account insertAccount(){
              Account testAccount = new Account(firstname='test first name',lastname='test Last Name', Date_of_Birth__c=Date.ValueOf('1985-07-01'));
               testAccount.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Person%' ].id;
               return testAccount;
          }
          
    public static Household_Member__c insertHousehold(Account testAccount){           
        Household_Member__c hm = new Household_Member__c(First_Name__c='first',last_name__c='household',Household_ID__c=testAccount.id,date_of_birth__c=system.today(),relationship_type__c='Primary');              
        return hm;
    }

}