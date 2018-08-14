/**
* JIRA - SFOA-497: Start the Enrollment Process - Build a process to trigger the REST API Client when Application gets submitted
* BRPSGCGetGroupDocumentsStatus Class is used to get the overall application ststus from SG Container by making REST API Calls
* @Date: 7/15/2016
* @Author: Daryl Coutinho
* 
*/

public with sharing class BRPSGCGetGroupDocumentsStatus
{
    public void getApplicationDocStatusFromSGC(String AppId)
    {
        appId = AppId;
        System.debug('inside getDocStatus - app Id = '+appId);
        String respMsg = '';
        String respdata = '{"documentStatusResponse":{"sgcDocStatus":"Partial Received"}}';
        String status;
        String statusMsg = ' ';
        String errresp = '{"exceptions": {"exceptions": {"exception":[ {"type": "system", "code": "1001", "message": "invalid Acc Id", "detail": "Account not found"}]}} }';
        try
        {            
            vlocity_ins__Application__c vloApp = [select SGC_Application_Status__c, Application_Number__c, vlocity_ins__PrimaryPartyId__c, Account_Employer_EIN__c, Account_Name__c, Account_State__c, Paid_Agency_ETIN__c, Parent_Agency_ETIN__c, WritingAgentETIN__c, Specialty_Indicator__c, Group_Coverage_Date__c, Member_Count__c, vlocity_ins__JSONData__c, vlocity_ins__PrimaryApplicantLink__c, vlocity_ins__ApplicationReferenceNumber__c, vlocity_ins__Status__c, vlocity_ins__Summary__c, vlocity_ins__Type__c, vlocity_ins__OwnerLink__c from vlocity_ins__Application__c where Id=:AppId LIMIT 1];
            String appIdForSGC = AppId;
            appIdForSGC = appIdForSGC.substring(appIdForSGC.length()-9);        
            if((vloApp.Application_Number__c+'').length() > 5)
                appIdForSGC = vloApp.Application_Number__c+'ZZZ';  
            String ein = vloApp.Account_Employer_EIN__c;           
            String OauthId = BRPOauthForSGC.GetOauthToken();            
            HttpRequest httpReq = BRPOauthForSGC.GetHttpReqForApplicationStatus(OauthId,ein, appIdForSGC);
            System.debug('INTEGRATION getDocStatus******************************PARAMS:HttpReqMsg - '+ httpReq );
            System.debug('INTEGRATION getDocStatus******************************PARAMS:appId - '+ vloApp.Id);
            System.debug('INTEGRATION getDocStatus******************************PARAMS:EIN - '+ vloApp.Account_Employer_EIN__c);
            System.debug('INTEGRATION getDocStatus******************************Application_Number__c- '+ vloApp.Application_Number__c);
            HttpResponse response = invokeRestSvc(httpReq);
            if((response.getStatusCode() == 200)){           
                    status = (response.getBody()).substringBetween('sgcDocStatus":"','"}}'); 
                    statusMsg =  '\n'+DateTime.now()+':APPLICATION STATUS IN SGC : '+ (response.getBody()).substringBetween('sgcDocStatus":"','"}}');
                    if(status == null)
                        statusMsg=  '\n'+DateTime.now()+': EXCEPTION IN GETTING APPLICATION STATUS: Message - '+(response.getBody()).substringBetween('"message":"','","detail"')+', Details - '+(response.getBody()).substringBetween('","detail":"','"}');
            } else  {
                statusMsg=  '\n'+DateTime.now()+': EXCEPTION IN GETTING APPLICATION STATUS: Message - '+(response.getBody()).substringBetween('"message":"','","detail"')+', Details - '+(response.getBody()).substringBetween('","detail":"','"}');
                }
            vloApp.SGC_Application_Status__c =   vloApp.SGC_Application_Status__c + statusMsg; 
            System.debug('INTEGRATION TESTING ******************************HTTP statusMsg- '+ statusMsg);
            System.debug('INTEGRATION TESTING ******************************HTTP status - '+ status );
            System.debug('INTEGRATION TESTING  ******************************HTTP RESPONSE - '+ response.getBody());
            System.debug('INTEGRATION TESTING  ******************************SGC_Application_Status__c  - '+ vloApp.SGC_Application_Status__c);
            update vloApp;
        }
        catch(Exception e)
        {
            System.debug('Error invoking Web Service getDocStatus: '+e.getMessage());
        }
    }
 
    
    public HttpResponse invokeRestSvc(HttpRequest httpReq)
    {
        System.debug('inside invokeRestSvc');
        Http ht = new Http();
        HttpResponse resp = new HttpResponse();
        try
        {
            resp = ht.send(httpReq);
        }
        catch(system.CalloutException e)
        {
            System.debug('Error in function invokeRestSvc: '+e.getMessage());
        }
        return resp; 
    }
}