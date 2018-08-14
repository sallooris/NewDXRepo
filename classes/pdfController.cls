/**
* Controller for QUotePDF VF page.
* 
* @Date: 07/11/2016
* @Author: Rayson Landeta (Cloud First)
* 
*/
public class pdfController{
    private final Quote q;
    ApexPages.StandardController controller;

    public static Quote allQuote{get;set;}
    public static Account acct{get;set;}
    public static List<QuoteLineItem> qli{get;set;}
    public static Map<String, List<Assignment_Attribute_Mapping__c>> aahMap{get;set;}
    public static Map<String, String> headerMap{get;set;}
    
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
    * 
    * @Date: 07/11/2016
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public pdfController(ApexPages.StandardController stdController){
        controller = stdController;
        if(!Test.isRunningTest()) {
            controller.addFields(new List<String>{'Coverage_Options__c', 'Brand__c', 'vlocity_ins__EffectiveDate__c'});
        }
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
            if(aahCustom.Type__c == 'QuotePDFImage'){
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
        if(accId != ''){
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
    * 
    * @Date: 07/11/2016
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public void acctFromQuote(){
        try{
            acct = [SELECT Agency__c,Billing_PostalCode__c,BillingCountry,Billing_State__c, Name , SIC FROM Account WHERE Id = : accId];
            if(acct != null && acct.Billing_PostalCode__c != null)
            {
                List<Zip_City_County__c> zip_County = [select County__c from Zip_City_County__c where Name =:acct.Billing_PostalCode__c];//.County__c;
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
    * 
    * @Date: 07/11/2016
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public void buildPDFContentMap(){
        pdfContentMap = new Map<String, String>();
        for(Quote_PDF_Section__c  pdfS : pdfSection){
            //to handle null value
            if(pdfS.Content__c != null) {
                pdfContentMap.put(pdfs.Name, pdfS.Content__c);
            }
            else {
                pdfContentMap.put(pdfs.Name, '');
            }
            
            if(pdfS.Type__c == 'Column'){
                headerMap.put(pdfS.Name, pdfS.Content__c);
            }else if(pdfS.Type__c == 'Label'){
                headerMap.put(pdfS.Name, pdfS.Content__c);
            }else if(pdfS.Type__c == 'Signature'){
                headerMap.put(pdfS.Name, pdfS.Content__c);
            }                            
        }
    }
     
    /**
    * Get the logo and the picture for the template.
    * 
    * @Date: 07/11/2016
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public void empireLogo(){
        Document doc = new Document();
        Document bPic = new Document();
        Document bU = new Document();
        Document sign = new Document();
        String logo = '';
        
        //get the logo name by Brand
        if(q.Brand__c == 'EBCBS'){
            logo = 'Empire Logo Cross Shield';
        } else {
            logo = 'Empire Logo Cross Only';
        }
        for(Document docloop : [SELECT Id, Name FROM Document WHERE Name =: logo OR  Name =: 'QuotePDFImage' OR Name =: 'BorderUpper' OR  Name =: 'Signature']){
            if(docloop.Name == logo){
                doc = docloop;
                empireLogo = '/servlet/servlet.FileDownload?file=' + doc.Id;
            }else if(docloop.Name == 'QuotePDFImage'){
                bPic  = docloop;
                bigPicture = '/servlet/servlet.FileDownload?file=' + bPic.Id;
            }else if(docloop.Name == 'BorderUpper'){
                bU  = docloop;
                borderUpper = '/servlet/servlet.FileDownload?file=' + bU.Id;
            }else if(docloop.Name == 'Signature'){
                sign = docloop;
                signature = '/servlet/servlet.FileDownload?file=' + sign.Id;
            }
        }
        
    }
    
    /**
    * Get all the attribute of the products.
    * 
    * @Date: 07/11/2016
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public void allAttribute(){
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
        system.debug('productId ---- ' + lineItem.Product2Id);
            pIdSet.add(lineItem.Product2Id);
            system.debug('Henzi+++'+pIdSet);
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
            system.debug('HENZI___'+lineItem.Product2Id);
            system.debug('HENZI___'+aaList);
            Product2 p = proMap.get(lineItem.Product2Id);
            CensusData cd = null;
            if(lineItem.Product2.vlocity_ins__Type__c == 'Medical'){
                aaMap = mappingMedical(aaList);
                system.debug('HENZI+++'+aaMap);
                cd = new CensusData();
                if(lineItem.Class_Selected__c == '1'){
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
                    system.debug('HENZI'+displayMedical1);
                    system.debug('HENZI'+aaMap);
                    system.debug('HENZI_AAMAP'+aaMap.get('Rx'));
                } else if(lineItem.Class_Selected__c == '2'){
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
                } else if(lineItem.Class_Selected__c == '3'){
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
            } else if(lineItem.Product2.vlocity_ins__Type__c == 'Dental'){
                aaMap = mappingDental(aaList);
                displayDental.add(new DisplayWrapper(lineItem, lineItem.Product2.Name, aaMap, p, null));
            } else if(lineItem.Product2.vlocity_ins__Type__c == 'Vision'){
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
    * @Date: 07/28/2016
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public Map<String, String> mappingDental(List<vlocity_ins__AttributeAssignment__c> aaList) {
        Map<String, String> aaMap = new Map<String, String>();
        List<Assignment_Attribute_Mapping__c> aahDental = new List<Assignment_Attribute_Mapping__c>();
        aahDental = aaHMap.get('Dental');
        Set<String> fieldsName = new Set<String>();
        for(Assignment_Attribute_Mapping__c dental : aahDental){
            fieldsName.add(dental.Name_Header__c);
        }
        //check if the fields are not empty
        for(vlocity_ins__AttributeAssignment__c aa : aaList){
            system.debug('Display Name ---- ' + aa.vlocity_ins__AttributeDisplayName__c);
            for(String name : fieldsName){
                if(aa.vlocity_ins__AttributeDisplayName__c != null && aa.vlocity_ins__AttributeDisplayName__c == name){
                    aaMap.put(name ,aa.vlocity_ins__Value__c);
                } 
            }
        }
        //if fields are empty put a empty value
        for(String s : fieldsName){
            if(!aaMap.containsKey(s)){
                aaMap.put(s, ' ');
            }
        }
        return aaMap;
    }
    
    /**
    * Loop the Attribute Assignment for Vision.
    * Parameter List<vlocity_ins__AttributeAssignment__c>
    * Return Map<String, String> 
    * @Date: 07/28/2016
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public Map<String, String> mappingVision(List<vlocity_ins__AttributeAssignment__c> aaList) {
        Map<String, String> aaMap = new Map<String, String>();
        List<Assignment_Attribute_Mapping__c> aahVision = new List<Assignment_Attribute_Mapping__c>();
        aahVision = aaHMap.get('Vision');
        Set<String> fieldsName = new Set<String>();
        
        for(Assignment_Attribute_Mapping__c vision : aahVision){
            fieldsName.add(vision.Name_Header__c);
        }
        //check if the fields are not empty
        for(vlocity_ins__AttributeAssignment__c aa : aaList){
            system.debug('Display Name ---- ' + aa.vlocity_ins__AttributeDisplayName__c);
            for(String name : fieldsName){
                if(aa.vlocity_ins__AttributeDisplayName__c != null && aa.vlocity_ins__AttributeDisplayName__c.contains(name)){
                    aaMap.put(name ,aa.vlocity_ins__Value__c);
                } 
            }
        }
        //if fields are empty put a empty value
        for(String s : fieldsName){
            if(!aaMap.containsKey(s)){
                aaMap.put(s, ' ');
            }
        }
        return aaMap;
    }
    
    /**
    * Loop the Attribute Assignment for Vision.
    * Parameter List<vlocity_ins__AttributeAssignment__c>
    * Return Map<String, String> 
    * @Date: 07/28/2016
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public Map<String, String> mappingMedical(List<vlocity_ins__AttributeAssignment__c> aaList) {
        Map<String, String> aaMap = new Map<String, String>();
        List<Assignment_Attribute_Mapping__c> aahMedical = new List<Assignment_Attribute_Mapping__c>();
        aahMedical = aaHMap.get('Medical');
        Set<String> fieldsName = new Set<String>();
        for(Assignment_Attribute_Mapping__c Medical : aahMedical){
            fieldsName.add(Medical.Name_Header__c);
        }
        //check if the fields are not empty
        for(vlocity_ins__AttributeAssignment__c aa : aaList){
            system.debug('Display Name ---- ' + aa.vlocity_ins__AttributeDisplayName__c);
            for(String name : fieldsName){
                //if(aa.vlocity_ins__AttributeDisplayName__c != null && aa.vlocity_ins__AttributeDisplayName__c.contains(name)){
                //    aaMap.put(name ,aa.vlocity_ins__Value__c);
                if(aa.vlocity_ins__AttributeDisplayName__c != null && aa.vlocity_ins__AttributeDisplayName__c == name){                    aaMap.put(name ,aa.vlocity_ins__Value__c);                }     
                    
                //} 
            }
        }
        //if fields are empty put a empty value
        for(String s : fieldsName){
            if(!aaMap.containsKey(s)){
                aaMap.put(s, ' ');
            }
        }
        return aaMap;
    }
    
    /**
    * Insert the PDF to quote.
    * 
    * @Date: 07/19/2016
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public PageReference attachQuote() {
        PageReference pageRef = Page.QuotePDF;
        pageRef.getParameters().put('id',q.id);
        Blob pdf1 = pageRef.getcontentAsPdf();
        QuoteDocument qd = new QuoteDocument();
        qd.Document = pdf1;
        qd.QuoteId = q.Id;
        insert qd;
        return null;
    }
    
    /**
    * Page control what to display.
    * 
    * @Date: 08/8/2016
    * @Author: Rayson Landeta (Cloud First)
    * 
    */
    public void pageControl() {
        //Quote qCoverage = [SELECT Coverage_Options__c FROM Quote WHERE ID =: q.Id];
        String cov = '';
        renDental = false;
        renVision = false;
        renMedical = false;
        if(String.isNotBlank(q.Coverage_Options__c)){
            cov = q.Coverage_Options__c;
        }
        if(cov != ''){
            if(cov.containsIgnoreCase('Dental')){
                renDental = true;
            }
            if(cov.containsIgnoreCase('Vision')){
                renVision = true;
            }
            if(cov.containsIgnoreCase('Medical')){
                renMedical = true;
            }
        }
    }
    
    /**
    * Wrapper class for the display.
    * 
    * @Date: 07/11/2016
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
    * 
    * @Date: 07/11/2016
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