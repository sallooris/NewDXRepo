@isTest
public class PDFController_Test {
    public static testMethod void testPDF() {
        List<Product2> pList = new List<Product2>();
        Product2 prod1 = new Product2(Name = 'Testing Product', Family = 'Best Practices', IsActive = true, vlocity_ins__Type__c = 'Vision');
        Product2 prod2 = new Product2(Name = 'Testing Product', Family = 'Best Practices', IsActive = true, vlocity_ins__Type__c = 'Dental');
        Product2 prod3 = new Product2(Name = 'Testing Product', Family = 'Best Practices', IsActive = true, vlocity_ins__Type__c = 'Medical');
        
        pList.add(prod1);
        pList.add(prod2);
        pList.add(prod3);
        insert pList;
        
        Id pricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> listPriceBook = new List<PricebookEntry>();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod1.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        Account testAcc = Util02_TestData.insertAccount();
        List<Opportunity> listopp = new List<Opportunity>();
        Opportunity testOpp=Util02_TestData.insertOpportunity();
        List<Account_Stage__c> astage = Util02_TestData.insertAccountStages();
        insert astage;
        
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
        testAcc.recordtypeId = accRT ; 
        
        ID oppRT =[select Id,Name from Recordtype where Name = 'TS MASTER' and SobjectType = 'Opportunity'].Id;
        testAcc.customer_stage__c = 'Opportunity';
        Database.insert(testAcc);
        testOpp.accountid=testAcc.id;
        testOpp.stagename='Application Started';
        testOpp.CloseDate=System.today();
        testOpp.Name='testO';
        testOpp.recordtypeId = oppRT ;      
        testOpp.Open_Enrollment__c = 'OE 2015';
        AP08_RestrictMultipleOpenOpportunities.isFirstRunOPPBeforeInsert = true;
        Database.insert(testOpp);
        
        Quote q = new Quote (Name = 'quotetest' , OpportunityId = testOpp.id, Coverage_Options__c = 'Medical,Dental,Vision', vlocity_ins__EffectiveDate__c = Date.today(), Brand__c = 'EBC', Pricebook2Id = customPB.Id);
        insert q;
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        QuoteLineItem qli1 = new QuoteLineItem(QuoteId = q.id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = customPrice.id, Base_EE__c = 20.00, Base_EE_Child__c = 20.11, Base_EE_Family__c = 11.11, Base_EE_Spouse__c = 3.11,
                                                Employer_Contribution_Percent__c = 10, Class_Selected__c = '1',Tech_MedicalBenefitLevel__c ='One', Product2Id = prod1.Id);
        QuoteLineItem qli2 = new QuoteLineItem(QuoteId = q.id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = customPrice.id, Base_EE__c = 20.00, Base_EE_Child__c = 20.11, Base_EE_Family__c = 11.11, Base_EE_Spouse__c = 3.11,
                                                Employer_Contribution_Percent__c = 10, Class_Selected__c = '1',Tech_MedicalBenefitLevel__c ='One', Product2Id = prod2.Id);
        QuoteLineItem qli3 = new QuoteLineItem(QuoteId = q.id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = customPrice.id, Base_EE__c = 20.00, Base_EE_Child__c = 20.11, Base_EE_Family__c = 11.11, Base_EE_Spouse__c = 3.11,
                                                Employer_Contribution_Percent__c = 10, Class_Selected__c = '1',Tech_MedicalBenefitLevel__c ='One', Product2Id = prod3.Id);
        QuoteLineItem qli4 = new QuoteLineItem(QuoteId = q.id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = customPrice.id, Base_EE__c = 20.00, Base_EE_Child__c = 20.11, Base_EE_Family__c = 11.11, Base_EE_Spouse__c = 3.11,
                                                Employer_Contribution_Percent__c = 10, Class_Selected__c = '2',Tech_MedicalBenefitLevel__c ='Two', Product2Id = prod3.Id);
        QuoteLineItem qli5 = new QuoteLineItem(QuoteId = q.id , Quantity = 3.00 ,UnitPrice = 12 , PricebookEntryId = customPrice.id, Base_EE__c = 20.00, Base_EE_Child__c = 20.11, Base_EE_Family__c = 11.11, Base_EE_Spouse__c = 3.11,
                                                Employer_Contribution_Percent__c = 10, Class_Selected__c = '3',Tech_MedicalBenefitLevel__c ='Three', Product2Id = prod3.Id);
        qliList.add(qli1);
        qliList.add(qli2);
        qliList.add(qli3);
        qliList.add(qli4);
        qliList.add(qli5);
        insert qliList;
        
        List<vlocity_ins__AttributeAssignment__c> vaaList = new List<vlocity_ins__AttributeAssignment__c>();
        vlocity_ins__AttributeAssignment__c vaa1 = new vlocity_ins__AttributeAssignment__c(vlocity_ins__ObjectId__c = String.valueOf(prod1.Id), vlocity_ins__Value__c = '10');
        vlocity_ins__AttributeAssignment__c vaa2 = new vlocity_ins__AttributeAssignment__c(vlocity_ins__ObjectId__c = String.valueOf(prod2.Id), vlocity_ins__Value__c = '10');
        vlocity_ins__AttributeAssignment__c vaa3 = new vlocity_ins__AttributeAssignment__c(vlocity_ins__ObjectId__c = String.valueOf(prod3.Id), vlocity_ins__Value__c = '10');
        
        vaaList.add(vaa1);
        vaaList.add(vaa2);
        vaaList.add(vaa3);
        insert vaaList;
        
        List<Assignment_Attribute_Mapping__c> aaList = new List<Assignment_Attribute_Mapping__c>();
        Assignment_Attribute_Mapping__c aa = new Assignment_Attribute_Mapping__c(Type__c = 'GrapePicture', Name_Header__c ='BorderUpper', Name ='BorderUpper');
        Assignment_Attribute_Mapping__c aa1 = new Assignment_Attribute_Mapping__c(Type__c = 'Vision', Name_Header__c ='Vision', Name ='Vision');
        Assignment_Attribute_Mapping__c aa2 = new Assignment_Attribute_Mapping__c(Type__c = 'Dental', Name_Header__c ='Dental', Name ='Dental');
        Assignment_Attribute_Mapping__c aa3 = new Assignment_Attribute_Mapping__c(Type__c = 'Medical', Name_Header__c ='Medical', Name ='Medical');
        
        aaList.add(aa);
        aaList.add(aa1);
        aaList.add(aa2);
        aaList.add(aa3);
        insert aaList;
        
        List<Quote_PDF_Section__c> qsList = new List<Quote_PDF_Section__c>();
        Quote_PDF_Section__c qs1 = new Quote_PDF_Section__c(Type__c = 'Signature', Content__c ='TestContent', Name ='Page10');
        Quote_PDF_Section__c qs2 = new Quote_PDF_Section__c(Type__c = 'Column', Content__c ='TestContent', Name ='Page101');
        Quote_PDF_Section__c qs3 = new Quote_PDF_Section__c(Type__c = 'Label', Content__c ='TestContent', Name ='Page102');
        
        qsList.add(qs1);
        qsList.add(qs2);
        qsList.add(qs3);
        insert qsList;
        
        Folder f = [Select Id From FOLDER Where type = 'Document' LIMIT 1 ];
        
        List<Document> docList = new List<Document>();
        Document doc1 = new Document(DeveloperName = 'My_doc1', Name = 'Empire Logo Cross Only', FolderId = f.Id);
        Document doc2 = new Document(DeveloperName = 'My_doc2', Name = 'QuotePDFImage', FolderId = f.Id);
        Document doc3 = new Document(DeveloperName = 'My_doc3', Name = 'BorderUpper', FolderId = f.Id);
        Document doc4 = new Document(DeveloperName = 'My_doc4', Name = 'Signature', FolderId = f.Id);
        
        docList.add(doc1);
        docList.add(doc2);
        docList.add(doc3);
        docList.add(doc4);
        insert docList;
        
        PageReference pageRef = Page.QuotePdf;
        Test.setCurrentPage(pageRef);
        pdfController con= new pdfController(new ApexPages.StandardController(q));
    }
}