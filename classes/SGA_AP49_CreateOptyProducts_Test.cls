/************************************************************************
* Class Name  : SGA_AP49_CreateOptyProducts_Test
* Created By  : IDC Offshore
* Created Date: 9/19/2017
* Description : It is the test class for SGA_AP49_CreateOptyProducts
* 
**********************************************************************/
@isTest
private class SGA_AP49_CreateOptyProducts_Test {
    private static final String ROW_INDEX = 'rowIndex';
    private static final String MEDICAL = 'Medical';
    private static final String DENTAL = 'Dental';
    private static final String VISION = 'Vision';
    
    /*************************************************************************************
    * Method Name : createOppProdRecTest
    * Parameters  : None
    * Return Type : void
    * Description : The method is used to test the save functionality of the 
    *               Opportunity Products creation
    **************************************************************************************/
    private static testMethod void createOppProdRecTest(){
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        Opportunity testOpp = Util02_TestData.createGrpAccOpportunity();
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            testOpp.AccountId = testAccount.Id;
            Database.Insert(testOpp);
            Test.startTest();
            PageReference pageRef = Page.SGA_VFP11_CreateOptyProducts;
            Test.setCurrentPage(pageRef);
            SGA_AP49_CreateOptyProducts createOppPrdObj = new SGA_AP49_CreateOptyProducts(new ApexPages.StandardController(testOpp));
            createOppPrdObj.fetchOptyProdRec();
            createOppPrdObj.addRow();
            try{
                createOppPrdObj.save();
            }catch(Exception e){testOpp = NULL;}
            Test.stopTest();
            System.assertNotEquals(0, createOppPrdObj.fetchOptyProdRecList.size());
        }
    }
    /*************************************************************************************
    * Method Name : deleteOppProdRecTest
    * Parameters  : None
    * Return Type : void
    * Description : The method is used to test the delete record functionality of the 
    *               Opportunity Product records
    **************************************************************************************/
    private static testMethod void deleteOppProdRecTest(){
        User testUser = Util02_TestData.createUser();
        //Account record creation
        Account testAccount = Util02_TestData.createGroupAccountForRelatedList();
        Opportunity testOpp = Util02_TestData.createGrpAccOpportunity();
        //Business Custom Setting insertion
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        //Record Type Assignment Custom Setting insertion
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        System.runAs(testUser){
            Database.insert(cs001List);
            Database.insert(cs002List);
            Database.Insert(testAccount);
            testOpp.AccountId = testAccount.Id;
            Database.Insert(testOpp);
            Test.startTest();
            
            SGA_AP49_CreateOptyProducts createOppPrdObj = new SGA_AP49_CreateOptyProducts(new ApexPages.StandardController(testOpp));
            createOppPrdObj.fetchOptyProdRec();
            
            createOppPrdObj.fetchOptyProdRecList[0].Product_Type__c = MEDICAL;
            createOppPrdObj.fetchOptyProdRecList[1].Product_Type__c = DENTAL;
            createOppPrdObj.fetchOptyProdRecList[2].Product_Type__c = VISION;
            createOppPrdObj.save();
            
            List<Opportunity_Products__c> oppProdList = [select id from Opportunity_Products__c where Opportunity__c=:testOpp.Id];
            
            PageReference pageRef = Page.SGA_VFP11_CreateOptyProducts;
            Test.setCurrentPage(pageRef);
            SGA_AP49_CreateOptyProducts createOppPrdObj1 = new SGA_AP49_CreateOptyProducts(new ApexPages.StandardController(testOpp));
            createOppPrdObj1.fetchOptyProdRec();
            ApexPages.currentPage().getParameters().put(ROW_INDEX,String.valueOf(1));
            createOppPrdObj1.deleteRow();
            
            Test.stopTest();
            //checking 1 record has been deleted
            System.assertEquals(2, createOppPrdObj1.fetchOptyProdRecList.size());
        }
    }
}