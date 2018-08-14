public with sharing class BRPSGCUpdateGroupStatusSupporting {
    
    public class GroupStatusRequest {
        public String appId{get;set;} //Required
        public String ein{get;set;} //Required
        public String appnStatus{get;set;}
        public String caseNumber{get;set;} //Group# ISG Group Shell creation.
        public String acn{get;set;}
        public String caseStage{get;set;}//Required
        public String notes{get;set;}
        public String statusUpdateTmstamp{get;set;}
    }

    public BRPSGCUpdateGroupStatus.GroupStatusResponse UpdateGroupStatus(GroupStatusRequest request)
    {
        BRPSGCUpdateGroupStatus.GroupStatusResponse response = new BRPSGCUpdateGroupStatus.GroupStatusResponse();
               
        //Mandatory fields check
        if(!String.isBlank(request.appId) && !String.isBlank(request.ein) && !String.isBlank(request.caseStage))
        {           
           //Update vlocity_ins_Application__c.vlocity_ins__Status__c
           String status = UpdateApplication(request);
                    
           if (status == 'SUCCESS')
           {
               //Successfully Updated Group/Application Status                       
               response.code = '200';
               response.message = 'SUCCESS';                              
           }
           else
           {
               //Unsuccessfully updated Group/Application Status
               if(!Test.isRunningTest())
               {                  
	               RestContext.response.statusCode = 400;
               }
               
               response.code = '400';
               response.message = 'FAILED';
               response.detail = status;
           }
        }
        else 
        {
            if(!Test.isRunningTest())
            {                  
	           RestContext.response.statusCode = 400;
            }
            
            response.code = '400';
            response.message = 'FAILED';
            response.detail = 'Missing mandatory data fields. Please try again.';
        }
 
        return response;
    }      
     
    public GroupStatusRequest GetGroupStatusRequest(JSONParser parser)
    {
        GroupStatusRequest request = new GroupStatusRequest();
               
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) 
            {       
            
                //Mandatory field, Lookup vlocity_ins_Application__c.Application_Number__c
                if (parser.getText() == 'appId') 
                {                   
                   parser.nextToken();
                   System.debug('parser value: ' + parser.getText());
                   request.appId = (parser.getText() != 'null' ? parser.getText() : '');
                }
                
                //Mandatory Field, lookup vlocity_ins_Application__c.EIN__c
                if (parser.getText() == 'ein') 
                {                   
                   parser.nextToken();
                   request.ein = (parser.getText() != 'null' ? parser.getText() : '');
                }
                
                //Mandatory Field, Update vlocity_ins_Application__c.vlocity_ins__Status__c
                if (parser.getText() == 'caseStage') 
                {                   
                   parser.nextToken();
                   request.caseStage = (parser.getText() != 'null' ? parser.getText() : '');
                }
                     
                //Remaining fields are Optional
                if (parser.getText() == 'appnStatus') 
                {                   
                   parser.nextToken();
                   request.appnStatus = (parser.getText() != 'null' ? parser.getText() : '');
                }
                
                if (parser.getText() == 'caseNumber') 
                {                   
                   parser.nextToken();
                   request.caseNumber = (parser.getText() != 'null' ? parser.getText() : '');
                }

                //Optional Field, Update/Append vlocity_ins_Application__c.?__c  
                if (parser.getText() == 'acn') 
                {                   
                   parser.nextToken();
                   request.acn = (parser.getText() != 'null' ? parser.getText() : '');
                }
                
                //Optional Field, Update/Append vlocity_ins_Application__c.?__c  
                if (parser.getText() == 'notes') 
                {                   
                   parser.nextToken();
                   request.notes = (parser.getText() != 'null' ? parser.getText() : '');
                }

                if (parser.getText() == 'statusUpdateTmstamp') 
                {                   
                   parser.nextToken();
                   request.statusUpdateTmstamp = (parser.getText() != 'null' ? parser.getText() : '');
                }
            }
        }   
            
        return request;
    }
    
    public static String UpdateApplication(GroupStatusRequest request)
    {
        String appId = request.appId;
        String notes = request.notes;
        String status = 'SUCCESS';
        String appStatus = request.appnStatus;
        
        //Determine AppId for lookup
        if (appId.contains('ZZZ'))
        {
            Integer idxOf = appId.indexOf('ZZZ');

            System.debug('idxOf: ' + idxOf);            
            System.debug('Substring: ' + appId.subString(0,idxOf));
            
            appId = appId.subString(0,idxOf);           
        }
        
        //Determine Application Status
        if (String.isEmpty(appStatus))
        {
            appStatus = DetermineAppStatus(request.caseStage);
        }    
        
        try 
        {
        	vlocity_ins__Application__c appl = new vlocity_ins__Application__c();
        	
        	//Only update AppnStatus & Case Stage, if they are valid values in the Dropdown
        	if (checkStatus(request.caseStage))
        	{
	            //Update vlocity_ins_Application__c by Application_Number__c 
	            appl = [SELECT 
	                vlocity_ins__Status__c, EIN__c, Application_Number__c, vlocity_ins__AccountId__c, Id 
	            FROM vlocity_ins__Application__c  
	            WHERE Application_Number__c =: appId LIMIT 1  for update];
	                        
	            //Update Application Status
	            appl.vlocity_ins__Status__c = appStatus;
	                        
	            System.debug('INTEGRATION TESTING APPLICATION OBJECT ******************************'+ appl); 
	            update appl;
	
	            //Update Case object
	            status = UpdateCase(appl.Id, request.appId, request.EIN, request.caseStage);
         	}
         	else
         	{
		    	appl = [SELECT Id, Application_Number__c, vlocity_ins__AccountId__c 
		    	FROM vlocity_ins__Application__c WHERE Application_Number__c =: appId LIMIT 1];	          		
         	}
         	          
            //Update Account Case/Group#
            if (!String.isEmpty(request.caseNumber))
            {
            	String acctStatus = updateAcctGroupNumber(appl.vlocity_ins__AccountId__c, request.caseNumber, request.appId, request.EIN);
            	
            	if (acctStatus != 'SUCCESS')
            	{
            		if (status != 'SUCCESS')
            		{
            	 		status = status + ', ' + acctStatus;
            		}
            		else
            		{
            			status = acctStatus;
            		}
            	} 
            }         
        }
        catch(exception e)
        {
            status = 'No matching application data found for the provided EIN (' + request.EIN + ') ' + 'and APP ID (' + request.appId + ').';
            System.Debug('Error occurred in Updating Application: '+ e.getMessage());           
        }
                        
        return status;
    }
    
    public static String UpdateCase(String appId, String appIdForSGC, String einForSGC, String caseStage)
    {
        String status = 'SUCCESS';
        String caseId = '';
        try 
        {
            //Update Case by Application_Name__c 
            Case[] caseObjs = [SELECT id, Stage__c, Application_Name__c            
            FROM Case WHERE Application_Name__c =: appId];
            
            //AND Type =: 'Case Installation'
            //AND Status != 'Closed'
                        
            if (caseObjs.size() > 1)
            {
            	status = 'Multiple open Case records exist for the provided EIN (' + einForSGC + ') ' + 'and APP ID (' + appIdForSGC + ').';
                System.Debug('Multiple open Case records exist for the provided EIN (' + einForSGC + ') ' + 'and APP ID (' + appIdForSGC + ').');
                return status;                                       	
            }
            else
            {
            	caseId = caseObjs[0].Id;
            }            
                                       
            //Update Case by Id 
            Case caseObj = [SELECT id, Stage__c, Application_Name__c              
            FROM Case WHERE Id =: caseId for update];
            
           	System.Debug('One open Case record exists for the provided EIN (' + einForSGC + ') ' + 'and APP ID (' + appIdForSGC + ').'); 
           	
          	//Update Case Stage
          	caseObj.Stage__c = caseStage;
                
            System.debug('INTEGRATION TESTING CASE OBJECT ******************************'+ caseObj); 
          	update caseObj;           	
        }
        catch(exception e)
        {
            status = 'No Case data found for the provided EIN (' + einForSGC + ') ' + 'and APP ID (' + appIdForSGC + ').';
            System.Debug('Error occurred in Updating Case: '+ e.getMessage());           
        }
                
        return status;
    }
    
    public static String updateAcctGroupNumber(String acctId, String groupNum, String appIdForSGC, String einForSGC)
    {
    	String status = 'SUCCESS';
    	
    	try
    	{	    	
	        //Update Account Group/Case Number  
	        Account acctObj = [SELECT id, Name, Group_Number__c 
	        FROM Account WHERE id =: acctId LIMIT 1  for update];  	    
	  
	        acctObj.Group_Number__c = groupNum;
	 
	        System.debug('INTEGRATION TESTING ACCOUNT OBJECT ******************************'+ acctObj); 
	        update acctObj;
    	}
        catch(exception e)
        {
            status = 'No Account data found for the provided EIN (' + einForSGC + ') ' + 'and APP ID (' + appIdForSGC + '), Case/Group Number NOT updated.';
            System.Debug('Error occurred in Updating Account: '+ e.getMessage());           
        }
    	
        return status;    	
    }        
        
    public static String DetermineAppStatus (String caseStg)
    {       
        String appStatus = caseStg;      
        BRPSGCCaseStageCrossRef__c bpmCaseStage = BRPSGCCaseStageCrossRef__c.getValues(appStatus);

        if (bpmCaseStage != null)
        {
            System.debug('INTEGRATION TESTING BRPSGCCaseStageCrossReference Object ******************************' + bpmCaseStage.ApplicationStatus__c);                    
            appStatus = bpmCaseStage.ApplicationStatus__c;
        }
    
        return appStatus;
    }          

    public static Boolean checkStatus(String appStatus)
    {
  	    Set<String> statusList = new Set<String>();
   	   
   	    //Retrieving Application Status dropdown values   
        Schema.DescribeFieldResult fieldResult = vlocity_ins__Application__c.vlocity_ins__Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry s:ple)
        {           
             System.debug('Application Status: ' + s.getLabel());
             statusList.add(s.getLabel());
        } 
   	   
   	   //Retrieving Case.Stage__c Dropdown values      
       fieldResult = Case.Stage__c.getDescribe();
       ple = fieldResult.getPicklistValues();
       for (Schema.PicklistEntry s : ple)
       {
            System.debug('Case Stage: ' + s.getLabel());
            
            if (!statusList.contains(s.getLabel()))
            {
                statusList.add(s.getLabel());
            }
       } 
       
        if (statusList.contains(appStatus)) 
        {
       	    System.debug('INTEGRATION TESTING****************************** Update AppCaseStatus: ' + appStatus);  
       	    return true;     	
        }
        else
        {
            return false;
        }
    }      
}