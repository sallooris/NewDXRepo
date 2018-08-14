public class BRPUtilTestMethods {

public static User CreateTestUser(){
        Profile txtProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' Limit 1]; 
        User tstUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                           LocaleSidKey='en_US', ProfileId = txtProfile.Id, 
                                           TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg111.com');
    return tstUser;
}
      public static Account CreateAgencyAccount(){
        List<RecordType> recList = [SELECT id FROM RECORDTYPE WHERE Name = 'Agency' AND sObjectType = 'Account'];
        Account  testAccount = new Account(Name='TestAgency');
        testAccount.RecordTypeId = recList[0].Id;
        
    return testAccount;
    }
       public static SmallGroupSIC__c CreateSIC(){
        SmallGroupSIC__c testSIC = new SmallGroupSIC__c (SIC_CODE__c='123',Name ='123');     
           
        return testSIC ;
    }
    public static BRPSGCIntegration__c createBRPSGCIntegration(){
        BRPSGCIntegration__c testSGCInt = new BRPSGCIntegration__c();
        testSGCInt.Name= 'SGC';
        testSGCInt.Apikey__c = 'ABC';
        testSGCInt.CreateApplication__c = 'http://createApplication';
        testSGCInt.CreateDocument__c = 'http://createdocument';
        testSGCInt.EndPointURL__c = 'http://accesstoken';
        testSGCInt.Get_Applications_Status__c = 'http://applicationstatus';
        testSGCInt.CreateApplicationStatus__c = 'http://createAppStatus';
        testSGCInt.GetDocumentsList__c = 'http://getdocstatus';
        testSGCInt.Host__c = 'ABC';
        testSGCInt.OauthCustomerKeys__c = 'ABC';
        testSGCInt.ReqBody__c = 'ABC';
        return testSGCInt;
    }
    public static vlocity_ins__Party__c CreateParty(String accntId){
        vlocity_ins__Party__c testParty = new vlocity_ins__Party__c ();
        testParty.vlocity_ins__AccountId__c = accntId;
        return testParty;
    }
 public static Account CreateGroupAccount(){
        List<RecordType> recList = [SELECT id FROM RECORDTYPE WHERE Name = 'Group' AND sObjectType = 'Account'];
        Account  testAccount = new Account(Name='TestSmallGroup');
        testAccount.RecordTypeId = recList[0].Id;
        testAccount.Employer_EIN__c = '012345678';
        testAccount.BillingState = 'NY';
        testAccount.Sic = '123';
        return testAccount;
    }
        public static Opportunity CreateOpportunity (Account tstAccount){
        Opportunity o = new Opportunity();

        o.Accountid = tstAccount.id;
        o.Name = 'testForSGC';
//        o.RecordTypeId = '01255000000CoYbAAK';
        o.CloseDate = Date.Today();
        o.stagename='Opportunity';
 //       o.StageName = 'Opportunity';
        o.Tech_Businesstrack__c = 'SG Quoting';
        return o;
        }
    public static Quote CreateQuote(Account tstAccount,Opportunity o){
        Quote q = new Quote();
        q.name = 'Quote- TEST ACCOUNT';
        q.opportunityId = o.id;
         return q;
        }

    public static List<QuoteLineItem> CreateQuoteLineItemForPDF (Quote qt){
        List<QuoteLineItem> listval = new   List<QuoteLineItem>();
        String stdPriceId = Test.getStandardPricebookId();
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true );
        insert pb;
        pb = [select id, name, isActive from Pricebook2 where Name = 'Standard Price Book 2009'];
        qt.Pricebook2Id = pb.id;
           qt.vlocity_ins__EffectiveDate__c = Date.today();   

        update qt;

//Medical
        Product2 medprod = new Product2(Name = 'Anti-infectives 2007', Family = 'Best Practices', vlocity_ins__Type__c='Medical',  IsActive = true);
        insert medprod;
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = stdPriceId, Product2Id = medprod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = medprod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert pbe;        
        pbe = [select id from PricebookEntry where Product2Id = :medprod.Id and Pricebook2Id = :pb.Id];        
        Integer Annualvalue = 1000 ;
        QuoteLineItem qutlineitemtest = new QuoteLineItem ();
        qutlineitemtest = new QuoteLineItem(QuoteId = qt.id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = pbe.id);        
        insert qutlineitemtest;
        listval.add(qutlineitemtest); 
// Dental
        Product2 denprod = new Product2(Name = 'Anti-infectives 2007', Family = 'Best Practices', vlocity_ins__Type__c='Dental',  IsActive = true);
        insert denprod ;
        standardPrice = new PricebookEntry(Pricebook2Id = stdPriceId, Product2Id = denprod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
        pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = denprod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert pbe;        
        pbe = [select id from PricebookEntry where Product2Id = :denprod.Id and Pricebook2Id = :pb.Id];        
        Annualvalue = 1000 ;
        qutlineitemtest = new QuoteLineItem ();
        qutlineitemtest = new QuoteLineItem(QuoteId = qt.id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = pbe.id);        
        insert qutlineitemtest;
        listval.add(qutlineitemtest); 
// Vision
        Product2 visprod = new Product2(Name = 'Anti-infectives 2007', Family = 'Best Practices',  vlocity_ins__Type__c='Vision', IsActive = true);
        insert visprod ;
        standardPrice = new PricebookEntry(Pricebook2Id = stdPriceId, Product2Id = visprod .Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
        pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = visprod .Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert pbe;        
        pbe = [select id from PricebookEntry where Product2Id = :visprod .Id and Pricebook2Id = :pb.Id];        
        Annualvalue = 1000 ;
        qutlineitemtest = new QuoteLineItem ();
        qutlineitemtest = new QuoteLineItem(QuoteId = qt.id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = pbe.id);        
        insert qutlineitemtest;

        listval.add(qutlineitemtest); 
        return listval;     
     }

     public static List<QuoteLineItem> CreateQuoteLineItem (Quote qt){
         List<QuoteLineItem> listval = new   List<QuoteLineItem>();
         /*
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true );
        insert pb;
        Product2 prod = new Product2(Name = 'Testing Product', Family = 'Best Practices', IsActive = true);
        insert prod;

        List<Pricebook2> standardPbList = [select id, name, isActive from Pricebook2 ];
        List<PricebookEntry> listPriceBook = new List<PricebookEntry>();
        for(Pricebook2 p : standardPbList ){
            PricebookEntry pbe = New PricebookEntry ();
            pbe = new PricebookEntry(Pricebook2Id = p.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
            listPriceBook.add(pbe);
         }
        List<QuoteLineItem> listval = new   List<QuoteLineItem>();
        Integer Annualvalue = 1000 ;
        for(PricebookEntry pricebook : listPriceBook){
            QuoteLineItem qutlineitemtest = new QuoteLineItem ();
            qutlineitemtest = new QuoteLineItem(QuoteId = qt.id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = pricebook.id);        
            insert qutlineitemtest;
            Annualvalue = Annualvalue + 1000;
        } */
     return listval;     
     }
     public static Attachment createAttachment(String parent, String content,String fileName){
     if(content == null) content = '<HTML><BODY>SAMPLE DOCUMENT FOR TESTING</BODY></HTML>';
     Attachment  attachmentPDF = new Attachment();
        try
        {            
            attachmentPDF.parentId = parent;
            attachmentPDF.ContentType = 'application/pdf';            
            attachmentPDF.Name = fileName;
            attachmentPDF.Description = content;            
            attachmentPDF.body = Blob.toPDF(content); //This creates the PDF content
        }catch(Exception e)
        {
           System.debug('Exception - '+e.getMessage());
        }
        return attachmentPDF;     
     }
     public static vlocity_ins__Application__c getApplication(String AppId ){
     vlocity_ins__Application__c vloApp = [select SGC_Application_Status__c, Application_Number__c, vlocity_ins__PrimaryPartyId__c, Account_Employer_EIN__c, Account_Name__c, Account_State__c, Paid_Agency_ETIN__c, Parent_Agency_ETIN__c, WritingAgentETIN__c, Specialty_Indicator__c, Group_Coverage_Date__c, Member_Count__c, vlocity_ins__JSONData__c, vlocity_ins__PrimaryApplicantLink__c, vlocity_ins__ApplicationReferenceNumber__c, vlocity_ins__Status__c, vlocity_ins__Summary__c, vlocity_ins__Type__c, vlocity_ins__OwnerLink__c from vlocity_ins__Application__c where Id=:AppId LIMIT 1];
     return vloApp;
     }

     public static vlocity_ins__Application__c createApplication(String accntId, String quoteId){
     String JSONStr = 'JSON:"ABC":"DRId_Quote":"'+quoteId+'","WELCOME"';
     vlocity_ins__Application__c appl;
     String partyId;
        try
        {    
            List<vlocity_ins__Party__c > recList = [SELECT id FROM vlocity_ins__Party__c WHERE vlocity_ins__AccountId__c = :accntId];
            if(recList.size()>0){
                vlocity_ins__Party__c party = recList[0];
                partyId = party.Id;
             }
            System.debug('partyId - '+partyId);
            appl = new vlocity_ins__Application__c ();
            appl.vlocity_ins__JSONData__c = JSONStr;
            appl.Name= accntId+'-TEST APPL';
            appl.vlocity_ins__Status__c = 'Application Sent for Signature'; 
            appl.Paid_Agency_ETIN__c = '012345678';
            appl.Parent_Agency_ETIN__c= '012345678';
            appl.WritingAgentETIN__c = '012345678';
            appl.Census_Form__c='Submitted';
            appl.Employer_Application__c='Not Submitted';
            appl.Employee_App_PDF__c='Not Submitted';
            appl.Quote__c='Not Submitted';
            appl.Form_941__c='Not Submitted';
            appl.Form_NYS_45__c='Not Submitted';
            appl.HRA__c='Not Submitted';
            appl.Payroll_Document__c='Not Submitted';
            appl.SGC_Application_Status__c='Failed';
            appl.SGC_Document_Status__c='SUCCESS';
            appl.Payment_Form__c='Not Submitted';
            appl.Quarterly_Tax_Filing__c='Not Submitted';
            appl.Voided_Check__c='Not Submitted';
            appl.vlocity_ins__PrimaryPartyId__c= partyId;            
        }catch(Exception e)
        {
           System.debug('Exception - '+e.getMessage());
       }
        return appl;     
     }
    public static List<CS001_RecordTypeBusinessTrack__c> createCS001Data(){
    CS001_RecordTypeBusinessTrack__c cs001 = new CS001_RecordTypeBusinessTrack__c ();
    cs001.name = 'Account_Person Account';
    cs001.BusinessTrackName__c = System.label.Telesales;
 
    CS001_RecordTypeBusinessTrack__c cs002 = new CS001_RecordTypeBusinessTrack__c ();
    cs002.name = 'Lead_TS MASTER';
    cs002.BusinessTrackName__c = System.label.Telesales;
    CS001_RecordTypeBusinessTrack__c cs003 = new CS001_RecordTypeBusinessTrack__c ();
    cs003.name = 'Opportunity_TS MASTER';    
    cs003.BusinessTrackName__c = System.label.Telesales;
    CS001_RecordTypeBusinessTrack__c cs004 = new CS001_RecordTypeBusinessTrack__c ();
    cs004.name = 'Task_Send Fulfillment';
    cs004.BusinessTrackName__c = System.label.Telesales;
    CS001_RecordTypeBusinessTrack__c cs005 = new CS001_RecordTypeBusinessTrack__c ();
    cs005.name = 'Task_Schedule Followup';
    cs005.BusinessTrackName__c = System.label.Telesales;
    CS001_RecordTypeBusinessTrack__c cs006 = new CS001_RecordTypeBusinessTrack__c ();
    cs006.name = 'Task_Inbound/Outbound Call Activity';
    cs006.BusinessTrackName__c = System.label.Telesales;
    CS001_RecordTypeBusinessTrack__c cs007 = new CS001_RecordTypeBusinessTrack__c ();
    cs007.name = 'Opportunity_Closed Won/Lost';
    cs007.BusinessTrackName__c = System.label.Telesales;
    CS001_RecordTypeBusinessTrack__c cs008 = new CS001_RecordTypeBusinessTrack__c ();
    cs008.name = 'Campaign_TS MASTER';
    cs008.BusinessTrackName__c = System.label.Telesales;
    CS001_RecordTypeBusinessTrack__c cs009 = new CS001_RecordTypeBusinessTrack__c ();
    cs009.name = 'Account_Business Account';
    cs009.BusinessTrackName__c = System.label.Telesales;
    CS001_RecordTypeBusinessTrack__c cs010 = new CS001_RecordTypeBusinessTrack__c ();
    cs010.name = 'Opportunity_BROKER';
    cs010.BusinessTrackName__c = 'BROKER';
     CS001_RecordTypeBusinessTrack__c cs011 = new CS001_RecordTypeBusinessTrack__c ();
    cs011.name = 'Account_Group';
    cs011.BusinessTrackName__c = 'Group';
    List<CS001_RecordTypeBusinessTrack__c> cs001List = new List<CS001_RecordTypeBusinessTrack__c>();
    cs001List.add(cs001);
    cs001List.add(cs002);
    cs001List.add(cs003);
    cs001List.add(cs004);
    cs001List.add(cs005);
    cs001List.add(cs006);
    cs001List.add(cs007);
    cs001List.add(cs008);
    cs001List.add(cs009);
    cs001List.add(cs010);
    cs001List.add(cs011);  
    return cs001List;
 }
 public static Attachment getAttchmentObj (String id)
 {
     Attachment att = [Select Id, Body, BodyLength, ContentType,Description,Name,ParentId,OwnerId From Attachment where Id=:id];
     return att;
 }
 
  public static OAuthRESTAPIToken__c CreateAuth()
 {
            OAuthRESTAPIToken__c oAuthTabl = new OAuthRESTAPIToken__c();
            oAuthTabl.OAuthToken__c = 'SOMEAUTH';
            oAuthTabl.Name = 'OAuthForSGC';
            return oAuthTabl;
 }
 
     public static vlocity_ins__Application__c GetApplicationObject(String applicationId)
    {
        vlocity_ins__Application__c applObj = [SELECT 
            Application_Number__c,
            Account_Name__c,
            Account_State__c,
            vlocity_ins__PrimaryPartyId__c,
            Account_Employer_EIN__c,
            vlocity_ins__JSONData__c, 
            Employer_Application__c,
            Quote__c,
            vlocity_ins__Status__c,
            vlocity_ins__Type__c, 
            Payment_Form__c,
            HRA__c,
            Id,
            Name
            FROM vlocity_ins__Application__c  
        WHERE Id =:applicationId LIMIT 1];
    return applObj;
    }

  public static List<CS002_RTypeAssignOnLeadConvert__c> createCS002Data(){
    ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;  
    ID accAG =[select Id,Name from Recordtype where Name = 'Group' and SobjectType = 'Account'].Id;   
    ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id;  
    ID accOppsRT =[select Id,Name from Recordtype where Name = 'Anthem Opps' and SobjectType = 'Account'].Id;   
    ID oppOppsRT =[select Id,Name from Recordtype where Name = 'Anthem Opps' and SobjectType = 'Opportunity'].Id; 
    ID oppOppsBRK =[select Id,Name from Recordtype where Name = 'SG Quoting' and SobjectType = 'Opportunity'].Id; 
    
    CS002_RTypeAssignOnLeadConvert__c cs001 = new CS002_RTypeAssignOnLeadConvert__c ();
    cs001.name = 'Account_TELESALES';
    cs001.RecordTypeID__c = accRT;

    CS002_RTypeAssignOnLeadConvert__c cs006 = new CS002_RTypeAssignOnLeadConvert__c ();
    cs006.name = 'Account_Group';
    cs006.RecordTypeID__c = accAG ;


    
    CS002_RTypeAssignOnLeadConvert__c cs002 = new CS002_RTypeAssignOnLeadConvert__c ();
    cs002.name = 'Opportunity_TELESALES';
    cs002.RecordTypeID__c = oppRT;
    CS002_RTypeAssignOnLeadConvert__c cs003 = new CS002_RTypeAssignOnLeadConvert__c ();
    cs003.name = 'Account_ANTHEMOPPS';
    cs003.RecordTypeID__c = accOppsRT;
    CS002_RTypeAssignOnLeadConvert__c cs004 = new CS002_RTypeAssignOnLeadConvert__c ();
    cs004.name = 'Opportunity_ANTHEMOPPS';
    cs004.RecordTypeID__c = oppOppsRT;

    CS002_RTypeAssignOnLeadConvert__c cs005 = new CS002_RTypeAssignOnLeadConvert__c ();
    cs005.name = 'Opportunity_BROKER';
    cs005.RecordTypeID__c = oppOppsBRK;


    List<CS002_RTypeAssignOnLeadConvert__c> cs001List = new List<CS002_RTypeAssignOnLeadConvert__c>();
    cs001List.add(cs001);
    cs001List.add(cs002);
    cs001List.add(cs003);
    cs001List.add(cs004);
    cs001List.add(cs005);
    cs001List.add(cs006);
    
    return cs001List;
 }
   public static vlocity_ins__Application__c createApplicationToSendToSGC(String accntId, String quoteId){
     String JSONStr = 'JSON:"ABC":"DRId_Quote":"'+quoteId+'","WELCOME"';
     vlocity_ins__Application__c appl;
     String partyId;
        try
        {    
            List<vlocity_ins__Party__c > recList = [SELECT id FROM vlocity_ins__Party__c WHERE vlocity_ins__AccountId__c = :accntId];
            if(recList.size()>0){
                vlocity_ins__Party__c party = recList[0];
                partyId = party.Id;
             }
            System.debug('partyId - '+partyId);
            appl = new vlocity_ins__Application__c ();
            appl.vlocity_ins__JSONData__c = ''; //JSONStr;
            appl.Name= accntId+'-TEST APPL';
            appl.vlocity_ins__Status__c = 'Application Sent for Signature'; 
            appl.Paid_Agency_ETIN__c = '012345678';
            appl.Parent_Agency_ETIN__c= '012345678';
            appl.WritingAgentETIN__c = '012345678';
            appl.Census_Form__c='Submitted';
            appl.Employer_Application__c='Not Submitted';
            appl.Employee_App_PDF__c='Not Submitted';
            appl.Quote__c='Not Submitted';
            appl.Form_941__c='Not Submitted';
            appl.Form_NYS_45__c='Not Submitted';
            appl.HRA__c='Not Submitted';
            appl.Payroll_Document__c='Not Submitted';
            appl.SGC_Application_Status__c='FAILED';
            appl.SGC_Document_Status__c='SUCCESS';
            appl.Payment_Form__c='Not Submitted';
            appl.Quarterly_Tax_Filing__c='Not Submitted';
            appl.Voided_Check__c='Not Submitted';
                       
            appl.vlocity_ins__PrimaryPartyId__c= partyId;            
        }catch(Exception e)
        {
           System.debug('Exception - '+e.getMessage());
       }
        return appl;     
     }
     
     public static Case createCaseToSendToSGC(String accntId, String appId){
     Case caseObj = new Case();
        try
        {               
            caseObj = new Case();            
            caseObj.AccountId = accntId;
            caseObj.Application_Name__c = appId;
            caseObj.Stage__c = 'Case/Group Number Assigned';
        }catch(Exception e)
        {
           System.debug('Exception - '+e.getMessage());
       }
        return caseObj;     
     }
     
}