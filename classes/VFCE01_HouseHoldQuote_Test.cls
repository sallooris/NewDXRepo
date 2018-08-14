@isTest
public class VFCE01_HouseHoldQuote_Test{
    
    static testmethod void testQuoteHousehold1() {
        Util02_TestData utilinsertObj = new Util02_TestData();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        Account a1 = Util02_TestData.insertAccount();
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
        a1.recordtypeId = accRT ; 
        insert a1;
        Household_Member__c hm1 = Util02_TestData.insertHousehold();
        hm1.Household_ID__c=a1.id;
        insert hm1;
         Household_Member__c hm2 = Util02_TestData.insertHousehold();
        hm2.Household_ID__c=a1.id;
        insert hm2;
        Household_Member__c hm3 = Util02_TestData.insertHousehold();
        hm3.Household_ID__c=a1.id;
        insert hm3;
        Household_Member__c hm4 = Util02_TestData.insertHousehold();
        hm4.Household_ID__c=a1.id;
        insert hm4;
        Test.setCurrentPageReference(new PageReference('Page.VFP01_HouseholdQuotePage'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE01_HouseHoldQuote controller = new VFCE01_HouseHoldQuote(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);
        controller.getRelatedParties();
        List<VFCE01_HouseHoldQuote.HouseHold> HouseHoldList=new List<VFCE01_HouseHoldQuote.HouseHold>();
        VFCE01_HouseHoldQuote.HouseHold hh = new VFCE01_HouseHoldQuote.HouseHold(hm1);
        hh.role='Primary Insured';
        hh.isSelect = true;
        VFCE01_HouseHoldQuote.HouseHold hh1 = new VFCE01_HouseHoldQuote.HouseHold(hm2);
        hh1.role='Primary Insured';
        hh1.isSelect = true;
        VFCE01_HouseHoldQuote.HouseHold hh2 = new VFCE01_HouseHoldQuote.HouseHold(hm3);
        hh2.role='Spouse';
        hh2.isSelect = true;
        
        VFCE01_HouseHoldQuote.HouseHold hh3 = new VFCE01_HouseHoldQuote.HouseHold(hm4);
        hh3.role='Dependent';
        hh.isSelect = true;
        controller.HouseHoldList.add(hh);
        controller.HouseHoldList.add(hh1);
        controller.HouseHoldList.add(hh2);
        controller.HouseHoldList.add(hh3);
         controller.getRelatedParties();
        //controller.backMethod();
        controller.next();
        
        
      }
      static testmethod void testQuoteHousehold2() {
        Util02_TestData utilinsertObj = new Util02_TestData();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        Account a1 = Util02_TestData.insertAccount();
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
        a1.recordtypeId = accRT ; 
        insert a1;
        Household_Member__c hm1 = Util02_TestData.insertHousehold();
        hm1.Household_ID__c=a1.id;
        insert hm1;
         Household_Member__c hm2 = Util02_TestData.insertHousehold();
        hm2.Household_ID__c=a1.id;
        insert hm2;
        Household_Member__c hm3 = Util02_TestData.insertHousehold();
        hm3.Household_ID__c=a1.id;
        insert hm3;
        Household_Member__c hm4 = Util02_TestData.insertHousehold();
        hm4.Household_ID__c=a1.id;
        insert hm4;
        Test.setCurrentPageReference(new PageReference('Page.VFP01_HouseholdQuotePage'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE01_HouseHoldQuote controller = new VFCE01_HouseHoldQuote(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);
        controller.getRelatedParties();
        List<VFCE01_HouseHoldQuote.HouseHold> HouseHoldList=new List<VFCE01_HouseHoldQuote.HouseHold>();
        VFCE01_HouseHoldQuote.HouseHold hh = new VFCE01_HouseHoldQuote.HouseHold(hm1);
        hh.role='Primary Insured';
        hh.isSelect = true;
        
        VFCE01_HouseHoldQuote.HouseHold hh1 = new VFCE01_HouseHoldQuote.HouseHold(hm2);
        hh1.role='Spouse';
        hh1.isSelect = true;
        
        VFCE01_HouseHoldQuote.HouseHold hh2 = new VFCE01_HouseHoldQuote.HouseHold(hm3);
        hh2.role='Spouse';
        hh2.isSelect = true;
        
        VFCE01_HouseHoldQuote.HouseHold hh3 = new VFCE01_HouseHoldQuote.HouseHold(hm4);
        hh3.role='Dependent';
        hh3.isSelect = true;
        
        controller.HouseHoldList.add(hh);
        controller.HouseHoldList.add(hh1);
        controller.HouseHoldList.add(hh2);
        controller.HouseHoldList.add(hh3);
        controller.getRelatedParties();
       // controller.backMethod();
        controller.next();
        
        
      }
      static testmethod void testQuoteHousehold3() {
        Util02_TestData utilinsertObj = new Util02_TestData();
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        Account a1 = Util02_TestData.insertAccount();
        ID accRT =[select Id,Name from Recordtype where Name = 'Person Account' and SobjectType = 'Account'].Id;
        a1.recordtypeId = accRT ;
        insert a1;
        Household_Member__c hm1 = Util02_TestData.insertHousehold();
        hm1.Household_ID__c=a1.id;
        insert hm1;
         Household_Member__c hm2 = Util02_TestData.insertHousehold();
        hm2.Household_ID__c=a1.id;
        insert hm2;
        Household_Member__c hm3 = Util02_TestData.insertHousehold();
        hm3.Household_ID__c=a1.id;
        insert hm3;
        Household_Member__c hm4 = Util02_TestData.insertHousehold();
        hm4.Household_ID__c=a1.id;
        insert hm4;
        Test.setCurrentPageReference(new PageReference('Page.VFP01_HouseholdQuotePage'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE01_HouseHoldQuote controller = new VFCE01_HouseHoldQuote(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);
        controller.getRelatedParties();
        List<VFCE01_HouseHoldQuote.HouseHold> HouseHoldList=new List<VFCE01_HouseHoldQuote.HouseHold>();
        VFCE01_HouseHoldQuote.HouseHold hh = new VFCE01_HouseHoldQuote.HouseHold(hm1);
        hh.role='Primary Insured';
        hh.isSelect = true;
        VFCE01_HouseHoldQuote.HouseHold hh1 = new VFCE01_HouseHoldQuote.HouseHold(hm2);
        hh1.role='Dependent';
        hh1.isSelect = true;
        VFCE01_HouseHoldQuote.HouseHold hh2 = new VFCE01_HouseHoldQuote.HouseHold(hm3);
        hh2.role='Spouse';
        hh2.isSelect = true;
        
        VFCE01_HouseHoldQuote.HouseHold hh3 = new VFCE01_HouseHoldQuote.HouseHold(hm4);
        hh3.role='Dependent';
        hh3.isSelect = true;
        controller.HouseHoldList.add(hh);
        controller.HouseHoldList.add(hh1);
        controller.HouseHoldList.add(hh2);
        controller.HouseHoldList.add(hh3);
        controller.getRelatedParties();
        //controller.backMethod();
        controller.next();
        
        
      }
     
}