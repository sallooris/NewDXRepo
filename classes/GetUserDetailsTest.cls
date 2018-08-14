@isTest(seeAllData = true)
public class GetUserDetailsTest{

    public testmethod static void GetBrokerUserContactIdTestMethod(){

        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();

        Map<String,Object> Step = new Map<String,Object>();
        Map<String,Object> TypeAheadBroker = new Map<String,Object>();

        Contact BrokerTest = new Contact(LastName = 'Lockton', FirstName = 'Ronald', Email = 'ronlock@test.com');
        insert BrokerTest;

        User UserTest = new User(LastName = 'Lockton', FirstName = 'Ronald', IsActive = TRUE, Contact = BrokerTest, Email = 'ronlock@test.com', Alias = 'ronlock', CommunityNickname = 'ronlock', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US', Username = 'ronlock@test.com', ProfileId = [SELECT Id FROM Profile LIMIT 1].Id);
        insert UserTest;

        TypeAheadBroker.put('BrokerId', BrokerTest.Id);
        Step.put('TypeAheadBroker-Block', TypeAheadBroker);
        inputMap.put('Step', Step);
        inputMap.put('GeneralAgencyContactId', BrokerTest.Id);
        inputMap.put('PaidAgencyContactId', BrokerTest.Id);

        GetUserDetails obj = new GetUserDetails();
        obj.invokeMethod('getBrokerUserId', inputMap, outMap, options);
        obj.invokeMethod('getGeneralAgencyContactUserId', inputMap, outMap, options);
        obj.invokeMethod('getPaidAgencyContactUserId', inputMap, outMap, options);

    }
}