/****************************************************************************
Class Name  :  EnrolmentQuote_Test
Created By  :  Vlocity
Description : Test class for EnrolmentQuote
****************************************************************************/
@isTest
private class EnrolmentQuote_Test {

    static testMethod void EnrolmentQuoteTest() {
        
        User tstUser = Util02_TestData.insertUser();
        System.runAs(tstUser)
        {  
            test.startTest();     
            List<CS001_RecordTypeBusinessTrack__c> cs001List = BRPUtilTestMethods.createCS001Data();
            insert cs001List; 
            Account  accnt = BRPUtilTestMethods.CreateGroupAccount();
            insert accnt;
            Opportunity  opp = BRPUtilTestMethods.CreateOpportunity(accnt);   
            insert opp;     
            Quote  quote = BRPUtilTestMethods.CreateQuote(accnt,opp);
            insert quote;
            List<QuoteLineItem> QLI_Lst = BRPUtilTestMethods.CreateQuoteLineItemForPDF(quote);
            EnrolmentQuote EnrQuote = new EnrolmentQuote();
            EnrolmentQuote.getQLI(quote.id);
            EnrolmentQuote.Attributes Attr = new EnrolmentQuote.Attributes('Cat1', 'Attr1', 'AttrVal', 1.0, 1.0, 'Desc', 'Type', true);
            test.stopTest();
        }
    }
 }