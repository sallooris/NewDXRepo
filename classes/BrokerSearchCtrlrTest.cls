@istest(seealldata=true)
public class BrokerSearchCtrlrTest {

    private static testmethod void testSearch()
    {
        BrokerSearchController gs = new BrokerSearchController();
 //       gs.accountNameSearch ='Test';
 //       gs.lastNameSearch = 'Test';
 //       gs.phoneSearch = '1234567890';
 //       gs.zipCodeSearch = '10001';
 //       gs.streetSearch = 'test';
 //       gs.citySearch = 'Califonia';
 //       gs.stateSearch = 'Texas';
//        gs.emailSearch = 'test@test.com';
        gs.employerTinSearch = '123456';
        gs.agencyTinSearch = '123456';
        gs.agentTinSearch = '123456';
        gs.writingAgentSearch = 'test';
        /*gs.firstNameSearch ='';
        lastNameSearch) && !HasValue(phoneSearch) && !HasValue(zipCodeSearch) && 
            (tsk.ActivityDate == null) && !HasValue(streetSearch) && !HasValue(citySearch) && !HasValue(stateSearch) && !HasValue(countySearch) 
            && !HasValue(RSVPSearch) && !HasValue(emailSearch) && !HasValue(SSNSearch) && !HasValue(HPHCSearch) 
            && !HasValue(employerTinSearch) && !HasValue(agencyTinSearch) && !HasValue(agentTinSearch) && !HasValue(writingAgentSearch)){
            showErrorMsg = true;
            showWarning = false;
*/
        gs.search();
    }
}