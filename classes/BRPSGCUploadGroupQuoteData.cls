/**
* JIRA - SFOA-497: Start the Enrollment Process - Build a process to trigger the REST API Client when Application gets submitted
* BRPSGCUploadGroupQuoteData Class is used to parse the JSON Object from VLocity Omni Script and send it over to SGC
* @Date: 7/15/2016
* @Author: Arun Siddappa/Daryl Coutinho, Modified By: Darren Sherman
* 
*/
 
public with sharing class BRPSGCUploadGroupQuoteData
{
    public static boolean firstRun = true;
    public static boolean firstRunCase = true;
    public static String getGroupNumber = 'OBTAIN GROUP NUMBER'; 
    public boolean sendApp = false;
    public boolean obtainGroupNum = false;   
    public BRPSGCMakeRESTAPICallToSGC bRPSGCMakeRESTAPICallToSGC = new BRPSGCMakeRESTAPICallToSGC();

    public class SGCRequestModel
    {
    	public String sfdcAppId{get;set;}
    	public String einforSGC{get;set;}
    	public String appIdforSGC{get;set;}
    	public String reqJSON{get;set;}
    	public boolean groupCreated{get;set;}
    }    
          
    public void sendDataToSGC(String appId, boolean includeAppnStatus, boolean includeCaseStage, vlocity_ins__Application__c applOld)
    {    
 
       System.debug('INTEGRATION TESTING******************************inside sendDataToSGC');
       System.debug('INTEGRATION TESTING******************************app Id: ' + appId);
       System.debug('INTEGRATION TESTING******************************includeAppnStatus: ' + includeAppnStatus);
       System.debug('INTEGRATION TESTING******************************includeCaseStage: ' + includeCaseStage);     
               
       //Application Trigger
       if (applOld != null)
       {                   	      	          	      	   
	       if (firstRun) 
	       {
	           firstRun = false;
	       }
	       else 
	       {
	           System.debug('INTEGRATION TESTING******************************Application Census/Application Status - Already running!');
	           return;
	       }

           //Retrieve Limited vlocity_ins__Application__c data
  	       vlocity_ins__Application__c applObj = GetAppObjectLimited(appId);
       	
       	   //Check if Update is needed
           if (includeAppnStatus)
           {       	          	   
       	       if (!checkAppStatus(applObj.vlocity_ins__Status__c))
       	       {
                   System.debug('INTEGRATION TESTING******************************Not in Dropdown - RETURN');
                   return;       	   	          	   	   
       	       }
           }
       	       	         	   
       	   //Create/Update ApplicationCensus call
       	   sendApplicationDataSGC(appid, applOld, null);
       	          	   
       	   //If CreateApplicationCensus, don't send ApplicationStatus again
       	   if (sendApp)
       	   {
       	   	   includeAppnStatus = false;
       	   }       	          	   
       }
 
       System.debug('INTEGRATION TESTING******************************sendAppStatus: ' + sendApp);
       
       //Send Application Status/Case Stage to SGC
       if (includeAppnStatus || includeCaseStage)       
       {       	       	        	
       	   if (includeCaseStage)
       	   {
		       if (firstRunCase) 
		       {
		           firstRunCase = false;
		       }
		       else 
		       {
		           System.debug('INTEGRATION TESTING******************************Case Stage Update - Already running!');
		           return;
		       }
       	   }
 
           CreateApplicationCaseStatus(appId, includeCaseStage);
       }
       
       //If Case update - Determine if ObtainGroup# was clicked
       if (applOld == null)
       {
       	   DetermineCaseObtainGroupNumber(appId);
       }                                
    }
          
    public void sendApplicationDataSGC(String AppId, vlocity_ins__Application__c oldAppObj, String caseId)
    {
    	System.debug('INTEGRATION TESTING******************************inside sendApplicationDataSGC - AppId = '+ AppId);
    	
    	try
        {                    	
        	//Get Application Data
            vlocity_ins__Application__c vloApp = GetApplicationObject(AppId);
	        System.debug('INTEGRATION TESTING******************************Application Object: ' + vloApp);
	         
	        //Get SGC Application Status            
            String applStat = vloApp.SGC_Application_Status__c == null ? ' ' : vloApp.SGC_Application_Status__c;                               
            System.debug('INTEGRATION TESTING******************************SGC_Application_Status__c : ' + applStat);

	        //Get SGC Status            
            String sgcStat = vloApp.SGC_Status__c == null ? ' ' : vloApp.SGC_Status__c;                               
            System.debug('INTEGRATION TESTING******************************SGC_Status__c : ' + sgcStat);
                                   
            if(!applStat.containsIgnoreCase('SUCCESS'))  
            {    
                sendApp = true;
                         	             	            
	            //Get Application Type            
	            String appType = vloApp.vlocity_ins__Type__c;
	            System.debug('INTEGRATION TESTING******************************vlocity_ins_Type__c : ' + appType);
	                      
	            //Determine AppIdForSGC
	            String appIdForSGC = DetermineAppIdForSGC(AppId, vloApp.Application_Number__c, appType);
	            System.debug('INTEGRATION TESTING******************************appIdForSGC: ' + appIdForSGC);
	
	            //Determine EINForSGC
	            String einForSGC = DetermineEINForSGC(vloApp.EIN__c, vloApp.Account_Employer_EIN__c);
	            System.debug('INTEGRATION TESTING******************************einForSGC: ' + einForSGC);                                 
	        	
	        	//Build ApplicationCensus Request
	        	String reqJSON = buildApplicationCensusForSGC(AppId, vloApp);
	        	
	        	//Build Application Status Request
	        	SGCRequestModel sgcRequestModel = CreateAppCaseStatusRequest(AppId, false);
	        	 
	        	//Submit CreateApplicationCensus to Small Group Container
	            bRPSGCMakeRESTAPICallToSGC.CreateApplicationCensusInSGC(einForSGC, AppId, reqJSON, appIdForSGC, sgcRequestModel.reqJSON);
            }
            else if(appUpdated(vloApp, oldAppObj) || obtainGroupNum)  
	             {            	           	             	             	            
		            //Get Application Type            
		            String appType = vloApp.vlocity_ins__Type__c;
		            System.debug('INTEGRATION TESTING******************************vlocity_ins_Type__c : ' + appType);
		                      
		            //Determine AppIdForSGC
		            String appIdForSGC = DetermineAppIdForSGC(AppId, vloApp.Application_Number__c, appType);
		            System.debug('INTEGRATION TESTING******************************appIdForSGC: ' + appIdForSGC);
		
		            //Determine EINForSGC
		            String einForSGC = DetermineEINForSGC(vloApp.EIN__c, vloApp.Account_Employer_EIN__c);
		            System.debug('INTEGRATION TESTING******************************einForSGC: ' + einForSGC);                                 
		        	
		        	//Build ApplicationCensus Request
		        	String reqJSON = buildApplicationCensusForSGC(AppId, vloApp);
		        	
		        	//Submit CreateApplicationCensus to Small Group Container
		            bRPSGCMakeRESTAPICallToSGC.UpdateApplicationCensusInSGC(einForSGC, AppId, reqJSON, appIdForSGC, caseId);
	             }	
        }
        catch(Exception e){
            System.debug('Error invoking Rest Service (sendApplicationDataSGC): ' + e.getMessage());
            System.debug('Error invoking Rest Service (sendApplicationDataSGC): ' + e);
        }        
    }

    public void CreateApplicationCaseStatus(String appId, boolean includeCaseStage)
    {
    	System.debug('INTEGRATION TESTING******************************inside CreateApplicationCaseStatus');
    	
        try
        {               
            SGCRequestModel sgcModel = CreateAppCaseStatusRequest(appId, includeCaseStage);
        
            //Make RestAPI Call to Small Group Container
            if (!String.isEmpty(sgcModel.reqJSON))
            {            
                bRPSGCMakeRESTAPICallToSGC.CreateApplicationStatusCensusInSGC(sgcModel.einForSGC, sgcModel.sfdcAppId, sgcModel.reqJSON, sgcModel.appIdForSGC);
            }
        }
        catch(Exception e)
        {
            System.Debug('Error occurred in BRPSGCUploadGroupQuoteData - CreateApplicationCaseStatus : ' + e.getMessage());
        }                
    }

    public SGCRequestModel CreateAppCaseStatusRequest(String appId, boolean includeCaseStage)
    {
    	System.debug('INTEGRATION TESTING******************************inside CreateAppCaseStatusRequest');
    	String reqJSON = '';
   	    Case caseObjRet = new Case();    	
    	SGCRequestModel reqModel = new SGCRequestModel();
     	reqModel.groupCreated = false;
    	
        try
        {                         
            String applicationId = appId;
            User user = new User();
                         
            //Get Current Date/Time  
            datetime nowDateTime = datetime.now();      

            //Construct ApplicationStatus model 
            BRPSGCRealTimeDataModels.ApplicationStatus appStatus = new BRPSGCRealTimeDataModels.ApplicationStatus();
            
            if (includeCaseStage)
            {
                //Get Case Information
                caseObjRet = GetCaseObject(applicationId);
                
                applicationId = caseObjRet.Application_Name__c;                
                appStatus.caseStage = caseObjRet.Stage__c;  
                appStatus.underwriterNotes = formatUnderwriterNotes(caseObjRet.Underwriter_Notes__c);
                appStatus.enrollmentType = caseObjRet.BR_Sub_Category__c; 
                
                //Get LastModifiedBy UserName
                user = GetUserInfo(caseObjRet.LastModifiedById);
            }
                        
            //Retrieve Application Object
            vlocity_ins__Application__c applObjRet = GetApplicationObject(applicationId);
                                               
            //Get ApplicationType
            String appType = applObjRet.vlocity_ins__Type__c;
             
            //Set Case/Group Number
            appStatus.caseNumber = applObjRet.Account_Group_Number__c;
            
            //Set DateTime Stamp
            appStatus.statusUpdateTmstmp = nowDateTime.format('yyyy-MM-dd hh:mm:ss');
                         
            if (!includeCaseStage)
            {                           	   
            	//Case/Group Number Assigned will NOT be sent from Case          	
            	if (applObjRet.vlocity_ins__Status__c == 'Case/Group Number Assigned')
            	{
                    System.debug('INTEGRATION TESTING****************************** Application Status will not be sent.');           		
            		return reqModel;
            	}            
            	     
            	//Set Application Status in request, caseStage is Mandatory
            	appStatus.caseStage = applObjRet.vlocity_ins__Status__c;                    
                appStatus.appnStatus = applObjRet.vlocity_ins__Status__c;
                
                //Get LastModifiedBy UserName
                user = GetUserInfo(applObjRet.LastModifiedById);                                        
            }

            System.debug('INTEGRATION TESTING****************************** LastModifiedUser: ' + user.Name);                	
            
            //If last updated by sgc interface user don't resend            
            if (user.Name == 'sgc interface')
            {
            	System.debug('INTEGRATION TESTING****************************** Application/Case Status will not be sent.');                	            	
            	return reqModel;
            }         
            
            //Determine Application Type              
            if (appType.containsIgnoreCase('PAPER'))
            {
                appStatus.channel = 'PAPER';                
            }                   
            else
            {
                appStatus.channel = 'ELECTRONIC';
            }
            
            //Populate SFDC ApplicationId
            reqModel.sfdcAppId = applicationId;
            
            //Determine AppIdForSGC
            reqModel.appIdforSGC = DetermineAppIdForSGC(applicationId, applObjRet.Application_Number__c, appType);
            appStatus.appid = reqModel.appIdforSGC;
            System.debug('INTEGRATION TESTING******************************appIdForSGC: ' + reqModel.appIdforSGC);

            //Determine EINForSGC
            reqModel.einForSGC = DetermineEINForSGC(applObjRet.EIN__c, applObjRet.Account_Employer_EIN__c);
            appStatus.ein = reqModel.einForSGC;                     
            System.debug('INTEGRATION TESTING******************************einForSGC: ' + reqModel.einForSGC);                                 
            
            //Serialize ApplicationStatus Data Model into JSON String
            reqModel.reqJSON = JSON.serialize(appStatus, true);

            System.debug('INTEGRATION TESTING******************************appId: ' + reqModel.appIdforSGC);           
            System.debug('INTEGRATION TESTING******************************reqJSON: ' + reqModel.reqJSON);                
        }
        catch(Exception e)
        {
            System.Debug('Error occurred in BRPSGCUploadGroupQuoteData - CreateAppCaseStatusRequest : ' + e.getMessage());
            return reqModel; 
        }                
        
        return reqModel;
    }
       
    public String buildApplicationCensusForSGC(String AppId, vlocity_ins__Application__c vloApp)
    {
        System.debug('INTEGRATION TESTING******************************inside buildApplicationCensusForSGC');
        
        String reqJSON = '';
         
        try
        {
        	//Get Account information for the Application
            Account account = GetAccountInfo(vloApp.vlocity_ins__AccountId__c);
            
            //Get Application Owner User information
            User user = GetUserInfo(vloApp.OwnerId);

            //Get Group Admin Contact information            
            Contact contact = GetContactInfo(account.Group_Admin__c);
            
            //Get Application Type            
            String appType = vloApp.vlocity_ins__Type__c;
            
            //ApplicationCensus Model 
            BRPSGCRealTimeDataModels.ApplicationCensus appCensus = new BRPSGCRealTimeDataModels.ApplicationCensus();
            
            //Populate Application Model	            	            
            appCensus.groupNumber = vloApp.Account_Group_Number__c;
            appCensus.groupName = vloApp.Account_Name__c == null ? 'NOTENTERED' : vloApp.Account_Name__c;
        	appCensus.sicCode = account.Sic == null ? 'NOTENTERED' : account.Sic;
        	
        	//Determine application State/Account State
        	if (vloApp.State__c == null)
        	{
        		if (vloApp.Account_State__c != null)
        		{
        			appCensus.state = vloApp.Account_State__c.toUpperCase();			
        		}
        		else
        		{
        			appCensus.state = 'NY';
        		}        		        		
        	}
        	else
        	{
        		appCensus.state = vloApp.State__c.toUpperCase();
        	}
        	
        	appCensus.lob = 'SG';
        	appCensus.specialty = vloApp.Specialty_Indicator__c == null ? 'NO' : vloApp.Specialty_Indicator__c;
        	
        	//Obtain Group Number Check
        	if (obtainGroupNum) 
        	{
        		appCensus.appnStatus = getGroupNumber;
                System.debug('INTEGRATION TESTING******************************OBTAIN GROUP NUMBER Requested');
        	} 
        	else
        	{
        		appCensus.appnStatus = vloApp.vlocity_ins__Status__c == null ? 'NOTENTERED' : vloApp.vlocity_ins__Status__c;
        	}
        	        	        
        	appCensus.medicareHibID = DateTime.now().format('MM/dd/yyyy');
        	appCensus.medicarePartAEffDate = DateTime.now().format('MM/dd/yyyy');
        	appCensus.medicarePartBEffDate = DateTime.now().format('MM/dd/yyyy');       		
        	appCensus.partTimeIndicator = 'NO';
        	appCensus.partTimeCount = '0';
        	appCensus.partTimeHours = '0';
        	appCensus.fullTimeHours = '0';
        	appCensus.healthcareCount = '0';
        	appCensus.hRAIndicator = 'N';
        	appCensus.hCRIndicator = 'N';
        	appCensus.medicarePrimeIndicator = 'N';
        	appCensus.priorDentalCoverageIndicator = 'N';      
        	appCensus.seasonalIndicator = 'N';     
        	appCensus.cobraIndicator = 'N';
        	appCensus.cobraStartDate = DateTime.now().format('MM/dd/yyyy');               
        	appCensus.cobraQualifyingEvent = 'Voluntary Termination';
        	appCensus.eOCIndicator = 'N';  
        	appCensus.cdhpIndicator = 'N';
        	appCensus.personalLeaveOfAbsence = '00';
        	appCensus.medicalLeaveOfAbsence = '00';
	        appCensus.isMedicalPresent = 'N';
	        appCensus.isDentalPresent = 'N';
	        appCensus.isVisionPresent = 'N';
	        appCensus.isLnDPresent = 'N';
	        
	        //Get QuoteNumber	        
	        if (vloApp.vlocity_ins__QuoteId__c != null)
	        {
	        	Quote quoteObj = GetQuoteInfo(vloApp.vlocity_ins__QuoteId__c);
	        	appCensus.quoteID = quoteObj.QuoteNumber;
	        }
	        else
	        {
	        	appCensus.quoteID = 'NOTENTERED';
	        }
	        
            //UserId
            if (user != null && user.Name != null)
            {
        		appCensus.userId = user.Name;
            }
        	
            //Determine Application Type
            if (appType.containsIgnoreCase('PAPER'))
        	{
            	appCensus.channelTypeIndicator = 'PAPER';                
        	}                   
        	else
        	{
            	appCensus.channelTypeIndicator = 'ELECTRONIC';
        	}
        	
            //Group Coverage Date      
        	if (vloApp.Group_Coverage_Date__c != null)
        	{
        		DateTime formatDate = vloApp.Group_Coverage_Date__c;        		       	 
        		appCensus.groupCoverageDate = formatDate.formatGMT('yyyy-MM-dd');
        	}
        	else
        	    appCensus.groupCoverageDate = DateTime.now().format('yyyy-MM-dd');
        	
        	//Application Status Update Date
        	if (vloApp.Current_Status_Date__c != null)
        	{
        		DateTime formatDate = vloApp.Current_Status_Date__c;        	 
        		appCensus.applicationStatusUpdateDate = formatDate.formatGMT('MM/dd/yyyy');
        	}
        	else
        	    appCensus.applicationStatusUpdateDate = DateTime.now().format('MM/dd/yyyy');
        	    
        	//Approval Date
        	if (vloApp.Date_Application_Signed_Under_Review__c != null)
        	{
        		DateTime formatDate = vloApp.Date_Application_Signed_Under_Review__c;        	 
        		appCensus.approvalDate = formatDate.formatGMT('MM/dd/yyyy');
        	}
        	else
        		appCensus.approvaldate = DateTime.now().format('MM/dd/yyyy');
        	
        	//Member Count	        	      
        	if (vloApp.Member_Count__c != null)     
        		appCensus.memberCount = String.valueOf(vloApp.Member_Count__c);
        	else
        	    appCensus.memberCount = '1';
        	
        	//FullTime Count
        	if (vloApp.Num_of_Eligible_Full_Time_Employees__c != null)
        		appCensus.fullTimeCount = String.valueOf(vloApp.Num_of_Eligible_Full_Time_Employees__c);
        	else
        		appCensus.fullTimeCount = '1';

            //StaffLevel model 
            List<BRPSGCRealTimeDataModels.StaffLevel> staffLevels = new List<BRPSGCRealTimeDataModels.StaffLevel>();             	            
            BRPSGCRealTimeDataModels.StaffLevel staffLevel = new BRPSGCRealTimeDataModels.StaffLevel();	            
            staffLevel.sTFLevelCode = '00';
            staffLevel.waitMonths = '0';
            staffLevels.add(staffLevel);
            appCensus.staffLevel = staffLevels;	
  
            //Adding EnrollmentType
            List<BRPSGCRealTimeDataModels.EnrollmentTypes> enrollTypes = new List<BRPSGCRealTimeDataModels.EnrollmentTypes>();             	            
            BRPSGCRealTimeDataModels.EnrollmentTypes enrollType = new BRPSGCRealTimeDataModels.EnrollmentTypes();	            
            enrollType.enrollmentType='NOTENTERED';
            enrollTypes.add(enrollType);
            appCensus.enrollmentTypes = enrollTypes;	
            
            //Agent Information model 
            BRPSGCRealTimeDataModels.AgentInformation agentInfo = new BRPSGCRealTimeDataModels.AgentInformation();
            appCensus.agentInformation = agentInfo;
            agentInfo.nonBrokerIndicator = 'N';
            agentInfo.generalAgentIndicator = 'N';	            
            agentInfo.medicalCommsionInput = '0';
            agentInfo.dentalCommsionInput = '0';
            agentInfo.visionCommsionInput = '0';
            agentInfo.lifeCommsionInput = '0';
            agentInfo.wKCCommsionInput = '0';
            agentInfo.sTDCommsionInput = '0';
            
            //AgentTins
            List<BRPSGCRealTimeDataModels.AgentTINs> agentTINs = new List<BRPSGCRealTimeDataModels.AgentTINs>();             	            
            BRPSGCRealTimeDataModels.AgentTINs agentTIN = new BRPSGCRealTimeDataModels.AgentTINs();	            

            try 
            {	
            	//WritingAgentEIN
                if(vloApp.WritingAgentETIN__c != null)
                {
                    agentTIN.writingTIN = vloApp.WritingAgentETIN__c;
                    System.debug('WritingAgentTIN - ' + agentTIN.writingTIN);                    
                }  
                else
                    agentTIN.writingTIN = 'NOTENTERED';  

                //PaidAgencyETIN
                if(vloApp.Paid_Agency_ETIN__c != null)
                {
                    agentTIN.payeeTIN = vloApp.Paid_Agency_ETIN__c;
                    System.debug('PaidAgencyETIN - ' + agentTIN.payeeTIN);                    
                }  
                else
                    agentTIN.payeeTIN = 'NOTENTERED';  
                	    
                //ParentAgencyETIN
                if(vloApp.Parent_Agency_ETIN__c != null)
                {
                    agentTIN.parentTIN = vloApp.Parent_Agency_ETIN__c;
                    System.debug('ParentAgencyETIN - ' + agentTIN.parentTIN);                        
                }  
                else
                    agentTIN.parentTIN = 'NOTENTERED';                 	    
            }
            catch(Exception ex)
            {
                System.debug('Error mapping Parent_Agency_ETIN__c, Paid_Agency_ETIN__c, or WritingAgentETIN__c ' + ex.getMessage());
            }

            agentTINs.add(agentTIN);
            agentInfo.AgentTINs = agentTINs;	
            
            //Company Information model 
            BRPSGCRealTimeDataModels.CompanyInformation companyInformation = new BRPSGCRealTimeDataModels.CompanyInformation();
            appCensus.companyInformation = companyInformation;	            	            
            
            if (!String.isEmpty(contact.Name))
            {
            	companyInformation.mailPackageTo = contact.Name;
            }
            else
            {
            	companyInformation.mailPackageTo = 'Dummy';
            }
            
            //Billing Address
            BRPSGCRealTimeDataModels.Addresses billingAddress = new BRPSGCRealTimeDataModels.Addresses();	
            companyInformation.billingAddress = billingAddress;	                        
            
            if (account != null && !String.isEmpty(account.BillingState))
            {
	            billingAddress.zip = account.BillingPostalCode;
	            billingAddress.state = account.BillingState;
	            billingAddress.city = account.BillingCity;
	            billingAddress.streetAddress = account.BillingStreet;
            }
            else
            {
        	    if (appCensus.state == 'CA')
        		{
            	    billingAddress.zip = '90021';
            	    billingAddress.state = 'CA';
            	    billingAddress.city = 'Los Angeles';            		
        	    }
        	    else if (appCensus.state == 'CO')
        	         {
        	     	  	 billingAddress.zip = '80203';
            	         billingAddress.state = 'CO';
            	         billingAddress.city = 'Denver';            	     	  	
        	     	 }
        	     	 else if (appCensus.state == 'ME')
        	     	      {
            	              billingAddress.zip = '04330';
            	              billingAddress.state = 'ME';
            	              billingAddress.city = 'Augusta';            	     	  	
        	     	      }
       	     	          else
       	     	          {
            	              billingAddress.zip = '10001';
            	              billingAddress.state = 'NY';
            	              billingAddress.city = 'New York';           	     	           	
       	     	          }
           	     	           
	            billingAddress.streetAddress = '123 ABC St.';	            	
            }
	            
	        //ContactDetails model
	        List<BRPSGCRealTimeDataModels.ContactDetails> contactDetails = new List<BRPSGCRealTimeDataModels.ContactDetails>();	            
	        BRPSGCRealTimeDataModels.ContactDetails contactDetail = new BRPSGCRealTimeDataModels.ContactDetails();
	        
	        if (!String.isEmpty(account.Email_Address__c))
	        {
	        	contactDetail.contactEmailAddress = account.Email_Address__c;
	        }
	        else
	        {
	        	contactDetail.contactEmailAddress = 'NOT GIVEN';
	        }
	        
	        if (!String.isEmpty(contact.Name))
            {
            	contactDetail.contactName = contact.Name;
            }
            else
            {
            	contactDetail.contactName = 'Dummy';
            }
	        
	        if (!String.isEmpty(account.Phone_Number__c))
            {           	            	
            	contactDetail.primaryPhone = account.Phone_Number__c.replaceAll('[^0-9]','');
            }
            else
            {
            	contactDetail.primaryPhone = '9999999999';
            }
	        
	        if (!String.isEmpty(account.Fax))
            {
            	contactDetail.faxNumber = account.Fax.replaceAll('[^0-9]','');
            }
            else
            {
            	contactDetail.faxNumber = '9999999999';
            }	        
	        
	        contactDetails.add(contactDetail);
	        companyInformation.contactDetails = contactDetails;
           	    
	        //Medical Product model 
	        List<BRPSGCRealTimeDataModels.Products> medicalProducts = new List<BRPSGCRealTimeDataModels.Products>();             	            
	        BRPSGCRealTimeDataModels.Products product = new BRPSGCRealTimeDataModels.Products();
	        medicalProducts.add(product);
	        appCensus.selectedMedicalProducts = medicalProducts;		            	            
	        product.benefitLevel = '00';
            product.benefitLevelCount = '00';
            product.contractCode = '9999';
            product.productSubType = 'POS';
            product.rate = '00.00';
            product.employerContributionRatio = '100';	            
 
 	        //Dental Products model 
	        List<BRPSGCRealTimeDataModels.Products> dentalProducts = new List<BRPSGCRealTimeDataModels.Products>();             	            	            
	        dentalProducts.add(product);
	        appCensus.selectedDentalProducts = dentalProducts;	
 
 	        //Vision Products model 
	        List<BRPSGCRealTimeDataModels.Products> visionProducts = new List<BRPSGCRealTimeDataModels.Products>();             	            	            
	        visionProducts.add(product);
	        appCensus.selectedVisionProducts = visionProducts;	            
	            
            //Subscriber model
            List<BRPSGCRealTimeDataModels.Subscribers> subscribers = new List<BRPSGCRealTimeDataModels.Subscribers>();             	            
            BRPSGCRealTimeDataModels.Subscribers subscriber = new BRPSGCRealTimeDataModels.Subscribers();
            subscribers.add(subscriber);
            appCensus.subscribers = subscribers;	            
            subscriber.firstName = 'Dummy';
            subscriber.lastName = 'Dummy';
            subscriber.dob = '12/31/1960';
            subscriber.ssn = '999999999';
            subscriber.emailID = 'dummysubscriber@anthem.com';	            
	            
            //Dependent model
            List<BRPSGCRealTimeDataModels.Dependents> dependents = new List<BRPSGCRealTimeDataModels.Dependents>();             	            
            BRPSGCRealTimeDataModels.Dependents dependent = new BRPSGCRealTimeDataModels.Dependents();	            
            dependents.add(dependent);
            subscriber.dependents = dependents;	            
            dependent.firstName = 'Dummy';
            dependent.lastName = 'Dummy';
            dependent.dob = '12/31/2016';
            dependent.ssn = '999999998';
            dependent.emailID = 'dummydependent@anthem.com';
            dependent.relationship = 'CHILD';	            	            	            
             
            //Serialize ApplicationCensus Data Model into JSON String
            reqJSON = JSON.serialize(appCensus, true);
      
            System.debug('INTEGRATION TESTING******************************reqJSON: ' + reqJSON);                                     
       }
       catch (Exception e){
            System.debug('Error Populating ApplicationCensus Request: ' + e.getMessage());
            System.debug('Error Populating ApplicationCensus Request: ' + e);
       }
       
       return reqJSON;
    }  
                     
    public vlocity_ins__Application__c GetApplicationObject(String appId)
    {
    	vlocity_ins__Application__c applObj = new vlocity_ins__Application__c();
    	try 
    	{
    	     applObj = [SELECT 
	         	  Id,
	    	      Account_Employer_EIN__c,
	    	      Account_Group_Number__c,
	    	      Account_Name__c, 
	    	      Application_Number__c,
	    	      Account_State__c, 
	    	      Current_Status_Date__c, 
	    	      Date_Application_Signed_Under_Review__c,
	    		  EIN__c, 
	    	      Group_Coverage_Date__c,
	    	      LastModifiedById, 
	    	      Member_Count__c,
	    	      Num_of_Eligible_Full_Time_Employees__c,
	    	      OwnerId, 
	    	      Paid_Agency_ETIN__c, 
	    	      Parent_Agency_ETIN__c, 
	    	      Specialty_Indicator__c, 
	    		  SGC_Application_Status__c,
	    		  SGC_Status__c,
				  State__c,    		   
	              vlocity_ins__AccountId__c,			  
	    	      vlocity_ins__ApplicationReferenceNumber__c,    		   
	    	      vlocity_ins__JSONData__c,
	    	      vlocity_ins__OwnerLink__c,      	       
	    	      vlocity_ins__PrimaryApplicantLink__c,
	    	      vlocity_ins__PrimaryPartyId__c,     	      
	    	      vlocity_ins__QuoteId__c, 
	    	      vlocity_ins__Status__c, 
	    	      vlocity_ins__Summary__c, 
	    	      vlocity_ins__Type__c,
	    	      WritingAgentETIN__c 
	    	      FROM vlocity_ins__Application__c 
    	     WHERE Id=:appId LIMIT 1];
    	}
        catch(Exception e){
            System.debug('Error Retrieving vlocity_ins__Application__c object (GetApplicationObject): ' + e.getMessage());
            System.debug('Error Retrieving vlocity_ins__Application__c object (GetApplicationObject): ' + e);
        }          	
    	        
        return applObj;
    }

    public vlocity_ins__Application__c GetAppObjectLimited(String appId)
    {
        vlocity_ins__Application__c applObj = new vlocity_ins__Application__c ();
    	try 
    	{    	
	    	applObj = [SELECT 
	    		  Id,
	    		  SGC_Application_Status__c,
	    		  SGC_Status__c,	    		  
	    		  vlocity_ins__Status__c
	    	      FROM vlocity_ins__Application__c 
	    	WHERE Id=:appId LIMIT 1];
    	}
        catch(Exception e){
            System.debug('Error Retrieving vlocity_ins__Application__c (GetAppObjectLimited) object: ' + e.getMessage());
            System.debug('Error Retrieving vlocity_ins__Application__c (GetAppObjectLimited) object: ' + e);
        }          	
    	        
        return applObj;
    }

	public Case GetCaseObject(String caseId)
	{
		Case caseObj = new Case();
				
    	try 
    	{    	
		    caseObj = [SELECT 
		        AccountId,
		        Application_Name__c,
		        Tech_ObtainGroupNumber__c,
		        OriginalDescription__c,
                BR_Sub_Category__c,       
		        Id,	    
	            LastModifiedById,	    
		        Stage__c, 
	            Underwriter_Notes__c 
		        FROM Case
		    WHERE Id =: caseId LIMIT 1];
    	}
        catch(Exception e){
            System.debug('Error Retrieving Case (GetCaseObject) object: ' + e.getMessage());
            System.debug('Error Retrieving Case (GetCaseObject) object: ' + e);
        }          	
	    
	    return caseObj;
	}
	
	public Account GetAccountInfo(String acctId)
	{
		Account acctObj = new Account();
		
    	try 
    	{    	
		    acctObj = [SELECT
		        BillingCity, 
		        BillingPostalCode,
		        BillingState,
		        BillingStreet,
		        Email_Address__c,
		        Group_Admin__c,
		        Group_Number__c,
		        Phone_Number__c,
		        Fax,
		        Sic,
		        Id
		        FROM Account
		    WHERE Id =: acctId LIMIT 1];
    	}
        catch(Exception e){
            System.debug('Error Retrieving Account (GetAccountInfo) object: ' + e.getMessage());
            System.debug('Error Retrieving Account (GetAccountInfo) object: ' + e);
        }   
               	
	    return acctObj;
	}

	public Quote GetQuoteInfo(String quoteId)
	{
        Quote quoteObj = new Quote();
        		
    	try 
    	{    	
		    quoteObj = [SELECT
		        QuoteNumber,
		        Id
		        FROM Quote
		    WHERE Id =: quoteId LIMIT 1];
    	}
        catch(Exception e){
            System.debug('Error Retrieving Quote (GetQuoteInfo) object: ' + e.getMessage());
            System.debug('Error Retrieving Quote (GetQuoteInfo) object: ' + e);
        }          	
	    
	    return quoteObj;
	}
	
	public User GetUserInfo(String userId)
	{
		User userObj = new User();
		
    	try 
    	{    	
			userObj = [SELECT
		        Name, 
		        Id
		        FROM User
		    WHERE Id =: userId LIMIT 1];
    	}
        catch(Exception e){
            System.debug('Error Retrieving User (GetUserInfo) object: ' + e.getMessage());
            System.debug('Error Retrieving User (GetUserInfo) object: ' + e);
        }          	

	    return userObj;
	}

	public Contact GetContactInfo(String contactId)
	{
		Contact contactObj = new Contact();
		
		if (!String.isEmpty(contactId))
		{
	    	try 
	    	{    	
				contactObj = [SELECT
			        Name, 
			        Id
			        FROM Contact 
			    WHERE Id =: contactId LIMIT 1];
	    	}
	        catch(Exception e){
	            System.debug('Error Retrieving Contact (GetContactInfo) object: ' + e.getMessage());
	            System.debug('Error Retrieving Contact (GetContactInfo) object: ' + e);
	        }          	
		}
		
	    return contactObj;
	}
   
   public String DetermineAppIdForSGC(String appId, String appNumber, String appType)
   {
        String appIdForSGC = appId.substring(appId.length() - 9);
                    
        if ((appNumber + '').length() > 5)
        {                	
        	if (!appType.containsIgnoreCase('PAPER'))
        	{
        		appIdForSGC = appNumber + 'ZZZ';
        	}
        	else
        	{
        		appIdForSGC = appNumber;                 		
        	}
        }
                            
        return appIdForSGC.trim();
   }

   public String DetermineEINForSGC(String ein, String employerEIN)
   {
        String einForSGC = ein;  
        if (String.isEmpty(einForSGC))
        {
            einForSGC = employerEIN;
        }  
      
        return einForSGC;
   }

   public void DetermineCaseObtainGroupNumber(String caseId)
   {
    	System.debug('INTEGRATION TESTING******************************inside CreateAppCaseStatusRequest');
   	 	
   	    //Get CaseObject
   	    Case caseObj = GetCaseObject(caseId);
  	    String appId = caseObj.Application_Name__c;
   	    String acctId = caseObj.AccountId;
    	boolean obtainGrpNum = caseObj.Tech_ObtainGroupNumber__c;
   	    String obtainGrpNumStatus = caseObj.OriginalDescription__c == null ? ' ' : caseObj.OriginalDescription__c;  	       	    
   	    
   	    //Get Application Details
   	    vlocity_ins__Application__c applObj = GetAppObjectLimited(appId);
   	    String appStatus = applObj.SGC_Application_Status__c == null ? ' ' : applObj.SGC_Application_Status__c;
   	    
   	    //Get the Account Details
   	    Account acctObj = GetAccountInfo(acctId);
   	    boolean noGrpNum = String.isEmpty(acctObj.Group_Number__c) ? true : false;
 
     	System.debug('INTEGRATION TESTING******************************noGrpNum : ' + noGrpNum);
     	System.debug('INTEGRATION TESTING******************************obtainGrpNum : ' + obtainGrpNum);
     	System.debug('INTEGRATION TESTING******************************appStatus : ' + appStatus);
     	System.debug('INTEGRATION TESTING******************************obtainGrpNumStatus : ' + obtainGrpNumStatus);
   	       	    
        if (noGrpNum && obtainGrpNum && appStatus.containsIgnoreCase('SUCCESS') && !obtainGrpNumStatus.containsIgnoreCase('SUCCESS'))   	   	    
   	    {
   	    	obtainGroupNum = true;
   	    	sendApplicationDataSGC(appId, new vlocity_ins__Application__c(), caseId);
   	    }    	          
   }  
            
   public String formatUnderwriterNotes(String uNotes)
   {
       String notes = uNotes; 
   	  
   	   System.debug('INTEGRATION TESTING****************************** Underwriter Notes prior (to special char replacement): ' + notes);
   	   
   	   if (uNotes != null)
   	   {  	   	
	   	   notes = notes.replace('$','DOLLAR');
	   	   notes = notes.replace('&','AND');
	   	   notes = notes.replace('%','PERCENTAGE');
	   	   notes = notes.replace('+','PLUS');
	   	   notes = notes.replace('\\','BACKSLASH');
	   	   notes = notes.replace('/','FORWARD SLASH');
	   	   notes = notes.replace(':','COLON');
	   	   notes = notes.replace('*','ASTERICK');
	   	   notes = notes.replace(';','SEMICOLON');
	   	   notes = notes.replace('?','QUESTION MARK');
	   	   notes = notes.replace('"','DOUBLE QUOTES');
	   	   notes = notes.replace('<','LESS THAN');
	   	   notes = notes.replace('>','GREATER THAN');
	   	   notes = notes.replace('|','VERTICAL BAR');
	   	   //notes = notes.replace('\r','CARRIAGE RETURN');
	   	   //notes = notes.replace('\n','NEW LINE');
	   	   
	   	   //Trim Underwriter notes if exceeds 4000
	   	   if (notes.length() > 4000)
	   	   {
	   	   	   notes = notes.substring(0,4000);   	   	
	   	   }
   	   }
   	   
       System.debug('INTEGRATION TESTING****************************** Underwriter Notes after (special char replacement): ' + notes);
   	      	   
   	   return notes;
   }

   public boolean appUpdated(vlocity_ins__Application__c uApp, vlocity_ins__Application__c oApp)
   { 	  
   	   System.debug('INTEGRATION TESTING****************************** Updated Application: ' + uApp);
   	   System.debug('INTEGRATION TESTING****************************** Old Application: ' + oApp);   	   
   	   boolean sendUpdate = false;
   	   
   	   if (oApp != null)
   	   {             	   	
	   	   if (uApp.Account_Group_Number__c != oApp.Account_Group_Number__c)
	   	       sendUpdate = true;
	   	   	
	   	   if (uApp.Account_Name__c != oApp.Account_Name__c)
	   	       sendUpdate = true;
	   	   	
	   	   if (uApp.vlocity_ins__QuoteId__c != oApp.vlocity_ins__QuoteId__c)
	   	   	   sendUpdate = true;
	  	   	
	   	   if (uApp.State__c != oApp.State__c)
	   	   	   sendUpdate = true;

	   	   if (uApp.Specialty_Indicator__c != oApp.Specialty_Indicator__c)
	   	   	   sendUpdate = true;

	   	   if (uApp.vlocity_ins__Status__c != oApp.vlocity_ins__Status__c)
	   	   	   sendUpdate = true;

	   	   if (uApp.OwnerId != oApp.OwnerId)
	   	   	   sendUpdate = true;

	   	   if (uApp.vlocity_ins__Type__c != oApp.vlocity_ins__Type__c)
	   	   	   sendUpdate = true;

	   	   if (uApp.Group_Coverage_Date__c != oApp.Group_Coverage_Date__c)
	   	   	   sendUpdate = true;

	   	   if (uApp.Current_Status_Date__c != oApp.Current_Status_Date__c)
	   	   	   sendUpdate = true;

	   	   if (uApp.Date_Application_Signed_Under_Review__c != oApp.Date_Application_Signed_Under_Review__c)
	   	   	   sendUpdate = true;

	   	   if (uApp.Member_Count__c != oApp.Member_Count__c)
	   	   	   sendUpdate = true;

	   	   if (uApp.Num_of_Eligible_Full_Time_Employees__c != oApp.Num_of_Eligible_Full_Time_Employees__c)
	   	   	   sendUpdate = true;

	   	   if (uApp.WritingAgentETIN__c != oApp.WritingAgentETIN__c)
	   	   	   sendUpdate = true;

	   	   if (uApp.Paid_Agency_ETIN__c != oApp.Paid_Agency_ETIN__c)
	   	   	   sendUpdate = true;

	   	   if (uApp.Parent_Agency_ETIN__c != oApp.Parent_Agency_ETIN__c)
	   	   	   sendUpdate = true;
	   	   
	   	   User user = GetUserInfo(uApp.LastModifiedById);	   	   	   
	   	   if (user.Name == 'sgc interface')
           {
               sendUpdate = false;
           }
   	   }

   	   return sendUpdate;
   }
    
   public Boolean checkAppStatus(String appStatus)
   {
  	   Set<String> statusList = new Set<String>();
   	   
   	   //Retrieving Application Status dropdown values   
       Schema.DescribeFieldResult fieldResult = vlocity_ins__Application__c.vlocity_ins__Status__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for(Schema.PicklistEntry s:ple){
           
           System.debug('Application Status: ' + s.getLabel());
           statusList.add(s.getLabel());
       } 
   	          
       if (statusList.contains(appStatus)) 
       {
       	   System.debug('INTEGRATION TESTING****************************** Send AppStatus: ' + appStatus);  
       	   return true;     	
       }
       else
       {
           return false;
       }
   }
    
   public String getMockRequest()
   {
   		String request = '{"userId":"DummyUser","subscribers":[{"ssn":"999999999","lastName":"Dummy","firstName":"Dummy","emailID":"dummysubscriber@anthem.com","dob":"12/31/1960","dependents":[{"ssn":"999999998","relationship":"CHILD","lastName":"Dummy","firstName":"Dummy","emailID":"dummydependent@anthem.com","dob":"12/31/2016"}]}],"state":"XX","staffLevel":[{"waitMonths":"0","sTFLevelCode":"99"}],"specialty":"No","sicCode":"NOTENTERED","selectedVisionProducts":[{"rate":"00.00","productSubType":"POS","employerContributionRatio":"100","contractCode":"9999","benefitLevelCount":"00","benefitLevel":"00"}],"selectedMedicalProducts":[{"rate":"00.00","productSubType":"POS","employerContributionRatio":"100","contractCode":"9999","benefitLevelCount":"00","benefitLevel":"00"}],"selectedDentalProducts":[{"rate":"00.00","productSubType":"POS","employerContributionRatio":"100","contractCode":"9999","benefitLevelCount":"00","benefitLevel":"00"}],"seasonalIndicator":"N","quoteID":"NOTENTERED","priorDentalCoverageIndicator":"N","personalLeaveOfAbsence":"00","partTimeIndicator":"NO","partTimeHours":"0","partTimeCount":"0","memberCount":"15","medicarePrimeIndicator":"N","medicarePartBEffDate":"10/09/2017","medicarePartAEffDate":"10/09/2017","medicareHibID":"10/09/2017","medicalLeaveOfAbsence":"00","lob":"SG","isVisionPresent":"N","isMedicalPresent":"N","isLnDPresent":"N","isDentalPresent":"N","hRAIndicator":"N","healthcareCount":"0","hCRIndicator":"N","groupNumber":"123456","groupName":"Tony Demo","groupCoverageDate":"2017-10-31","fullTimeHours":"0","fullTimeCount":"15","eOCIndicator":"N","companyInformation":{"mailPackageTo":"Dummy","contactDetails":[{"primaryPhone":"999-999-9999","faxNumber":"999-999-9999","contactName":"Dummy","contactEmailAddress":"Contact@anthem.com"}],"billingAddress":{"zip":"99999","streetAddress":"123 ABC St.","state":"CA","city":"Los Angeles"}},"cobraStartDate":"10/09/2017","cobraQualifyingEvent":"1","cobraIndicator":"N","channelTypeIndicator":"PAPER","cdhpIndicator":"N","approvalDate":"10/09/2017","appnStatus":"Case/Group Number Assigned","applicationStatusUpdateDate":"10/08/2017","agentInformation":{"wKCCommsionInput":"0","visionCommsionInput":"0","sTDCommsionInput":"0","nonBrokerIndicator":"N","medicalCommsionInput":"0","lifeCommsionInput":"0","generalAgentIndicator":"N","dentalCommsionInput":"0","agentTINs":[{"writingTIN":"NOTENTERED","payeeTIN":"NOTENTERED","parentTIN":"NOTENTERED"}]}}';
 		return request;   	
   }     
}