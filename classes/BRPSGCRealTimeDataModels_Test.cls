@isTest
public class BRPSGCRealTimeDataModels_Test {
    static testmethod void testApplicationStatusDataModels() {
        Test.startTest(); 
        BRPSGCRealTimeDataModels.ApplicationStatus appStatus = new BRPSGCRealTimeDataModels.ApplicationStatus();
    	appStatus.ein='Some Value'; 
    	appStatus.appid='Some Value'; 
    	appStatus.acn='Some Value';
    	appStatus.caseNumber='Some Value';
    	appStatus.appnStatus='Some Value';
    	appStatus.stateCode='Some Value';   	
    	appStatus.underwriterNotes='Some Value';	   	
     	appStatus.caseStage='Some Value'; 
     	appStatus.channel='Some Value'; 
     	appStatus.statusUpdateTmstmp='Some Value';
        Test.stopTest();                  
    }
    
    static testmethod void testApplicationCensusDataModels() {
        Test.startTest(); 
        BRPSGCRealTimeDataModels.ApplicationCensus appCensus = new BRPSGCRealTimeDataModels.ApplicationCensus();

        appCensus.channelTypeIndicator='Some Value'; 
        appCensus.groupNumber='Some Value'; 
        appCensus.groupName='Some Value';  
        appCensus.quoteID='Some Value';  
        appCensus.groupCoverageDate='Some Value';  
        appCensus.sicCode='Some Value';  
        appCensus.state='Some Value';  
        appCensus.lob='Some Value';  
        appCensus.specialty='Some Value';        
        appCensus.userId='Some Value';               
        appCensus.appnStatus='Some Value';  
        appCensus.applicationStatusUpdateDate='Some Value';         
        appCensus.approvalDate='Some Value';          
        appCensus.underwrtingCarrier='Some Value'; 
        appCensus.memberCount='Some Value';      
        appCensus.fullTimeCount='Some Value';  
        appCensus.partTimeIndicator='Some Value';  
        appCensus.partTimeCount='Some Value'; 
        appCensus.partTimeHours='Some Value';  
        appCensus.fullTimeHours='Some Value';  
        appCensus.healthcareCount='Some Value';  
        appCensus.rateMonths='Some Value'; 
        appCensus.hRAIndicator='Some Value';         
        appCensus.hCRIndicator='Some Value';  
        appCensus.medicarePrimeIndicator='Some Value'; 
        appCensus.medicareHibID='Some Value'; 
        appCensus.medicarePartAEffDate='Some Value'; 
        appCensus.medicarePartBEffDate='Some Value';         
        appCensus.priorDentalCoverageIndicator='Some Value';        
        appCensus.seasonalIndicator='Some Value';         
        appCensus.cobraIndicator='Some Value';                  
        appCensus.cobraStartDate='Some Value';  
        appCensus.cobraQualifyingEvent='Some Value';    
        appCensus.eOCIndicator='Some Value';    
        appCensus.cdhpIndicator='Some Value'; 
        appCensus.personalLeaveOfAbsence='Some Value';    
        appCensus.medicalLeaveOfAbsence='Some Value';  
        appCensus.sgPremium='Some Value'; 
        appCensus.isMedicalPresent='Some Value'; 
        appCensus.isDentalPresent='Some Value'; 
        appCensus.isVisionPresent='Some Value'; 
        appCensus.isLnDPresent='Some Value'; 
        appCensus.stdemployerContributionRatio='Some Value'; 
        appCensus.stdemployerContributionAmount='Some Value'; 
        appCensus.ltdemployerContributionRatio='Some Value'; 
        appCensus.ltdemployerContributionAmount='Some Value';  

        List<BRPSGCRealTimeDataModels.StaffLevel> staffLevels = new List<BRPSGCRealTimeDataModels.StaffLevel>();
        BRPSGCRealTimeDataModels.StaffLevel staffLevel = new BRPSGCRealTimeDataModels.StaffLevel();
        staffLevel.sTFLevelCode='Some Value';
        staffLevel.waitMonths='Some Value';
        staffLevels.add(stafflevel);        
        appCensus.staffLevel = staffLevels;	  
              
        BRPSGCRealTimeDataModels.AgentInformation agentInfo = new BRPSGCRealTimeDataModels.AgentInformation();
        appCensus.agentInformation = agentInfo;
        agentInfo.salesRepName='Some Value';
    	agentInfo.salesRepID='Some Value';
    	agentInfo.accountManagerID='Some Value';
    	agentInfo.accountManagerName='Some Value';
    	agentInfo.nonBrokerIndicator='Some Value';     
        agentInfo.nonBrokerIndicator='Some Value';
        agentInfo.generalAgentIndicator='Some Value';            
        agentInfo.medicalCommsionInput='Some Value';
        agentInfo.dentalCommsionInput='Some Value';
        agentInfo.visionCommsionInput='Some Value';
        agentInfo.lifeCommsionInput='Some Value';
        agentInfo.wKCCommsionInput='Some Value';
        agentInfo.sTDCommsionInput='Some Value';
            
        //AgentTins
        List<BRPSGCRealTimeDataModels.AgentTINs> agentTINs = new List<BRPSGCRealTimeDataModels.AgentTINs>();             	            
        BRPSGCRealTimeDataModels.AgentTINs agentTIN = new BRPSGCRealTimeDataModels.AgentTINs();	            
        agentTIN.writingTIN='Some Value'; 
        agentTIN.payeeTIN='Some Value';
        agentTIN.parentTIN='Some Value';
        agentTIN.brokerPercentage='Some Value';
                      	    
        agentTINs.add(agentTIN);
        agentInfo.AgentTINs = agentTINs;	
        
        List<BRPSGCRealTimeDataModels.EnrollmentTypes> enrollTypes = new List<BRPSGCRealTimeDataModels.EnrollmentTypes>();
        BRPSGCRealTimeDataModels.EnrollmentTypes enrollType = new BRPSGCRealTimeDataModels.EnrollmentTypes();
        enrollType.enrollmentType='Some Value';
        enrollTypes.add(enrollType);  
        appCensus.enrollmentTypes = enrollTypes; 
             
        BRPSGCRealTimeDataModels.CompanyInformation companyInfo = new BRPSGCRealTimeDataModels.CompanyInformation();
        BRPSGCRealTimeDataModels.CompanyInformation companyInformation = new BRPSGCRealTimeDataModels.CompanyInformation();
        appCensus.companyInformation = companyInformation;	            	            
        companyInformation.mailPackageTo='Some Value';
            
        BRPSGCRealTimeDataModels.Addresses billingAddress = new BRPSGCRealTimeDataModels.Addresses();	
        companyInformation.billingAddress = billingAddress;
        companyInformation.companyaddress = billingAddress;	                        
       	billingAddress.zip='Some Value';
       	billingAddress.state='Some Value';
       	billingAddress.city='Some Value';
        billingAddress.streetAddress='Some Value';            	
        billingAddress.countyCode='Some Value';
        billingAddress.countyName='Some Value';
        
        List<BRPSGCRealTimeDataModels.ContactDetails> contactDetails = new List<BRPSGCRealTimeDataModels.ContactDetails>();	            
        BRPSGCRealTimeDataModels.ContactDetails contactDetail = new BRPSGCRealTimeDataModels.ContactDetails();
        contactDetail.contactEmailAddress='Some Value';
        contactDetail.contactName='Some Value';
        contactDetail.primaryPhone='Some Value';
        contactDetail.faxNumber='Some Value';
        contactDetail.billingCareOfName='Some Value';
        contactDetail.localCareOfName='Some Value';
        
        contactDetails.add(contactDetail);
        companyInformation.contactDetails = contactDetails;
        
	    List<BRPSGCRealTimeDataModels.Products> products = new List<BRPSGCRealTimeDataModels.Products>();             	            
	    BRPSGCRealTimeDataModels.Products product = new BRPSGCRealTimeDataModels.Products();
	    product.benefitLevel='Some Value';
        product.benefitLevelCount='Some Value';
        product.contractCode='Some Value';
        product.productSubType='Some Value';
        product.rate='Some Value';
        product.employerContributionRatio='Some Value';            
	    products.add(product);
	    appCensus.selectedMedicalProducts = products;		            	            
	    appCensus.selectedDentalProducts = products;	
        appCensus.selectedVisionProducts = products;
        
        List<BRPSGCRealTimeDataModels.Subscribers> subscribers = new List<BRPSGCRealTimeDataModels.Subscribers>();             	            
        BRPSGCRealTimeDataModels.Subscribers subscriber = new BRPSGCRealTimeDataModels.Subscribers();
        subscribers.add(subscriber);
        appCensus.subscribers = subscribers;	            
        subscriber.subscriberID='Some Value';
        subscriber.hcID='Some Value';        
        subscriber.firstName='Some Value';
        subscriber.lastName='Some Value';
        subscriber.dob='Some Value';
        subscriber.ssn='Some Value';
        subscriber.emailID='Some Value';	            
	            
        List<BRPSGCRealTimeDataModels.Dependents> dependents = new List<BRPSGCRealTimeDataModels.Dependents>();             	            
        BRPSGCRealTimeDataModels.Dependents dependent = new BRPSGCRealTimeDataModels.Dependents();	            
        dependents.add(dependent);
        subscriber.dependents = dependents;
        dependent.firstName='Some Value';
        dependent.lastName='Some Value';
        dependent.dob='Some Value';
        dependent.ssn='Some Value';
        dependent.emailID='Some Value';
        dependent.gender=false;          	            	            
        dependent.dependentStatus='Some Value';  
        dependent.relationship='Some Value';  
                        
        BRPSGCRealTimeDataModels.LAndDgroupPremium lAndD = new BRPSGCRealTimeDataModels.LAndDgroupPremium();
    	lAndD.lndFlag=false;
    	lAndD.lndRates='Some Value';
    	lAndD.numOfLives='Some Value';
    	lAndD.lndVolume='Some Value';
    	lAndD.lndMonthlyPremiun='Some Value'; 	
    	appCensus.lAndDgroupPremium = lAndD;
        
        List<BRPSGCRealTimeDataModels.LnDClasses> lnDClasses = new List<BRPSGCRealTimeDataModels.LnDClasses>();
        BRPSGCRealTimeDataModels.LnDClasses lnDClass = new BRPSGCRealTimeDataModels.LnDClasses();
        lnDClasses.add(lnDClass);
    	lnDClass.lndClass='Some Value';    	
    	lnDClass.contractCode='Some Value';
    	lnDClass.lndDesc='Some Value';    	
    	lnDClass.lndemployerContributionRatio='Some Value';
    	lnDClass.lndemployerContributionAmount='Some Value';
    	lnDClass.lndOptionalLife='Some Value';
    	lnDClass.lndOptionalADnD='Some Value';
    	lnDClass.lndOptionalDepLife='Some Value';
    	lnDClass.lndOptionalVolLifeContractCodeISG='Some Value';
    	lnDClass.lndOptionalVolLifeContractCodeWSG='Some Value';
    	lnDClass.lndOptionalVolLifeADnDFlat='Some Value';
    	lnDClass.lndOptionalVolLifeADnDMultiplier='Some Value';
    	lnDClass.lndOptionalVolLifeADnDMaxBen='Some Value';
    	lnDClass.lndOptionalVolLifeEmpLimit='Some Value';
    	lnDClass.lndOptionalVolLifeAgeReduction='Some Value';	
        appCensus.lnDClasses= lnDClasses;       
        
        BRPSGCRealTimeDataModels.ProductDetails prodDetail = new BRPSGCRealTimeDataModels.ProductDetails();
    	prodDetail.empBenefitLevel='Some Value';
    	prodDetail.medicalProductCode='Some Value';
    	prodDetail.medicalProductName='Some Value';
    	prodDetail.medicalProductRate='Some Value';
    	prodDetail.primaryCarePhysician='Some Value';
    	prodDetail.currentPcp=false;
    	prodDetail.dentalProductCode='Some Value';
    	prodDetail.dentalProductRate='Some Value';
    	prodDetail.dentalProductName='Some Value';
    	prodDetail.dentalOffice='Some Value';
    	prodDetail.visionProductCode='Some Value';	    	
    	prodDetail.visionProductName='Some Value';
    	prodDetail.visionProductRate='Some Value';
    	prodDetail.lnDClass='Some Value';
    	prodDetail.std='Some Value';
    	prodDetail.ltd='Some Value';
    	prodDetail.basicLife='Some Value';
    	prodDetail.basicMultiplier='Some Value';
    	prodDetail.basicSubVolume='Some Value';
    	prodDetail.basicSpouseVolume='Some Value';
    	prodDetail.basicChildVolume='Some Value';
    	prodDetail.optionalLife='Some Value';
    	prodDetail.optionalMultiplier='Some Value'; 	
    	prodDetail.optionalSubVolume='Some Value';
    	prodDetail.optionalSpouseVolume='Some Value';
    	prodDetail.optionalChildVolume='Some Value';
    	prodDetail.voluntaryLife='Some Value';
    	prodDetail.voluntaryMultiplier='Some Value'; 	
    	prodDetail.voluntarySubVolume='Some Value';
    	prodDetail.voluntarySpouseVolume='Some Value';
    	prodDetail.voluntaryChildVolume='Some Value';	
    	prodDetail.basicADAndD='Some Value';
    	prodDetail.ADAndDBasicMultiplier='Some Value';    	
    	prodDetail.ADAndDBasicSubVolume='Some Value';
    	prodDetail.ADAndDBasicSpouseVolume='Some Value';
    	prodDetail.aDAndDBasicChildVolume='Some Value';
    	prodDetail.voluntaryADAndD='Some Value';
    	prodDetail.aDAndDVoluntaryMultiplier='Some Value';    	
    	prodDetail.aDAndDVoluntarySubVolume='Some Value';
    	prodDetail.aDAndDVoluntarySpouseVolume='Some Value';
    	prodDetail.aDAndDVoluntaryChildVolume='Some Value';
    	prodDetail.optionalADAndD='Some Value';
    	prodDetail.aDAndDOptionalMultiplier='Some Value';    	
    	prodDetail.aDAndDOptionalSubVolume='Some Value';
    	prodDetail.aDAndDOptionalSpouseVolume='Some Value';
    	prodDetail.aDAndDOptionalChildVolume='Some Value'; 	    	    	    	    	    	
        subscriber.productDetails= prodDetail;
        dependent.productDetails= prodDetail;
         	        
        Test.stopTest();                  
    }
    
    static testmethod void testPaymentDataModels() {
        Test.startTest(); 
        BRPSGCRealTimeDataModels.PaymentRequest paymentReq = new BRPSGCRealTimeDataModels.PaymentRequest();
        BRPSGCRealTimeDataModels.PaymentSelection paymentSel = new BRPSGCRealTimeDataModels.PaymentSelection();
        paymentReq.paymentSelection = paymentSel;
                
        List<BRPSGCRealTimeDataModels.Payment> payments = new List<BRPSGCRealTimeDataModels.Payment>();
        paymentSel.initialPayment = payments;
        paymentSel.isNoInitPayment='Some Value';
        paymentSel.isRecvPaperlessBillInfo='Some Value';
        paymentSel.isRecvElectronicCOC='Some Value';
        paymentSel.emailAddress='Some Value';
        paymentSel.csrIdentifier='Some Value';
                
        BRPSGCRealTimeDataModels.Payment payment = new BRPSGCRealTimeDataModels.Payment();
        payments.add(payment);
        payment.withdrawDay= 1;
        payment.paymentAmt='Some Value';
        payment.paymentType='Some Value';
        payment.billingFrequency='Some Value'; 
                
        BRPSGCRealTimeDataModels.BillingAddress billAddress = new BRPSGCRealTimeDataModels.BillingAddress();
        payment.billingAddr = billAddress;
        billAddress.addressLine1='Some Value';
        billAddress.addressLine2='Some Value';
        billAddress.city='Some Value';
        billAddress.county='Some Value';
        billAddress.state='Some Value';
        billAddress.postalCode='Some Value';
                                        
        BRPSGCRealTimeDataModels.BankAccount bankAccount = new BRPSGCRealTimeDataModels.BankAccount();
        payment.bankAcct = bankAccount;
        bankAccount.accountNo='Some Value';
        bankAccount.routingNo='Some Value';
        bankAccount.accountType='Some Value';
        bankAccount.bankName='Some Value';
        bankAccount.accountHolderName='Some Value';
        bankAccount.isRecurring='Some Value';
                
        Test.stopTest();                  
    }    
}