/************************************************************************
Class Name   : QueryUser_Test
Date Created : 15-June-2017
Created By   : IDC Offshore
Description  : 1. This is a test class for QueryUser
**************************************************************************/
@isTest
private class QueryUser_Test {
    private Static Final String staffMem_Constant = 'GetStaffMember';
    private Static Final String coverageBrokerDate_Constant = 'GetRequestCoverageBrokerDates';
    private Static Final String coverageNonBrokerDates_Constant = 'GetRequestCoverageNonBrokerDates';
    /************************************************************************************
    Method Name : getStaffMemberTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for getStaffMember
    *************************************************************************************/
    private static testMethod void getStaffMemberTest(){
        QueryUser qUser = new QueryUser();
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        String methodName = staffMem_Constant;
    	Test.startTest();
        qUser.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }
    /************************************************************************************
    Method Name : getRequestCoverageBrokerDatesTest
    Parameters  : None
    Return type : void
    Description : This is the testmethod for GetRequestCoverageBrokerDates
    *************************************************************************************/
    private static testMethod void getRequestCoverageBrokerDatesTest(){
        QueryUser qUser = new QueryUser();
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        String methodName = coverageBrokerDate_Constant;
        List<Broker_Date_Settings__c> brokerDatesCSList = Util02_TestData.createBrokerDatesCustomSettings();
        insert brokerDatesCSList;
    	Test.startTest();
        qUser.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }
    /************************************************************************************
    Method Name : getRequestCoverageNonBrokerDates
    Parameters  : None
    Return type : void
    Description : This is the testmethod for GetRequestCoverageNonBrokerDates method
    *************************************************************************************/
    private static testMethod void getRequestCoverageNonBrokerDates(){
        QueryUser qUser = new QueryUser();
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        String methodName = coverageNonBrokerDates_Constant;
        List<Broker_Date_Settings__c> brokerDatesCSList = Util02_TestData.createBrokerDatesCustomSettings();
        insert brokerDatesCSList;
    	Test.startTest();
        qUser.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }

}