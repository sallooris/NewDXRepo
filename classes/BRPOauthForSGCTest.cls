@isTest
public class BRPOauthForSGCTest{

    static testmethod void testGetHttpReqForCreateApplication () {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());     
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration;

        Test.startTest();    
        HttpRequest httpRequest = BRPOauthForSGC.GetHttpReqForCreateApplication ('OAuthToken', 'EIN','APPID');
        System.assertEquals(httpRequest.getHeader('apikey')+'','ABC');
        httpRequest = BRPOauthForSGC.GetHttpReqForUploadDocument('OAuthToken', 'EIN','APPID');
        System.assertEquals(httpRequest.getHeader('apikey')+'','ABC');
        String oauth = BRPOauthForSGC.GetOauthToken(); 
        System.assertEquals(oauth,'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkIyODZkaGtCRDFvcWQ0VFBYMTlzS015dlpXayIsImtpZCI6IkIyODZkaGtCRDFvcWQ0VFBYMTlzS015dlpXayJ9.eyJjbGllbnRfaWQiOiJlMGI5MDFjNTBjMGY0NGNjODcwNmFhZDVhOGEwY2YwNCIsInNjb3BlIjoicHVibGljIiwiaXNzIjoiaHR0cHM6Ly92YTEwbjUwODUwLnVzLmFkLndlbGxwb2ludC5jb20vc2VjdXJlYXV0aDMiLCJhdWQiOiJodHRwczovL3ZhMTBuNTA4NTAudXMuYWQud2VsbHBvaW50LmNvbS9zZWN1cmVhdXRoMyIsImV4cCI6MTQ3MzMwMTMwMiwibmJmIjoxNDczMzAwNDAwfQ.YeGhSygrj7fKVYjHTIaiHgsOCbG-d2Ej-X6INvVB-QhbDjiy_qdTlD2HX_w_YHvb_J9fwiwOj8mb1EDabDuXhfF5qykHSbGIk8OnVMxoZJPGug7tqRD_HKnNm13CUdGEY9SX-pR2eHqoBMOgxKizIfBhZACkZSu8uiGaSVoC6Aek1V8Gk4H0hUJM7SmRHiThMW2yhAIS71Y4mP6GSDYrgUJgu3HSuMX6DSzpupg8Uorh2qNza6FFVz7QBMgyXIuask0swcTvGc7vLqRMvtdTopldrJyQZRod395zOOh1ugtY-jhtm0F-U7InfI9bMJJCZ_7hDe9wNVc-82n_36HTuw');

        Test.stopTest();                  
    }
    
    static testmethod void testGetHttpReqForAppMemPayment () {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());     
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration;

        Test.startTest();    
        HttpRequest httpRequest = BRPOauthForSGC.GetHttpReqForAppMemPayment ('OAuthToken','EIN','APPID','CreateAppCensus');
        httpRequest = BRPOauthForSGC.GetHttpReqForAppMemPayment ('OAuthToken','EIN','APPID','UpdateAppCensus');        
        httpRequest = BRPOauthForSGC.GetHttpReqForAppMemPayment ('OAuthToken','EIN','APPID','CreateAppStatus');      
        httpRequest = BRPOauthForSGC.GetHttpReqForAppMemPayment ('OAuthToken','EIN','APPID','CreatePayment');       
        httpRequest = BRPOauthForSGC.GetHttpReqForUploadDocument('OAuthToken', 'EIN','APPID');
        String oauth = BRPOauthForSGC.GetOauthToken(); 
        System.assertEquals(oauth,'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkIyODZkaGtCRDFvcWQ0VFBYMTlzS015dlpXayIsImtpZCI6IkIyODZkaGtCRDFvcWQ0VFBYMTlzS015dlpXayJ9.eyJjbGllbnRfaWQiOiJlMGI5MDFjNTBjMGY0NGNjODcwNmFhZDVhOGEwY2YwNCIsInNjb3BlIjoicHVibGljIiwiaXNzIjoiaHR0cHM6Ly92YTEwbjUwODUwLnVzLmFkLndlbGxwb2ludC5jb20vc2VjdXJlYXV0aDMiLCJhdWQiOiJodHRwczovL3ZhMTBuNTA4NTAudXMuYWQud2VsbHBvaW50LmNvbS9zZWN1cmVhdXRoMyIsImV4cCI6MTQ3MzMwMTMwMiwibmJmIjoxNDczMzAwNDAwfQ.YeGhSygrj7fKVYjHTIaiHgsOCbG-d2Ej-X6INvVB-QhbDjiy_qdTlD2HX_w_YHvb_J9fwiwOj8mb1EDabDuXhfF5qykHSbGIk8OnVMxoZJPGug7tqRD_HKnNm13CUdGEY9SX-pR2eHqoBMOgxKizIfBhZACkZSu8uiGaSVoC6Aek1V8Gk4H0hUJM7SmRHiThMW2yhAIS71Y4mP6GSDYrgUJgu3HSuMX6DSzpupg8Uorh2qNza6FFVz7QBMgyXIuask0swcTvGc7vLqRMvtdTopldrJyQZRod395zOOh1ugtY-jhtm0F-U7InfI9bMJJCZ_7hDe9wNVc-82n_36HTuw');

        Test.stopTest();                  
    }
    
    static testmethod void testGetHttpReqForApplicationDocumentStatus () {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());     
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration;

        Test.startTest();    
        HttpRequest httpRequest = BRPOauthForSGC.GetHttpReqForApplicationDocumentStatus ('OAuthToken', 'EIN','APPID');
        System.assertEquals(httpRequest.getHeader('apikey')+'','ABC');
        httpRequest = BRPOauthForSGC.GetHttpReqForUploadDocument('OAuthToken', 'EIN','APPID');
        System.assertEquals(httpRequest.getHeader('apikey')+'','ABC');
        String oauth = BRPOauthForSGC.GetOauthToken(); 
        System.assertEquals(oauth,'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkIyODZkaGtCRDFvcWQ0VFBYMTlzS015dlpXayIsImtpZCI6IkIyODZkaGtCRDFvcWQ0VFBYMTlzS015dlpXayJ9.eyJjbGllbnRfaWQiOiJlMGI5MDFjNTBjMGY0NGNjODcwNmFhZDVhOGEwY2YwNCIsInNjb3BlIjoicHVibGljIiwiaXNzIjoiaHR0cHM6Ly92YTEwbjUwODUwLnVzLmFkLndlbGxwb2ludC5jb20vc2VjdXJlYXV0aDMiLCJhdWQiOiJodHRwczovL3ZhMTBuNTA4NTAudXMuYWQud2VsbHBvaW50LmNvbS9zZWN1cmVhdXRoMyIsImV4cCI6MTQ3MzMwMTMwMiwibmJmIjoxNDczMzAwNDAwfQ.YeGhSygrj7fKVYjHTIaiHgsOCbG-d2Ej-X6INvVB-QhbDjiy_qdTlD2HX_w_YHvb_J9fwiwOj8mb1EDabDuXhfF5qykHSbGIk8OnVMxoZJPGug7tqRD_HKnNm13CUdGEY9SX-pR2eHqoBMOgxKizIfBhZACkZSu8uiGaSVoC6Aek1V8Gk4H0hUJM7SmRHiThMW2yhAIS71Y4mP6GSDYrgUJgu3HSuMX6DSzpupg8Uorh2qNza6FFVz7QBMgyXIuask0swcTvGc7vLqRMvtdTopldrJyQZRod395zOOh1ugtY-jhtm0F-U7InfI9bMJJCZ_7hDe9wNVc-82n_36HTuw');

        Test.stopTest();                  
    }
    
    static testmethod void testGetHttpReqForApplicationStatus () {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());     
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration;

        Test.startTest();    
        HttpRequest httpRequest = BRPOauthForSGC.GetHttpReqForApplicationStatus ('OAuthToken', 'EIN','APPID');
        System.assertEquals(httpRequest.getHeader('apikey')+'','ABC');
        httpRequest = BRPOauthForSGC.GetHttpReqForUploadDocument('OAuthToken', 'EIN','APPID');
        System.assertEquals(httpRequest.getHeader('apikey')+'','ABC');
        String oauth = BRPOauthForSGC.GetOauthToken(); 
        System.assertEquals(oauth,'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkIyODZkaGtCRDFvcWQ0VFBYMTlzS015dlpXayIsImtpZCI6IkIyODZkaGtCRDFvcWQ0VFBYMTlzS015dlpXayJ9.eyJjbGllbnRfaWQiOiJlMGI5MDFjNTBjMGY0NGNjODcwNmFhZDVhOGEwY2YwNCIsInNjb3BlIjoicHVibGljIiwiaXNzIjoiaHR0cHM6Ly92YTEwbjUwODUwLnVzLmFkLndlbGxwb2ludC5jb20vc2VjdXJlYXV0aDMiLCJhdWQiOiJodHRwczovL3ZhMTBuNTA4NTAudXMuYWQud2VsbHBvaW50LmNvbS9zZWN1cmVhdXRoMyIsImV4cCI6MTQ3MzMwMTMwMiwibmJmIjoxNDczMzAwNDAwfQ.YeGhSygrj7fKVYjHTIaiHgsOCbG-d2Ej-X6INvVB-QhbDjiy_qdTlD2HX_w_YHvb_J9fwiwOj8mb1EDabDuXhfF5qykHSbGIk8OnVMxoZJPGug7tqRD_HKnNm13CUdGEY9SX-pR2eHqoBMOgxKizIfBhZACkZSu8uiGaSVoC6Aek1V8Gk4H0hUJM7SmRHiThMW2yhAIS71Y4mP6GSDYrgUJgu3HSuMX6DSzpupg8Uorh2qNza6FFVz7QBMgyXIuask0swcTvGc7vLqRMvtdTopldrJyQZRod395zOOh1ugtY-jhtm0F-U7InfI9bMJJCZ_7hDe9wNVc-82n_36HTuw');

        Test.stopTest();                  
    } 
     
     static testmethod void testGetHttpReqForCreateApplicationFromDB () {
       List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = BRPUtilTestMethods.createCS002Data();
        insert cs002List;
        Test.setMock(HttpCalloutMock.class, new BRPMockHttpResponseGenerator());     
        BRPSGCIntegration__c bRPSGCIntegration = BRPUtilTestMethods.createBRPSGCIntegration();
        insert  bRPSGCIntegration;
        OAuthRESTAPIToken__c oAuthObj = BRPUtilTestMethods.CreateAuth();
        insert oAuthObj;
        Test.startTest();   
        HttpRequest httpRequest = BRPOauthForSGC.GetHttpReqForCreateApplication ('OAuthToken', 'EIN','APPID');
        System.assertEquals(httpRequest.getHeader('apikey')+'','ABC');
        httpRequest = BRPOauthForSGC.GetHttpReqForUploadDocument('OAuthToken', 'EIN','APPID');
        System.assertEquals(httpRequest.getHeader('apikey')+'','ABC');
        String oauth = BRPOauthForSGC.GetOauthToken(); 
        System.assertEquals(oauth,'SOMEAUTH');
        BRPOauthForSGC.UpdateOAuthTable('SOMEAUTH');
        Test.stopTest();                  
    } 
    }