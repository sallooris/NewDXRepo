/**********************************************************************************
Class Name :   SGA_AP11_GenerateAndAttachQuotePDF
Date Created : 12-June-2017
Created By   : IDC Offshore
Description  : 1. This class is used to generate and attach the quote to quote record 
				  in notes and attachments section. 
			   2. This class is called from OmniScript
Change History : 
*************************************************************************************/
public with sharing class SGA_AP11_GenerateAndAttachQuotePDF {
    private final Quote q;
    ApexPages.StandardController controller;
    public static boolean isItfromOmniScript = false; 
    public static Quote allQuote{get;set;}
    public static Account acct{get;set;}
    public static List<QuoteLineItem> qli{get;set;}
    public static Map<String, List<Assignment_Attribute_Mapping__c>> aahMap{get;set;}
    public static Map<String, String> headerMap{get;set;}
    public static final String SHARE_TYPE = 'V';
    //map to be used to reference Quote PDF Section records
    public Map<String, String> pdfContentMap {get; set;}
    
    //for logo name
    public static String d{get;set;}
    public static String pictureName{get;set;}
    public static String borderUpper{get;set;}
    public static String bigPicture{get;set;}
    public static String empireLogo{get;set;}
    public static String signature{get;set;}
    
    public static Quote_PDF_Template__c pdfTemplate{get;set;}
    public static List<Quote_PDF_Section__c> pdfSection{get;set;}
    
    //for displaying the value
    public static List<DisplayWrapper> displayMedical1{get;set;}
    public static List<DisplayWrapper> displayMedical2{get;set;}
    public static List<DisplayWrapper> displayMedical3{get;set;}
    public static List<DisplayWrapper> displayMedicalAll{get;set;}
    public static List<DisplayWrapper> displayDental{get;set;}
    public static List<DisplayWrapper> displayVision{get;set;}
    public static String accId{get;set;}
    public static Boolean renDental{get;set;}
    public static Boolean renVision{get;set;}
    public static Boolean renMedical{get;set;}
    
    public Date ed {get; set;}
    public String county{get;set;}
    /**
    * Constructor of the Class. Get the Quote record
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public SGA_AP11_GenerateAndAttachQuotePDF(ApexPages.StandardController stdController){

        controller = stdController;
        //commented this code as it we are passing the controller values from Omniscript class
       /* if(!Test.isRunningTest() && !isItfromOmniScript) {
            controller.addFields(new List<String>{'Coverage_Options__c', 'Brand__c', 'vlocity_ins__EffectiveDate__c'});
        }*/
        q = (Quote)controller.getRecord();
        headerMap = new Map<String, String>();
        aahMap = new Map<String, List<Assignment_Attribute_Mapping__c>>();
        Map<String, String> page10Map = new Map<String, String>();
        Map<String, String> page2Map = new Map<String, String>();
        
        //get all the Assignment Attribute Mapping
        List<Assignment_Attribute_Mapping__c> aah = new List<Assignment_Attribute_Mapping__c>([SELECT Name,Type__c, Name_Header__c FROM Assignment_Attribute_Mapping__c ORDER BY LastModifiedDate ASC NULLS FIRST]);
        
        //Seperate Assignment Attribute Mapping by their type.
        for(Assignment_Attribute_Mapping__c aahCustom : aah){
            //headerMap.put(aahCustom.Name, aahCustom.Name_Header__c);
            if(aahMap.containskey(aahCustom.Type__c)){
                aahMap.get(aahCustom.Type__c).add(aahCustom);
            }else{
                List<Assignment_Attribute_Mapping__c> aahList= new List<Assignment_Attribute_Mapping__c>();
                aahList.add(aahCustom);
                aahMap.put(aahCustom.Type__c , aahList);
            }
            if(aahCustom.Type__c == SG01_Constants.QUOTE_PDF_IMG){
                pictureName = aahCustom.Name_Header__c;
            }
        }
        
        //get some required field of quote to display in pdf
        //allQuote = [SELECT Id, Brand__c,vlocity_ins__EffectiveDate__c FROM Quote WHERE Id =: q.Id];
        //if(allQuote !=null){
        //Date 
        ed = date.newinstance(q.vlocity_ins__EffectiveDate__c.year(), q.vlocity_ins__EffectiveDate__c.month(), q.vlocity_ins__EffectiveDate__c.day());
        d = String.ValueOf(ed);
        empireLogo();
        // }
        // method to map all attribute and separte it by Type
        allAttribute();
        pageControl();
        //get the account id from quote
        accId = [SELECT AccountId FROM Quote WHERE Id=: q.Id].AccountId;
        if(accId != SG01_Constants.BLANK){
            acctFromQuote();
        }
        
        //get all the Quote pdf section for the footer and text are of the pdf.
        pdfSection = [SELECT Name, Type__c, Content__c FROM Quote_PDF_Section__c ORDER BY LastModifiedDate ASC NULLS FIRST];
        if(!pdfSection.isEmpty()){
            //footer();
            //textPage();
            buildPDFContentMap();
        }
    }
    /**
    * Query all required fields of quote.
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    private void acctFromQuote(){
        try{
            acct = [SELECT Agency__c,BillingPostalCode,BillingCountry,BillingState, Name , SIC FROM Account WHERE Id = : accId];
            if(acct != null && acct.billingPostalCode != null)
            {
                List<Zip_City_County__c> zip_County = [select County__c from Zip_City_County__c where Name =:acct.BillingPostalCode];//.County__c;
                if(zip_County != null && zip_County.size() > 0)
                {
                    county = zip_county[0].County__c;
                }
            }
        } catch(exception e){
            q.addError(e);
        }
    }
    
    
    /**
    * Creates a map of all Quote PDF Section records
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    private void buildPDFContentMap(){
        pdfContentMap = new Map<String, String>();
        for(Quote_PDF_Section__c  pdfS : pdfSection){
            //to handle null value
            if(pdfS.Content__c != null) {
                pdfContentMap.put(pdfs.Name, pdfS.Content__c);
            }
            else {
                pdfContentMap.put(pdfs.Name, SG01_Constants.BLANK);
            }
            
            if(pdfS.Type__c == SG01_Constants.COLUMN){
                headerMap.put(pdfS.Name, pdfS.Content__c);
            }else if(pdfS.Type__c == SG01_Constants.LABEL){
                headerMap.put(pdfS.Name, pdfS.Content__c);
            }else if(pdfS.Type__c == SG01_Constants.SIGNATURE){
                headerMap.put(pdfS.Name, pdfS.Content__c);
            }                            
        }
    }
    
    /**
    * Get the logo and the picture for the template.
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    private void empireLogo(){
        Document doc = new Document();
        Document bPic = new Document();
        Document bU = new Document();
        Document sign = new Document();
        String logo = SG01_Constants.BLANK;
        
        //get the logo name by Brand
        if(q.Brand__c == SG01_Constants.EBCBS){
            logo = SG01_Constants.EMPIRE_CROSS_SHIELD;
        } else {
            logo = SG01_Constants.EMPIRE_CROSS_ONLY;
        }
        for(Document docloop : [SELECT Id, Name FROM Document WHERE Name =: logo OR  Name =: SG01_Constants.QUOTE_PDF_IMG
                                OR Name =: SG01_Constants.BORDER_UPPER OR  Name =: SG01_Constants.SIGNATURE]){
            if(docloop.Name == logo){
                doc = docloop;
                empireLogo = SG01_Constants.FILE_SERVER_URL + doc.Id;
            }else if(docloop.Name == SG01_Constants.QUOTE_PDF_IMG){
                bPic  = docloop;
                bigPicture = SG01_Constants.FILE_SERVER_URL + bPic.Id;
            }else if(docloop.Name == SG01_Constants.BORDER_UPPER){
                bU  = docloop;
                borderUpper = SG01_Constants.FILE_SERVER_URL + bU.Id;
            }else if(docloop.Name == SG01_Constants.SIGNATURE){
                sign = docloop;
                signature = SG01_Constants.FILE_SERVER_URL + sign.Id;
            }
        }
        
    }
    
    /**
    * Get all the attribute of the products.
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    private void allAttribute(){
        qli = [SELECT Id, Product2Id, Product2.vlocity_ins__Type__c, LineNumber, Product2.Name, Class_Selected__c,
               Class_1_Number_EE__c, Class_1_Number_EE_Child__c, Class_1_Number_EE_Family__c, Class_1_Number_EE_Spouse__c, Class_1_Total__c, 
               Class_2_Number_EE__c, Class_2_Number_EE_Child__c, Class_2_Number_EE_Family__c, Class_2_Number_EE_Spouse__c, Class_2_Total__c, 
               Class_3_Number_EE__c, Class_3_Number_EE_Child__c, Class_3_Number_EE_Family__c, Class_3_Number_EE_Spouse__c, Class_3_Total__c,
               Base_EE__c, Base_EE_Child__c,Base_EE_Family__c,Base_EE_Spouse__c, Employer_Contribution_Percent__c, Dental_Bundled_Price_EE__c, 
               Dental_Bundled_Price_EE_Ch__c, Dental_Bundled_Price_EE_Fa__c, Dental_Bundled_Price_EE_Sp__c,
               C1_Total_EE__c, C1_Total_EE_Sp__c, C1_Total_EE_Ch__c, C1_Total_EE_Family__c, C1_Annual_Total_Premium__c, C1_Emp_Contrib_Amt__c,
               C2_Total_EE__c, C2_Total_EE_Sp__c, C2_Total_EE_Ch__c, C2_Total_EE_Family__c, C2_Annual_Total_Premium__c, C2_Emp_Contrib_Amt__c,
               C3_Total_EE__c, C3_Total_EE_Sp__c, C3_Total_EE_Ch__c, C3_Total_EE_Family__c, C3_Annual_Total_Premium__c, C3_Emp_Contrib_Amt__c
               FROM QuoteLineItem WHERE QuoteId =: q.Id];
        Set<Id> pIdSet = new Set<Id>();
        for(QuoteLineItem lineItem : qli){
            pIdSet.add(lineItem.Product2Id);
        }
        
        Map<Id, List<vlocity_ins__AttributeAssignment__c>> vaaMap = new Map<Id, List<vlocity_ins__AttributeAssignment__c>>();
        for(vlocity_ins__AttributeAssignment__c vaa : [SELECT vlocity_ins__AttributeDisplayName__c, vlocity_ins__ObjectId__c, vlocity_ins__Value__c, Id FROM vlocity_ins__AttributeAssignment__c WHERE vlocity_ins__ObjectId__c IN: pIdSet]){
            if(vaaMap.containskey(vaa.vlocity_ins__ObjectId__c)){
                vaaMap.get(vaa.vlocity_ins__ObjectId__c).add(vaa);
            }else{
                List<vlocity_ins__AttributeAssignment__c> vaaList= new List<vlocity_ins__AttributeAssignment__c>();
                vaaList.add(vaa);
                vaaMap.put(vaa.vlocity_ins__ObjectId__c, vaaList);
            }
        }
        //get all the products
        Map<Id, Product2> proMap = new Map<Id, Product2>([SELECT Id, Name, OrthoCoverage__c, Network__c,vlocity_ins__SubType__c,FundingType__c, ProductCode FROM Product2 WHERE Id IN: pIdSet]);
        //create wrapper per type
        displayMedical1 = new List<DisplayWrapper>();
        displayMedical2 = new List<DisplayWrapper>();
        displayMedical3 = new List<DisplayWrapper>();
        displayMedicalAll = new List<DisplayWrapper>();
        displayDental = new List<DisplayWrapper>();
        displayVision = new List<DisplayWrapper>();
        
        //separte data by their type and put it in the map.
        for(QuoteLineItem lineItem : qli){
            List<vlocity_ins__AttributeAssignment__c> aaList= new List<vlocity_ins__AttributeAssignment__c>();
            Map<String, String> aaMap = new Map<String, String>();
            aaList = vaaMap.get(lineItem.Product2Id);
            Product2 p = proMap.get(lineItem.Product2Id);
            CensusData cd = null;
            if(lineItem.Product2.vlocity_ins__Type__c == SG01_Constants.MEDICAL){
                aaMap = mappingMedical(aaList);
                cd = new CensusData();
                if(lineItem.Class_Selected__c == SG01_Constants.ONE){
                    //aaMap = mappingMedical(aaList);
                    cd.Number_EE = lineItem.Class_1_Number_EE__c;
                    cd.Total_EE = lineItem.C1_Total_EE__c;
                    cd.Number_EE_Spouse = lineItem.Class_1_Number_EE_Spouse__c;
                    cd.Total_EE_Sp = lineItem.C1_Total_EE_Sp__c;
                    cd.Number_EE_Child = lineItem.Class_1_Number_EE_Child__c;
                    cd.Total_EE_Ch = lineItem.C1_Total_EE_Ch__c;
                    cd.Number_EE_Family = lineItem.Class_1_Number_EE_Family__c;
                    cd.Total_EE_Family = lineItem.C1_Total_EE_Family__c;
                    cd.Total = lineItem.Class_1_Total__c;
                    cd.Annual_Total_Premium = lineItem.C1_Annual_Total_Premium__c;
                    cd.Emp_Contrib_Amt = lineItem.C1_Emp_Contrib_Amt__c;
                    displayMedical1.add(new DisplayWrapper(lineItem, lineItem.Product2.Name, aaMap, p, cd));
                } else if(lineItem.Class_Selected__c == SG01_Constants.TWO){
                    //aaMap = mappingMedical(aaList);
                    cd.Number_EE = lineItem.Class_2_Number_EE__c;
                    cd.Total_EE = lineItem.C2_Total_EE__c;
                    cd.Number_EE_Spouse = lineItem.Class_2_Number_EE_Spouse__c;
                    cd.Total_EE_Sp = lineItem.C2_Total_EE_Sp__c;
                    cd.Number_EE_Child = lineItem.Class_2_Number_EE_Child__c;
                    cd.Total_EE_Ch = lineItem.C2_Total_EE_Ch__c;
                    cd.Number_EE_Family = lineItem.Class_2_Number_EE_Family__c;
                    cd.Total_EE_Family = lineItem.C2_Total_EE_Family__c;
                    cd.Total = lineItem.Class_2_Total__c;
                    cd.Annual_Total_Premium = lineItem.C2_Annual_Total_Premium__c;
                    cd.Emp_Contrib_Amt = lineItem.C2_Emp_Contrib_Amt__c;
                    displayMedical2.add(new DisplayWrapper(lineItem, lineItem.Product2.Name, aaMap, p, cd));
                } else if(lineItem.Class_Selected__c == SG01_Constants.THREE){
                    //aaMap = mappingMedical(aaList);
                    cd.Number_EE = lineItem.Class_3_Number_EE__c;
                    cd.Total_EE = lineItem.C3_Total_EE__c;
                    cd.Number_EE_Spouse = lineItem.Class_3_Number_EE_Spouse__c;
                    cd.Total_EE_Sp = lineItem.C3_Total_EE_Sp__c;
                    cd.Number_EE_Child = lineItem.Class_3_Number_EE_Child__c;
                    cd.Total_EE_Ch = lineItem.C3_Total_EE_Ch__c;
                    cd.Number_EE_Family = lineItem.Class_3_Number_EE_Family__c;
                    cd.Total_EE_Family = lineItem.C3_Total_EE_Family__c;
                    cd.Total = lineItem.Class_3_Total__c;
                    cd.Annual_Total_Premium = lineItem.C3_Annual_Total_Premium__c;
                    cd.Emp_Contrib_Amt = lineItem.C3_Emp_Contrib_Amt__c;
                    displayMedical3.add(new DisplayWrapper(lineItem, lineItem.Product2.Name, aaMap, p, cd));
                } 
            } else if(lineItem.Product2.vlocity_ins__Type__c == SG01_Constants.DENTAL){
                aaMap = mappingDental(aaList);
                displayDental.add(new DisplayWrapper(lineItem, lineItem.Product2.Name, aaMap, p, null));
            } else if(lineItem.Product2.vlocity_ins__Type__c == SG01_Constants.VISION){
                aaMap = mappingVision(aaList);
                displayVision.add(new DisplayWrapper(lineItem, lineItem.Product2.Name, aaMap, p, null));
            }
        }
        
        displayMedicalAll.addAll(displayMedical1);
        displayMedicalAll.addAll(displayMedical2);
        displayMedicalAll.addAll(displayMedical3);
    }
    
    /**
    * Loop the Attribute Assignment for Dental.
    * Parameter List<vlocity_ins__AttributeAssignment__c>
    * Return Map<String, String>
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    private Map<String, String> mappingDental(List<vlocity_ins__AttributeAssignment__c> aaList) {
        Map<String, String> aaMap = new Map<String, String>();
        List<Assignment_Attribute_Mapping__c> aahDental = new List<Assignment_Attribute_Mapping__c>();
        aahDental = aaHMap.get(SG01_Constants.DENTAL);
        Set<String> fieldsName = new Set<String>();
        for(Assignment_Attribute_Mapping__c dental : aahDental){
            fieldsName.add(dental.Name_Header__c);
        }
        //check if the fields are not empty
        for(vlocity_ins__AttributeAssignment__c aa : aaList){

            for(String name : fieldsName){
                if(aa.vlocity_ins__AttributeDisplayName__c != null && aa.vlocity_ins__AttributeDisplayName__c == name){
                    aaMap.put(name ,aa.vlocity_ins__Value__c);
                } 
            }
        }
        //if fields are empty put a empty value
        for(String s : fieldsName){
            if(!aaMap.containsKey(s)){
                aaMap.put(s, SG01_Constants.SPACE);
            }
        }
        return aaMap;
    }
    
    /**
    * Loop the Attribute Assignment for Vision.
    * Parameter List<vlocity_ins__AttributeAssignment__c>
    * Return Map<String, String> 
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    private Map<String, String> mappingVision(List<vlocity_ins__AttributeAssignment__c> aaList) {
        Map<String, String> aaMap = new Map<String, String>();
        List<Assignment_Attribute_Mapping__c> aahVision = new List<Assignment_Attribute_Mapping__c>();
        aahVision = aaHMap.get(SG01_Constants.VISION);
        Set<String> fieldsName = new Set<String>();
        
        for(Assignment_Attribute_Mapping__c vision : aahVision){
            fieldsName.add(vision.Name_Header__c);
        }
        //check if the fields are not empty
        for(vlocity_ins__AttributeAssignment__c aa : aaList){

            for(String name : fieldsName){
                if(aa.vlocity_ins__AttributeDisplayName__c != null && aa.vlocity_ins__AttributeDisplayName__c.contains(name)){
                    aaMap.put(name ,aa.vlocity_ins__Value__c);
                } 
            }
        }
        //if fields are empty put a empty value
        for(String s : fieldsName){
            if(!aaMap.containsKey(s)){
                aaMap.put(s, SG01_Constants.SPACE);
            }
        }
        return aaMap;
    }
    
    /**
    * Loop the Attribute Assignment for Vision.
    * Parameter List<vlocity_ins__AttributeAssignment__c>
    * Return Map<String, String> 
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    private Map<String, String> mappingMedical(List<vlocity_ins__AttributeAssignment__c> aaList) {
        Map<String, String> aaMap = new Map<String, String>();
        List<Assignment_Attribute_Mapping__c> aahMedical = new List<Assignment_Attribute_Mapping__c>();
        aahMedical = aaHMap.get(SG01_Constants.MEDICAL);
        Set<String> fieldsName = new Set<String>();
        for(Assignment_Attribute_Mapping__c Medical : aahMedical){
            fieldsName.add(Medical.Name_Header__c);
        }
        //check if the fields are not empty
        for(vlocity_ins__AttributeAssignment__c aa : aaList){

            for(String name : fieldsName){
                if(aa.vlocity_ins__AttributeDisplayName__c != null && aa.vlocity_ins__AttributeDisplayName__c.contains(name)){
                    aaMap.put(name ,aa.vlocity_ins__Value__c);
                } 
            }
        }
        //if fields are empty put a empty value
        for(String s : fieldsName){
            if(!aaMap.containsKey(s)){
                aaMap.put(s, SG01_Constants.SPACE);
            }
        }
        return aaMap;
    }
    
    
    /**
    * Insert the PDF to quote.
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public void attachQuoteFromOmniScript() {
        PageReference pageRef = Page.QuotePDF;
        pageRef.getParameters().put(SG01_Constants.ID,q.id);
        String accountId = q.AccountId;

        Blob pdf1;
        if(!Test.isRunningTest()){
           pdf1  = pageRef.getcontentAsPdf();
        }else{
            pdf1 = Blob.valueOf(SG01_Constants.NONE_STRING);
        }
        QuoteDocument qd = new QuoteDocument();
        qd.Document = pdf1;
        qd.QuoteId = q.Id;
        Database.insert(qd);
        createContDocLinkonAccount(qd,accountId);
    }
    
    /**
    * Insert the PDF to Account.
    * @Author: IDC Offshore
    * 
    */
    private void createContDocLinkonAccount(QuoteDocument qd,String accountId){
        if(qd != NULL && accountId != NULL){
            QuoteDocument quoteDoc =  [select Id,Name,QuoteId,Document,ContentVersionDocumentId
                                       from QuoteDocument
                                       where Id =:qd.Id];
            
            ContentDocument cdocObj = [select id, Title,LatestPublishedVersionId, ContentSize 
                                       from contentdocument where LatestPublishedVersionId =:quoteDoc.ContentVersionDocumentId];
            cdocObj.Title = quoteDoc.Name;//updating the title of the document
            Database.update(cdocObj);
            
            ContentDocumentLink ct = new ContentDocumentLink();
            ct.ContentDocumentId = cdocObj.Id;
            ct.LinkedEntityId = accountId;
            ct.ShareType = SHARE_TYPE;
            Database.insert(ct);
        }
                                         
    }
    
    /**
    * Page control what to display.
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    private void pageControl() {
        //Quote qCoverage = [SELECT Coverage_Options__c FROM Quote WHERE ID =: q.Id];
        String cov = SG01_Constants.BLANK;
        renDental = false;
        renVision = false;
        renMedical = false;
        if(String.isNotBlank(q.Coverage_Options__c)){
            cov = q.Coverage_Options__c;
        }
        if(cov != SG01_Constants.BLANK){
            if(cov.containsIgnoreCase(SG01_Constants.DENTAL)){
                renDental = true;
            }
            if(cov.containsIgnoreCase(SG01_Constants.VISION)){
                renVision = true;
            }
            if(cov.containsIgnoreCase(SG01_Constants.MEDICAL)){
                renMedical = true;
            }
        }
    }
    
    /**
    * Wrapper class for the display.
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public class DisplayWrapper{
        public QuoteLineItem qlItem{get; set;}
        public String proName{get; set;}
        public List<vlocity_ins__AttributeAssignment__c> aaList{get; set;}
        public Map<String, String>  aaMap{get; set;}
        public Product2 pro{get; set;}
        public CensusData cData {get; set;}
        
        public DisplayWrapper(QuoteLineItem quoteItem, String pName, Map<String, String> vaaMap, Product2 p, CensusData cData){
            qlItem = quoteItem;
            proName = pName;
            aaMap = vaaMap;
            pro = p;
            this.cData = cData;
        }
    }
    
    /**
    * Wrapper class for all Census data.
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public class CensusData {
        public Double Number_EE {get; set;}
        public Decimal Total_EE {get; set;}
        public Double Number_EE_Spouse {get; set;}
        public Decimal Total_EE_Sp {get; set;}
        public Double Number_EE_Child {get; set;}
        public Decimal Total_EE_Ch {get; set;}
        public Double Number_EE_Family {get; set;}
        public Decimal Total_EE_Family {get; set;}
        public Decimal Total {get; set;}
        public Decimal Annual_Total_Premium {get; set;}
        public Double Emp_Contrib_Amt {get; set;}
        
        public CensusData (){
        }
    }
}