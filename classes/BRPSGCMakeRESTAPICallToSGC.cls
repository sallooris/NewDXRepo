public with sharing class BRPSGCMakeRESTAPICallToSGC
{	
	public static String OauthId = '';
    private static String getGroupNumber = 'OBTAIN GROUP NUMBER';	    
		
	public class ValidationErrors {
		public String fieldName{get;set;}
		public String validationErrorMessage{get;set;}
	}
					   	
	public class cls_exceptions {
		public String type{get;set;}
		public String code{get;set;}
		public String message{get;set;}
		public String detail{get;set;}
	}

	public class ParseJSON {
		public List<ValidationErrors> validationErrors{get;set;}
		public String currentDateTime{get;set;}
	}
	
	public class ExceptionJSON{
		public cls_exceptions[] exceptions{get;set;}
	}	

	public static ParseJSON parse(String json) {
		return (ParseJSON) System.JSON.deserialize(json, ParseJSON.class);
	}
		
	public static ExceptionJSON parseException(String json){
		return (exceptionJSON) System.JSON.deserialize(json, exceptionJSON.class);
	}
	
    public Boolean CreateApplicationStatusCensusInSGC(String EIN, String appId, String reqJSON, String appIdForSGC)
    {
    	BRPSGCMakeRESTAPICallToSGC.MakeSGCRESTAPICall(EIN, appId, null, reqJSON, 'CreateAppStatus', appIdForSGC, null); //POST
    	return true;
    }
      
    public Boolean CreateApplicationCensusInSGC(String EIN, String appId, String reqJSON, String appIdForSGC, String appStatusJSON)
    {
    	BRPSGCMakeRESTAPICallToSGC.MakeSGCRESTAPICall(EIN, appId, null, reqJSON, 'CreateAppCensus', appIdForSGC, appStatusJSON); //POST
    	return true;
    }
    
    public Boolean UpdateApplicationCensusInSGC(String EIN, String appId, String reqJSON, String appIdForSGC, String caseId)
    {
    	BRPSGCMakeRESTAPICallToSGC.MakeSGCRESTAPICall(EIN, appId, caseId, reqJSON,'UpdateAppCensus', appIdForSGC, null); //PUT
    	return true;
    }

    //Not Used Yet
    public Boolean CreatePaymentInSGC(String EIN, String appId, String reqJSON, String appIdForSGC)
    {
    	BRPSGCMakeRESTAPICallToSGC.MakeSGCRESTAPICall(EIN, appId, null, reqJSON, 'CreatePayment', appIdForSGC, null); //POST
    	return true;
    }
    /////////////
           
    @future(callout=true)
    public static void MakeSGCRESTAPICall(String EIN, String appId, String caseId, String reqMsg, String reqType, String appIdForSGC, String appStatusJSON)
    {
    	//Obtain Group number flag
    	boolean obtainGrpNum = false;

        //Request Status Message    	
    	String msgStatus;
        String msgStatus1;   	
    	
    	//Retrieve oAuth details
    	if (!Test.isRunningTest())
    	{
            OauthId = BRPOauthForSGC.GetOauthToken();
    	}           
    	else
    	{
    		OauthId = 'test';
    	}
     	
        //Instaniate MakeRestCallToSGC class
        BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC();
        
        System.debug('INTEGRATION TESTING FUTURE ******************************PARAMS:appId - ' + appId);
        System.debug('INTEGRATION TESTING FUTURE ******************************PARAMS:caseId - ' + caseId);  
        System.debug('INTEGRATION TESTING FUTURE ******************************PARAMS:appIdForSGC - ' + appIdForSGC);  
        System.debug('INTEGRATION TESTING FUTURE ******************************PARAMS:einForSGC - ' + EIN);
        System.debug('INTEGRATION TESTING FUTURE ******************************PARAMS:reqType - ' + reqType);
        System.debug('INTEGRATION TESTING FUTURE ******************************PARAMS:reqMsg - ' + reqMsg);
        System.debug('INTEGRATION TESTING FUTURE ******************************PARAMS:appStatusJSON - ' + appStatusJSON);    
     	System.debug('INTEGRATION TESTING FUTURE ******************************OauthId - ' + OauthId);
        
        //Checking for ObtainGroupNumber
        if (reqMsg != null && reqMsg.containsIgnoreCase(getGroupNumber))
            obtainGrpNum = true;	          	       
           
        //Create HttpRequest
        HttpRequest req = new HttpRequest();

        //Set Header & URL Detail
   		req = BRPOauthForSGC.GetHttpReqForAppMemPayment(OauthId, EIN, appIdForSGC, reqType);
                    
        //Set Request Body 
        req.setBody(reqMsg);
        
        //Create Http object
        Http ht = new Http();
                
        //Create HttpResponse
        HttpResponse response = new HttpResponse();
        
        //Not a Test
        if(!Test.isRunningTest())
        {   
        	//Submit request to SGC
            response = ht.send(req);
        }
        else
        {
        	//Set Test Response
        	if (reqType == 'CreateAppStatus')
        	{
                response.setHeader('Content-Type', 'application/json'); response.setBody('{"uploadDocumentResponse":{"sgcTransId":"57d218015629e72c1395b826"}}'); response.setStatusCode(200);
        	}
            else if (reqType == 'CreateAppCensus' && String.isEmpty(appStatusJSON))
                 {
                     response.setHeader('Content-Type', 'application/json'); response.setBody('{"validationErrors": [{"fieldName": "groupName", "validationErrorMessage": "groupName empty", "detail": ""},{"fieldName": "sicCode", "validationErrorMessage": "sicCode empty"}], "currentDateTime": "10/31/20017 10:32:10"}'); response.setStatusCode(401);
                 }    
                 else if (reqType == 'CreateAppCensus' && !String.isEmpty(appStatusJSON))
                      {
                          response.setHeader('Content-Type', 'application/json'); response.setBody('{"applicationDataResponse":{"sgcTransId":"5a0616e0b38d78eaa2f50bea"}}'); response.setStatusCode(200);
                      }    
                      else if (reqType == 'UpdateAppCensus')
                           {    
                               response.setHeader('Content-Type', 'application/json'); response.setBody('{"exceptions": [{"type": "W",     "code": "groupName", "message": "groupName empty", "detail": ""},{"type": "W", "code": "sicCode", "message": "sicCode empty", "detail": ""}]}'); response.setStatusCode(404);
                               obtainGrpNum = true;                                
                           }
        }        
     
        //Determine Response Msg
       	msgStatus = DetermineMessageStatus(response, reqType);
        
        //Create Application Census completion dependency for all Create Application Status updates                  
        if (reqType == 'CreateAppCensus' && !String.isEmpty(appStatusJSON))
        {       	
            ht = new Http();

            response = new HttpResponse();

            req = BRPOauthForSGC.GetHttpReqForAppMemPayment(OauthId, EIN, appIdForSGC, 'CreateAppStatus');

            req.setBody(appStatusJSON);
            
            //Not a Test
            if(!Test.isRunningTest())
            {   
        	   //Submit request to SGC
               response = ht.send(req);
            }        	
            else
            {
               //Set Test Response
               response.setHeader('Content-Type', 'application/json'); response.setBody('{"uploadDocumentResponse":{"sgcTransId":"57d218015629e72c1395b826"}}'); response.setStatusCode(200);            	
            }

            //Determine Response Msg
        	msgStatus1 = DetermineMessageStatus(response, 'CreateAppStatus');                   	
        }
        
        //If Obtain Group Number, update Case with Status        
        if (obtainGrpNum && reqType == 'UpdateAppCensus')
        {
        	if (!String.isEmpty(caseId))
        	{
        	    UpdateCase(caseId, msgStatus);
        	}
        }
        else
        {
            UpdateApplication(appId, reqType, msgStatus, msgStatus1);
        }

        if(BRPOauthForSGC.QueryOAuthTable() != null)
        { 
        	BRPOauthForSGC.UpdateOAuthTable(OauthId);
        }  
    }    

    public static String DetermineMessageStatus(HttpResponse response, String reqType)
    {
        System.debug('INTEGRATION TESTING FUTURE ******************************HTTP SGC RESPONSE - '+ response.getBody());
     
        String statusMsg;
        
        try
        {           
	        if(response.getStatusCode() == 200)
	        {
	           String sgcTransId = (response.getBody()).substringBetween('"sgcTransId":"','"}}');
	           System.debug('INTEGRATION TESTING FUTURE ******************************SGC TRANSACTION ID - ' + sgcTransId);
	        	
	           if(reqType == 'CreateAppCensus')
	           {        		
	              if (sgcTransId != null)
	              {
	                  statusMsg  = '\n' + DateTime.now() + ' : SUCCESS - SGC ID : ' + sgcTransId;
	              } 
	              else if ((response.getBody()).containsIgnoreCase('already loaded'))
	                   {
	               	       statusMsg  = '\n' + DateTime.now() + ' : SUCCESS - SGC ID : ALREADY LOADED';
	                   } 
	                   else
	                   {
	                       statusMsg  = '\n' + DateTime.now() + ' : FAILED - ' + response.getBody();
	                   }                                      
	           }
	           else
	           {
		           if (sgcTransId != null)
		           {
		               statusMsg =  '\n' + DateTime.now() + ' : SUCCESS - Request Type: '+ reqType + ', SGC Trans Id - ' + sgcTransId;
		           } 
		           else
		           {
		               statusMsg = '\n' + DateTime.now() + ' : SUCCESS - Request Type: '+ reqType + ', NO SGC Trans Id';
		           }	             	           
	           }                                   	 
	        }
	        else
	        {       	
	           if ((response.getBody()).containsIgnoreCase('already loaded') && reqType == 'CreateAppCensus')
	           {
	        	   statusMsg = '\n' + DateTime.now() + ' : SUCCESS - SGC ID : ALREADY LOADED';
		       } 
	           else        	
	           {               
	    		   if ((response.getBody()).containsIgnoreCase('"exceptions":'))
	    		   {    		   	   
	        		   ExceptionJSON obj = parseException(response.getBody());        		
	        		   String valMsg = '';
	        		
	        		   for (cls_exceptions ve : obj.exceptions)
	        		   { 
	        			    if (valMsg == '')
	        				{
	        			   	    valMsg = 'Exception: Code - ' + ve.code + ', Message - ' + ve.message;	
	        				}   
	        				else
	        				{
	        				    valMsg = valMsg + ', Code - ' + ve.code + ', Message - ' + ve.message;
	        				}   
	        			  			
	        				System.debug('INTEGRATION TESTING FAILED ******************************Code - ' + ve.code); 	
	        				System.debug('INTEGRATION TESTING FAILED ******************************Message - ' + ve.message); 
	        		   }
	        				
	        		   statusMsg =  '\n' + DateTime.now() + ': FAILED - REQUEST TYPE: ' + reqType + ', ' + valMsg;
	    		   }        				 	        				
	    		   else
	    		   {
	        		   ParseJSON obj = parse(response.getBody());        		
	        		   String valMsg = '';
	        		
	        		   for (ValidationErrors ve : obj.validationErrors)
	        		   { 
	        			    if (valMsg == '')
	        				{
	        			   		valMsg = 'Exception: FieldName - ' + ve.fieldName + ', Message - ' + ve.validationErrorMessage;	
	        				}   
	        				else
	        				{
	        					valMsg = valMsg + ', FieldName - ' + ve.fieldName + ', Message - ' + ve.validationErrorMessage;
	        				}   
	        			  			
	        				System.debug('INTEGRATION TESTING FAILED ******************************Field Name - ' + ve.fieldName); 	
	        				System.debug('INTEGRATION TESTING FAILED ******************************Validation Msg - ' + ve.validationErrorMessage); 
	        		   }
	        				
	        		   statusMsg =  '\n' + DateTime.now() + ': FAILED - REQUEST TYPE: ' + reqType + ', ' + valMsg;
	    		   }
	           }        	
	        }
        }
        catch(Exception e)
        {
            System.Debug('Error occurred in BRPSGCMakeRESTAPICallToSGC - DetermineMessageStatus : ' + e.getMessage());
            statusMsg = '\n' + DateTime.now() + ' : FAILED (Parse Exception) - ' + response.getBody();
        }                
        
        System.debug('INTEGRATION TESTING FUTURE ******************************STATUS MESSAGE - ' + statusMsg);            
        return statusMsg;  
    }   
     
    public static void UpdateApplication(String applicationId, String reqType, String statusMsg, String statusMsg1)
    {
        vlocity_ins__Application__c appl = [SELECT 
            SGC_Application_Status__c, 
            SGC_Document_Status__c,
            SGC_Status__c,
            Id 
        FROM vlocity_ins__Application__c  
        WHERE Id =:applicationId LIMIT 1  for update];
               
        if (reqType == 'CreateAppCensus')
        {
            appl.SGC_Application_Status__c= statusMsg;
            
            if (statusMsg1 != null)
            {
	            if (appl.SGC_Document_Status__c != null)
	                appl.SGC_Document_Status__c = appl.SGC_Document_Status__c + ', ' + statusMsg1;
	            else 
	                appl.SGC_Document_Status__c = statusMsg1;            	
            }
        }
        else
        {   
            if (appl.SGC_Document_Status__c != null)
                appl.SGC_Document_Status__c = appl.SGC_Document_Status__c + ', ' + statusMsg;
            else 
                appl.SGC_Document_Status__c = statusMsg;
        }
        
        System.debug('INTEGRATION TESTING APPLICATION OBJECT ******************************'+ appl);
         
        update appl;                    
    }

    public static void UpdateCase(String caseId, String statusMsg)
    {
        //Update Case by Id 
        Case caseObj = [SELECT id, OriginalDescription__c FROM Case WHERE Id =: caseId for update];
                
        caseObj.OriginalDescription__c = statusMsg;

        System.debug('INTEGRATION TESTING CASE OBJECT ******************************'+ caseObj);
         
        update caseObj;                    
    }  
}