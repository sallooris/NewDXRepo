@isTest
public class VFCE02_HouseHoldSplit_Test{
    
    static testmethod void testSplitHousehold1() {
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
        Test.setCurrentPageReference(new PageReference('Page.VFP02_HouseholdSplitPage'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE02_HouseHoldSplit controller = new VFCE02_HouseHoldSplit(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);
        controller.getRelatedParties();
        List<VFCE02_HouseHoldSplit.HouseHold> HouseHoldList=new List<VFCE02_HouseHoldSplit.HouseHold>();
        VFCE02_HouseHoldSplit.HouseHold hh = new VFCE02_HouseHoldSplit.HouseHold(hm1);
        hh.role='Primary';
       
        VFCE02_HouseHoldSplit.HouseHold hh1 = new VFCE02_HouseHoldSplit.HouseHold(hm2);
        hh1.role='Primary';
        
        VFCE02_HouseHoldSplit.HouseHold hh2 = new VFCE02_HouseHoldSplit.HouseHold(hm3);
        hh2.role='Spouse';
        
        
        VFCE02_HouseHoldSplit.HouseHold hh3 = new VFCE02_HouseHoldSplit.HouseHold(hm4);
        hh3.role='Dependent';
        
        controller.HouseHoldList.add(hh);
        controller.HouseHoldList.add(hh1);
        controller.HouseHoldList.add(hh2);
        controller.HouseHoldList.add(hh3);
         controller.getRelatedParties();
        controller.backMethod();
        controller.splitHouseHold();
        
        
      }
      static testmethod void testSplitHousehold2() {
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
        Test.setCurrentPageReference(new PageReference('Page.VFP02_HouseholdSplitPage'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE02_HouseHoldSplit controller = new VFCE02_HouseHoldSplit(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);
        controller.getRelatedParties();
        List<VFCE02_HouseHoldSplit.HouseHold> HouseHoldList=new List<VFCE02_HouseHoldSplit.HouseHold>();
        VFCE02_HouseHoldSplit.HouseHold hh = new VFCE02_HouseHoldSplit.HouseHold(hm1);
        hh.role='Primary';
       
        VFCE02_HouseHoldSplit.HouseHold hh1 = new VFCE02_HouseHoldSplit.HouseHold(hm2);
        hh1.role='Spouse';
        
        VFCE02_HouseHoldSplit.HouseHold hh2 = new VFCE02_HouseHoldSplit.HouseHold(hm3);
        hh2.role='Spouse';
        
        
        VFCE02_HouseHoldSplit.HouseHold hh3 = new VFCE02_HouseHoldSplit.HouseHold(hm4);
        hh3.role='Dependent';
        
        controller.HouseHoldList.add(hh);
        controller.HouseHoldList.add(hh1);
        controller.HouseHoldList.add(hh2);
        controller.HouseHoldList.add(hh3);
     controller.getRelatedParties();
        controller.backMethod();
        controller.splitHouseHold();
        
        
      }
      static testmethod void testSplitHousehold3() {
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
        Test.setCurrentPageReference(new PageReference('Page.VFP02_HouseholdSplitPage'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE02_HouseHoldSplit controller = new VFCE02_HouseHoldSplit(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);
        controller.getRelatedParties();
        List<VFCE02_HouseHoldSplit.HouseHold> HouseHoldList=new List<VFCE02_HouseHoldSplit.HouseHold>();
        VFCE02_HouseHoldSplit.HouseHold hh = new VFCE02_HouseHoldSplit.HouseHold(hm1);
        hh.role='Primary';
       
        VFCE02_HouseHoldSplit.HouseHold hh1 = new VFCE02_HouseHoldSplit.HouseHold(hm2);
        hh1.role='Dependent';
        
        VFCE02_HouseHoldSplit.HouseHold hh2 = new VFCE02_HouseHoldSplit.HouseHold(hm3);
        hh2.role='Spouse';
        
        
        VFCE02_HouseHoldSplit.HouseHold hh3 = new VFCE02_HouseHoldSplit.HouseHold(hm4);
        hh3.role='Dependent';
        
        controller.HouseHoldList.add(hh);
        controller.HouseHoldList.add(hh1);
        controller.HouseHoldList.add(hh2);
        controller.HouseHoldList.add(hh3);
     controller.getRelatedParties();
        controller.backMethod();
        controller.splitHouseHold();
        
        
      }
      static testmethod void testSplitHousehold4() {
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
        Test.setCurrentPageReference(new PageReference('Page.VFP02_HouseholdSplitPage'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE02_HouseHoldSplit controller = new VFCE02_HouseHoldSplit(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);
        controller.getRelatedParties();
        List<VFCE02_HouseHoldSplit.HouseHold> HouseHoldList=new List<VFCE02_HouseHoldSplit.HouseHold>();
        VFCE02_HouseHoldSplit.HouseHold hh = new VFCE02_HouseHoldSplit.HouseHold(hm1);
        hh.role='--None--';
       
        VFCE02_HouseHoldSplit.HouseHold hh1 = new VFCE02_HouseHoldSplit.HouseHold(hm2);
        hh1.role='--None--';
        
        VFCE02_HouseHoldSplit.HouseHold hh2 = new VFCE02_HouseHoldSplit.HouseHold(hm3);
        hh2.role='--None--';
        
        
        VFCE02_HouseHoldSplit.HouseHold hh3 = new VFCE02_HouseHoldSplit.HouseHold(hm4);
        hh3.role='--None--';
        
        controller.HouseHoldList.add(hh);
        controller.HouseHoldList.add(hh1);
        controller.HouseHoldList.add(hh2);
        controller.HouseHoldList.add(hh3);
     controller.getRelatedParties();
        controller.backMethod();
        controller.splitHouseHold();
        
        
      }
      static testmethod void testSplitHousehold5()
{
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
        Test.setCurrentPageReference(new PageReference('Page.VFP02_HouseholdSplitPage'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE02_HouseHoldSplit controller = new VFCE02_HouseHoldSplit(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);
        controller.getRelatedParties();
        List<VFCE02_HouseHoldSplit.HouseHold> HouseHoldList=new List<VFCE02_HouseHoldSplit.HouseHold>();
        VFCE02_HouseHoldSplit.HouseHold hh = new VFCE02_HouseHoldSplit.HouseHold(hm1);
        hh.role='Primary';
        VFCE02_HouseHoldSplit.HouseHold hh1 = new VFCE02_HouseHoldSplit.HouseHold(hm2);
        hh1.role='Domestic Partner';
        VFCE02_HouseHoldSplit.HouseHold hh2 = new VFCE02_HouseHoldSplit.HouseHold(hm3);
        hh2.role='Domestic Partner';
        
        
        VFCE02_HouseHoldSplit.HouseHold hh3 = new VFCE02_HouseHoldSplit.HouseHold(hm4);
        hh3.role='Dependent';
        controller.HouseHoldList.add(hh);
        controller.HouseHoldList.add(hh1);
        controller.HouseHoldList.add(hh2);
        controller.HouseHoldList.add(hh3);
     controller.getRelatedParties();
        controller.backMethod();
        controller.splitHouseHold();
        
        
} 
}