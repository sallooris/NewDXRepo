public with sharing class BRPSGCRealTimeDataModels {

    public class ApplicationStatus
    {
    	public String ein{get;set;} //Required
    	public String appid{get;set;}  //Required
    	public String acn{get;set;}
    	public String caseNumber{get;set;}
    	public String appnStatus{get;set;}    	
    	public String stateCode{get;set;}    	
    	public String underwriterNotes{get;set;}    	
     	public String caseStage{get;set;} //Required
     	public String channel{get;set;} //Required 
     	public String statusUpdateTmstmp{get;set;} //Required  	
        public String enrollmentType{get;set;} //Required  	
    }    

    public class ApplicationCensus 
    {
        public String channelTypeIndicator{get;set;}
        public String groupNumber{get;set;}
        public String groupName{get;set;} //Required
        public String quoteID{get;set;} //Required
        public String groupCoverageDate{get;set;} //Required
        public String sicCode{get;set;} //Required
        public String state{get;set;} //Required
        public String lob{get;set;} //Required
        public String specialty{get;set;} //Required      
        public String userId{get;set;}  //Required            
        public String appnStatus{get;set;} //Required
        public String applicationStatusUpdateDate{get;set;} //Required        
        public String approvalDate{get;set;}   //Required      
        public String underwrtingCarrier{get;set;}
        public String memberCount{get;set;} //Required    
        public String fullTimeCount{get;set;} //Required
        public String partTimeIndicator{get;set;} //Required
        public String partTimeCount{get;set;} //Required
        public String partTimeHours{get;set;} //Required
        public String fullTimeHours{get;set;} //Required
        public String healthcareCount{get;set;} //Required
        public String rateMonths{get;set;}
        public String hRAIndicator{get;set;}        
        public String hCRIndicator{get;set;} //Required
        public String medicarePrimeIndicator{get;set;}
        public String medicareHibID{get;set;}
        public String medicarePartAEffDate{get;set;}
        public String medicarePartBEffDate{get;set;}        
        public String priorDentalCoverageIndicator{get;set;} //Required      
        public String seasonalIndicator{get;set;} //Required       
        public String cobraIndicator{get;set;} //Required                
        public String cobraStartDate{get;set;} //Required
        public String cobraQualifyingEvent{get;set;}   
        public String eOCIndicator{get;set;}   
        public String cdhpIndicator{get;set;}
        public String personalLeaveOfAbsence{get;set;} //Required  
        public String medicalLeaveOfAbsence{get;set;} //Required
        public List<StaffLevel> staffLevel{get;set;}
        public AgentInformation agentInformation{get;set;}
        public List<EnrollmentTypes> enrollmentTypes{get;set;}                            
        public CompanyInformation companyInformation{get;set;}        
        public String sgPremium{get;set;}
        public String isMedicalPresent{get;set;}
        public String isDentalPresent{get;set;}
        public String isVisionPresent{get;set;}
        public String isLnDPresent{get;set;}
        public List<Products> selectedMedicalProducts{get;set;}
        public List<Products> selectedDentalProducts{get;set;}
        public List<Products> selectedVisionProducts{get;set;}      
        public LAndDgroupPremium lAndDgroupPremium{get;set;}
        public List<LnDClasses> lnDClasses{get;set;}
        public String stdemployerContributionRatio{get;set;}
        public String stdemployerContributionAmount{get;set;}
        public String ltdemployerContributionRatio{get;set;}
        public String ltdemployerContributionAmount{get;set;} 
        public List<Subscribers> subscribers{get;set;}
    }

    public class StaffLevel
    {
    	public String sTFLevelCode{get;set;} //Required
    	public String waitMonths{get;set;} //Required
    }
  
    public class AgentInformation
    {
    	public String salesRepName{get;set;}
    	public String salesRepID{get;set;}
    	public String accountManagerID{get;set;}
    	public String accountManagerName{get;set;}
    	public String nonBrokerIndicator{get;set;} //Required
    	public String generalAgentIndicator{get;set;} //Required
    	public String medicalCommsionInput{get;set;} //Required
    	public String dentalCommsionInput{get;set;} //Required
    	public String visionCommsionInput{get;set;} //Required
    	public String lifeCommsionInput{get;set;} //Required
    	public String wKCCommsionInput{get;set;} //Required
    	public String sTDCommsionInput{get;set;} //Required
    	public List<AgentTINs> agentTINs{get;set;}
    }  

    public class AgentTINs
    {
    	public String writingTIN{get;set;} //Required
    	public String payeeTIN{get;set;} //Required
    	public String parentTIN{get;set;} //Required
    	public String brokerPercentage{get;set;}    	
    }      

    public class EnrollmentTypes
    {
    	public String enrollmentType{get;set;}    	
    }

    public class CompanyInformation
    {
    	public String mailPackageTo{get;set;} //Required
    	public Addresses companyAddress{get;set;}
    	public Addresses billingAddress{get;set;} //Required
    	public List<ContactDetails> contactDetails{get;set;}    	
    }
    
    public class Addresses
    {
    	public String zip{get;set;}
    	public String state{get;set;}
    	public String city{get;set;}
    	public String countyCode{get;set;}
    	public String countyName{get;set;}
    	public String streetAddress{get;set;}
    }
    
    public class ContactDetails
    {
    	public String contactEmailAddress{get;set;} //Required
    	public String contactName{get;set;} //Required
    	public String primaryPhone{get;set;} //Required   	
    	public String faxNumber{get;set;} //Required 	
    	public String billingCareOfName{get;set;}    	
    	public String localCareOfName{get;set;}    	
    }
 
    public class Products
    {
    	public String benefitLevel{get;set;} //Required
    	public String benefitLevelCount{get;set;} //Required
    	public String contractCode{get;set;} //Required
    	public String productSubType{get;set;} //Required
    	public String rate{get;set;} //Required
    	public String employerContributionRatio{get;set;} //Required    	
    }
            
    public class LAndDgroupPremium
    {
    	public Boolean lndFlag{get;set;}
    	public String lndRates{get;set;}
    	public String numOfLives{get;set;}
    	public String lndVolume{get;set;}
    	public String lndMonthlyPremiun{get;set;} 	
    }
    
    public class LnDClasses
    {
    	public String lndClass{get;set;}    	
    	public String contractCode{get;set;}
    	public String lndDesc{get;set;}    	
    	public String lndemployerContributionRatio{get;set;}
    	public String lndemployerContributionAmount{get;set;}
    	public String lndOptionalLife{get;set;}
    	public String lndOptionalADnD{get;set;}
    	public String lndOptionalDepLife{get;set;}
    	public String lndOptionalVolLifeContractCodeISG{get;set;}
    	public String lndOptionalVolLifeContractCodeWSG{get;set;}
    	public String lndOptionalVolLifeADnDFlat{get;set;}
    	public String lndOptionalVolLifeADnDMultiplier{get;set;}
    	public String lndOptionalVolLifeADnDMaxBen{get;set;}
    	public String lndOptionalVolLifeEmpLimit{get;set;}
    	public String lndOptionalVolLifeAgeReduction{get;set;}	
    }
    
    public class Subscribers
    {
    	public String subscriberID{get;set;}
    	public String hcID{get;set;}
    	public String firstName{get;set;} //Required
    	public String lastName{get;set;} //Required
    	public String dob{get;set;} //Required
    	public String ssn{get;set;}  //Required
    	public String emailID{get;set;} //Required
    	public String gender{get;set;}
    	public String middleInitial{get;set;}
    	public String addressLine1{get;set;}
    	public String addressLine2{get;set;}
    	public String state{get;set;}
    	public String city{get;set;}
    	public String zipCode{get;set;}
    	public String hireDate{get;set;} 	
    	public String signatureDate{get;set;}
    	public String phoneNumber{get;set;}
    	public String extension{get;set;}
    	public String enrollmentReason{get;set;}
    	public String lastDateOfProbation{get;set;}
    	public String coverageType{get;set;}
    	public String language{get;set;}
    	public String jobTitle{get;set;}
    	public Boolean cob{get;set;}
    	public String departmentNumber{get;set;}
    	public String salary{get;set;}
    	public List<Dependents> dependents{get;set;}
    	public ProductDetails productDetails{get;set;}    	
    }

    public class Dependents
    {
    	public String firstName{get;set;} //Required
    	public String lastName{get;set;} //Required
    	public String dob{get;set;} //Required
    	public String ssn{get;set;}  //Required
    	public String emailID{get;set;} //Required
    	public Boolean gender{get;set;}    	
    	public String dependentStatus{get;set;}
    	public String relationship{get;set;} //Required
    	public ProductDetails productDetails{get;set;}
    }
    
    public class ProductDetails
    {
    	public String empBenefitLevel{get;set;}
    	public String medicalProductCode{get;set;}
    	public String medicalProductName{get;set;}
    	public String medicalProductRate{get;set;}
    	public String primaryCarePhysician{get;set;}
    	public Boolean currentPcp{get;set;}
    	public String dentalProductCode{get;set;}
    	public String dentalProductRate{get;set;}
    	public String dentalProductName{get;set;}
    	public String dentalOffice{get;set;}
    	public String visionProductCode{get;set;}	    	
    	public String visionProductName{get;set;}
    	public String visionProductRate{get;set;}
    	public String lnDClass{get;set;}
    	public String std{get;set;}
    	public String ltd{get;set;}
    	public String basicLife{get;set;}
    	public String basicMultiplier{get;set;}
    	public String basicSubVolume{get;set;}
    	public String basicSpouseVolume{get;set;}
    	public String basicChildVolume{get;set;}
    	public String optionalLife{get;set;}
    	public String optionalMultiplier{get;set;} 	
    	public String optionalSubVolume{get;set;}
    	public String optionalSpouseVolume{get;set;}
    	public String optionalChildVolume{get;set;}
    	public String voluntaryLife{get;set;}
    	public String voluntaryMultiplier{get;set;} 	
    	public String voluntarySubVolume{get;set;}
    	public String voluntarySpouseVolume{get;set;}
    	public String voluntaryChildVolume{get;set;}	
    	public String basicADAndD{get;set;}
    	public String ADAndDBasicMultiplier{get;set;}    	
    	public String ADAndDBasicSubVolume{get;set;}
    	public String ADAndDBasicSpouseVolume{get;set;}
    	public String aDAndDBasicChildVolume{get;set;}
    	public String voluntaryADAndD{get;set;}
    	public String aDAndDVoluntaryMultiplier{get;set;}    	
    	public String aDAndDVoluntarySubVolume{get;set;}
    	public String aDAndDVoluntarySpouseVolume{get;set;}
    	public String aDAndDVoluntaryChildVolume{get;set;}
    	public String optionalADAndD{get;set;}
    	public String aDAndDOptionalMultiplier{get;set;}    	
    	public String aDAndDOptionalSubVolume{get;set;}
    	public String aDAndDOptionalSpouseVolume{get;set;}
    	public String aDAndDOptionalChildVolume{get;set;} 	    	    	    	    	    	
    }

    public class PaymentRequest
    {
    	public PaymentSelection paymentSelection{get;set;}
    }
     
    public class PaymentSelection
    {
    	public List<Payment> initialPayment{get;set;}
    	public String isNoInitPayment{get;set;} //Required
    	public String isRecvPaperlessBillInfo{get;set;} 
    	public String isRecvElectronicCOC{get;set;}  
    	public String emailAddress{get;set;} //Required
    	public String csrIdentifier{get;set;}    	
    }
  
    public class Payment
    {
    	public Integer withdrawDay{get;set;}
    	public String paymentAmt{get;set;} //Required
    	public String paymentType{get;set;} //Required
    	public String billingFrequency{get;set;}  
    	public BillingAddress billingAddr{get;set;}
    	public BankAccount bankAcct{get;set;}    	
    }
    
    public class BillingAddress
    {
    	public String addressLine1{get;set;} //Required 
    	public String addressLine2{get;set;} //Required
    	public String city{get;set;} //Required
    	public String county{get;set;} //Required  
    	public String state{get;set;} //Required
    	public String postalCode{get;set;} //Required    	
    }

    public class BankAccount
    {
    	public String accountNo{get;set;} //Required 
    	public String routingNo{get;set;} //Required
    	public String accountType{get;set;} //Required
    	public String bankName{get;set;}
    	public String accountHolderName{get;set;} //Required
    	public String isRecurring{get;set;} //Required    	
    }

    /*    
    public class MemberCensus
    {
    	public String firstName{get;set;} //Required
    	public String lastName{get;set;} //Required
    	public String dob{get;set;} //Required
    	public String ssn{get;set;} //Required 
    	public String emailID{get;set;} //Required
    	public List<Dependents> dependents{get;set;}  	    	
    }    
    */
}