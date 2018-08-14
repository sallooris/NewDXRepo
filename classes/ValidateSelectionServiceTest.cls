@isTest(seeAllData = false)
public class ValidateSelectionServiceTest{
    public testmethod static void ValidateSelectionServiceTestMethod(){

      Map<String,Object> MedicalinputMap = new Map<String,Object>();
      Map<String,Object> DentalinputMap = new Map<String,Object>();
      Map<String,Object> VisioninputMap = new Map<String,Object>();
      Map<String,Object> outMap = new Map<String,Object>();
      Map<String,Object> options = new Map<String,Object>();
      Map<String,Object> SelectMedicalinputMap = new Map<String,Object>();
      Map<String,Object> SelectedMedicalinputMap = new Map<String,Object>();
      Map<String,Object> SelectDentalinputMap = new Map<String,Object>();
      Map<String,Object> SelectVisioninputMap = new Map<String,Object>();
      Map<String,Object> ZipCodeinputMap = new Map<String,Object>();
      Map<String,Object> DuplicateAccountinputMap = new Map<String,Object>();
      Map<String,Object> MedicalEmptyinputMap = new Map<String,Object>();
      Map<String,Object> DentalEmptyinputMap = new Map<String,Object>();
      Map<String,Object> VisionEmptyinputMap = new Map<String,Object>();
      Map<String,Object> SelectMedicalEmptyinputMap = new Map<String,Object>();
      Map<String,Object> SelectDentalEmptyinputMap = new Map<String,Object>();
      Map<String,Object> SelectVisionEmptyinputMap = new Map<String,Object>();

      Product2 prod = new Product2(Name = 'Test Product');
      List<Product2> MedicalAccounts =  new List<Product2>();
      List<Product2> DentalAccounts =  new List<Product2>();
      List<Product2> VisionAccounts =  new List<Product2>();

      List<Product2> EmptyAccounts =  null;
      Boolean Rider29Prod = true;

      Map<String,Object> MedicalCoverage = new Map<String,Object>();
      Map<String,Object> DentalCoverage = new Map<String,Object>();
      Map<String,Object> VisionCoverage = new Map<String,Object>();
      Map<String,Object> SelectMedicalCoverage = new Map<String,Object>();
      Map<String,Object> SelectedMedicalCoverage = new Map<String,Object>();
      Map<String,Object> SelectDentalCoverage = new Map<String,Object>();
      Map<String,Object> SelectVisionCoverage = new Map<String,Object>();
      Map<String,Object> MedicalEmptyCoverage = new Map<String,Object>();
      Map<String,Object> DentalEmptyCoverage = new Map<String,Object>();
      Map<String,Object> VisionEmptyCoverage = new Map<String,Object>();
      Map<String,Object> SelectMedicalEmptyCoverage = new Map<String,Object>();
      Map<String,Object> SelectDentalEmptyCoverage = new Map<String,Object>();
      Map<String,Object> SelectVisionEmptyCoverage = new Map<String,Object>();

      MedicalAccounts.add(prod);
      MedicalAccounts.add(prod);
      MedicalAccounts.add(prod);
      MedicalAccounts.add(prod);
      MedicalCoverage.put('MedicalAccounts', MedicalAccounts);
      MedicalinputMap.put('MedicalCoverage', MedicalCoverage);
      SelectMedicalCoverage.put('output2', MedicalAccounts);
      SelectedMedicalCoverage.put('isConflictRider29Plans', Rider29Prod);
      SelectedMedicalinputMap.put('SelectMedicalCoverage', SelectedMedicalCoverage);
      SelectMedicalinputMap.put('SelectMedicalCoverage', SelectMedicalCoverage);
      MedicalEmptyCoverage.put('MedicalAccounts', EmptyAccounts);
      MedicalEmptyinputMap.put('MedicalCoverage', MedicalEmptyCoverage);
      SelectMedicalEmptyCoverage.put('output2', EmptyAccounts);
      SelectMedicalEmptyinputMap.put('SelectMedicalCoverage', SelectMedicalEmptyCoverage);

      DentalAccounts.add(prod);
      DentalAccounts.add(prod);
      DentalAccounts.add(prod);
      DentalCoverage.put('DentalAccounts', DentalAccounts);
      DentalinputMap.put('DentalCoverage', DentalCoverage);
      SelectDentalCoverage.put('output3', DentalAccounts);
      SelectDentalinputMap.put('SelectDentalPlans', SelectDentalCoverage);
      DentalEmptyCoverage.put('DentalAccounts', EmptyAccounts);
      DentalEmptyinputMap.put('DentalCoverage', DentalEmptyCoverage);
      SelectDentalEmptyCoverage.put('output3', EmptyAccounts);
      SelectDentalEmptyinputMap.put('SelectDentalPlans', SelectDentalEmptyCoverage);

      VisionAccounts.add(prod);
      VisionAccounts.add(prod);
      VisionCoverage.put('VisionAccounts', VisionAccounts);
      VisioninputMap.put('VisionCoverage', VisionCoverage);
      SelectVisionCoverage.put('output4', VisionAccounts);
      SelectVisioninputMap.put('SelectVisionPlans', SelectVisionCoverage);
      VisionEmptyCoverage.put('VisionAccounts', EmptyAccounts);
      VisionEmptyinputMap.put('VisionCoverage', VisionEmptyCoverage);
      SelectVisionEmptyCoverage.put('output4', EmptyAccounts);
      SelectVisionEmptyinputMap.put('SelectVisionPlans', SelectVisionEmptyCoverage);

      Map<String,Object> Step = new Map<String,Object>();
      Integer CheckZipCode = 2;
      Step.put('CheckZipCode', CheckZipCode);
      ZipCodeinputMap.put('Step', Step);

      test.startTest();
          ValidateSelectionService vss = new ValidateSelectionService();

          Boolean validateMedical = vss.invokeMethod('validateMedical', MedicalinputMap, outMap, options);
          System.assertEquals(validateMedical, true);

          Boolean validateSelectedMedical = vss.invokeMethod('validateSelectedMedical', MedicalinputMap, outMap, options);
          System.assertEquals(validateSelectedMedical, true);

          Boolean validateSelectedMedicalRider = vss.invokeMethod('validateSelectedMedical', SelectedMedicalinputMap, outMap, options);
          System.assertEquals(validateSelectedMedicalRider, true);

          Boolean validateDental = vss.invokeMethod('validateDental', DentalinputMap, outMap, options);
          System.assertEquals(validateDental, true);

          Boolean validateVision = vss.invokeMethod('validateVision', VisioninputMap, outMap, options);
          System.assertEquals(validateVision, true);

          Boolean validateQuoteMedical = vss.invokeMethod('validateQuoteMedical', SelectMedicalinputMap, outMap, options);
          System.assertEquals(validateQuoteMedical, true);

          Boolean validateQuoteDental = vss.invokeMethod('validateQuoteDental', SelectDentalinputMap, outMap, options);
          System.assertEquals(validateQuoteDental, true);

          Boolean validateQuoteVision = vss.invokeMethod('validateQuoteVision', SelectVisioninputMap, outMap, options);
          System.assertEquals(validateQuoteVision, true);

          Boolean validateZipCode = vss.invokeMethod('validateZipCode', ZipCodeinputMap, outMap, options);
          System.assertEquals(validateZipCode, true);

          Boolean validateMedicalEmpty = vss.invokeMethod('validateMedical', MedicalEmptyinputMap, outMap, options);
          System.assertEquals(validateMedicalEmpty, true);

          Boolean validateDentalEmpty = vss.invokeMethod('validateDental', DentalEmptyinputMap, outMap, options);
          System.assertEquals(validateDentalEmpty, true);

          Boolean validateVisionEmpty = vss.invokeMethod('validateVision', VisionEmptyinputMap, outMap, options);
          System.assertEquals(validateVisionEmpty, true);

          Boolean validateQuoteMedicalEmpty = vss.invokeMethod('validateQuoteMedical', SelectMedicalEmptyinputMap, outMap, options);
          System.assertEquals(validateQuoteMedicalEmpty, true);

          Boolean validateQuoteDentalEmpty = vss.invokeMethod('validateQuoteDental', SelectDentalEmptyinputMap, outMap, options);
          System.assertEquals(validateQuoteDentalEmpty, true);

          Boolean validateQuoteVisionEmpty = vss.invokeMethod('validateQuoteVision', SelectVisionEmptyinputMap, outMap, options);
          System.assertEquals(validateQuoteVisionEmpty, true);

      test.stopTest();
    }
    
    public testmethod static void duplicateAccountTest(){
       User u = Util02_TestData.createUser();
        system.runAs(u){
            List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
            insert cs001List; 
            List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
            insert cs002List;
            Id grpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            Account a = new Account(Name='Test Account Name');
            a.RecordTypeId = grpRecordTypeId; 
            insert a;
            
            Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id);
            insert c;
            
            User user = new User();
            user.ProfileID = [Select Id From Profile Where Name='Anthem SG Broker'].id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'first';
            user.LastName = 'last';
            user.Username = 'test@testssss.com';   
            user.CommunityNickname = 'testUser123';
            user.Alias = 't1';
            user.Email = 'no@email.com';
            user.IsActive = true;
            user.ContactId = c.Id;
            
            insert user;
            
            Account acc = Util02_TestData.createGroupAccount();
            Insert acc;
            AccountTeamMember actTeam = new AccountTeamMember(AccountId=acc.Id,TeamMemberRole = 'Broker',UserId=user.Id);
            Insert actTeam;
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            Map<String,Object> ZipCodeinputMap = new Map<String,Object>();
            Map<String,Object> TypeAheadBrokerBlock = new Map<String,Object>();
            Map<String,Object> Step = new Map<String,Object>();
            TypeAheadBrokerBlock.put('BrokerId', user.ContactId);
            Step.put('TypeAheadBroker-Block', TypeAheadBrokerBlock);
            Step.put('TaxID', '345234123');
            Integer CheckZipCode = 1;
            Step.put('CheckZipCode', CheckZipCode);
            ZipCodeinputMap.put('Step', Step);
            
            test.startTest();
            ValidateSelectionService vss = new ValidateSelectionService();
            Boolean validateZipCode = vss.invokeMethod('validateZipCode', ZipCodeinputMap, outMap, options);
            System.assertEquals(validateZipCode, true);
            test.stopTest();
        }
        
    }
}