/****************************************************
* Class Name : SessionId_Test
* Created date : Nov-13-2015
* Created by : Pointel
* Purpose : Test SessionId Class
****************************************************/
@isTest(SeeAllData=true) 
public class SessionId_test {
       static testMethod void Test(){
       Test.startTest();
       SessionId obj=new SessionId();
       system.debug('Session id = '+obj.GetSessionId());
       system.debug('Timezone = '+obj.GetTimeZone());
       Test.stopTest();
    }
}