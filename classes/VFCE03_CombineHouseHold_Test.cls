@isTest
public class VFCE03_CombineHouseHold_Test{
    
    static testmethod void testnext1() {
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
        
        Test.setCurrentPageReference(new PageReference('Page.VFP03_SelectAccountToCombine'));
        String accountId = System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE03_CombineHouseHold controller = new VFCE03_CombineHouseHold(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);
        controller.houseSearchText = '';
        controller.searchHouseHold();
        controller.houseSearchText = '';
        controller.next();
    controller.houseSearchText = 'First';
    controller.searchHouseHold();
    controller.next();
    controller.houseSearchText = 'First';
    controller.searchHouseHold();
    controller.selectedRecord = a1.id;
    controller.next();
    Account a2 = Util02_TestData.insertAccount();
        a2.recordtypeId = accRT ;
        insert a2;
    a2.firstname = 'Second';
    a2.lastname = 'Name';
    update a2;
        Household_Member__c hm5 = Util02_TestData.insertHousehold();
        hm5.Household_ID__c=a2.id;
        insert hm5;
         Household_Member__c hm6 = Util02_TestData.insertHousehold();
        hm6.Household_ID__c=a2.id;
        insert hm6;
        Household_Member__c hm7 = Util02_TestData.insertHousehold();
        hm7.Household_ID__c=a2.id;
        insert hm7;

    controller.houseSearchText = 'Second';
    controller.searchHouseHold();
    controller.selectedRecord = a2.id;
    controller.next();
}

    static testmethod void testnext2() {
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
    
    Test.setCurrentPageReference(new PageReference('Page.VFP03_SelectAccountToCombine'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE03_CombineHouseHold controller = new VFCE03_CombineHouseHold(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);

    Account a2 = Util02_TestData.insertAccount();
        a2.recordtypeId = accRT ;
        insert a2;
    a2.firstname = 'Second';
    a2.lastname = 'Name';
    update a2;
        Household_Member__c hm5 = Util02_TestData.insertHousehold();
        hm5.Household_ID__c=a2.id;
        insert hm5;
         Household_Member__c hm6 = Util02_TestData.insertHousehold();
        hm6.Household_ID__c=a2.id;
        insert hm6;
        Household_Member__c hm7 = Util02_TestData.insertHousehold();
        hm7.Household_ID__c=a2.id;
        insert hm7;

    controller.houseSearchText = 'Second';
    controller.searchHouseHold();
    controller.selectedRecord = a2.id;
    controller.next();
    
    for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where id=:a2.id AND Tech_Businesstrack__c='TELESALES']) {
                    controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(a));
         }
        for(Household_Member__c rParty : [select Id,name,age__c,gender__c,date_of_birth__c,first_name__c, last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:a2.id]){
                controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(rParty));
         }
    controller.getRelatedParties();
    controller.getRelatedPartiesPrimary();
    VFCE03_CombineHouseHold.HouseHold h1h = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h1h.role='Primary';
       
        VFCE03_CombineHouseHold.HouseHold h1h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h1h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h1h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h1h2.role='Primary';
    
    controller.HouseHoldList1.add(h1h);
        controller.HouseHoldList1.add(h1h1);
        controller.HouseHoldList1.add(h1h2);
    
    controller.combineHouseHold();
}

 static testmethod void testnext3() {
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
    
    Test.setCurrentPageReference(new PageReference('Page.VFP03_SelectAccountToCombine'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE03_CombineHouseHold controller = new VFCE03_CombineHouseHold(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);

    Account a2 = Util02_TestData.insertAccount();
        a2.recordtypeId = accRT ;
        insert a2;
    a2.firstname = 'Second';
    a2.lastname = 'Name';
    update a2;
        Household_Member__c hm5 = Util02_TestData.insertHousehold();
        hm5.Household_ID__c=a2.id;
        insert hm5;
         Household_Member__c hm6 = Util02_TestData.insertHousehold();
        hm6.Household_ID__c=a2.id;
        insert hm6;
        Household_Member__c hm7 = Util02_TestData.insertHousehold();
        hm7.Household_ID__c=a2.id;
        insert hm7;

    controller.houseSearchText = 'Second';
    controller.searchHouseHold();
    controller.selectedRecord = a2.id;
    controller.next();
    
    for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where id=:a2.id AND Tech_Businesstrack__c='TELESALES']) {
                    controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(a));
         }
        for(Household_Member__c rParty : [select Id,name,age__c,gender__c,date_of_birth__c,last_name__c, first_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:a2.id]){
                controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(rParty));
         }
    controller.getRelatedParties();
    controller.getRelatedPartiesPrimary();

    VFCE03_CombineHouseHold.HouseHold h2h = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h2h.role='Spouse';
       
        VFCE03_CombineHouseHold.HouseHold h2h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h2h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h2h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h2h2.role='Spouse';
    
    controller.HouseHoldList1.add(h2h);
        controller.HouseHoldList1.add(h2h1);
        controller.HouseHoldList1.add(h2h2);
    
    controller.combineHouseHold();
}
 static testmethod void testnext4() {
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
    
    Test.setCurrentPageReference(new PageReference('Page.VFP03_SelectAccountToCombine'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE03_CombineHouseHold controller = new VFCE03_CombineHouseHold(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);

    Account a2 = Util02_TestData.insertAccount();
        a2.recordtypeId = accRT ;
        insert a2;
    a2.firstname = 'Second';
    a2.lastname = 'Name';
    update a2;
        Household_Member__c hm5 = Util02_TestData.insertHousehold();
        hm5.Household_ID__c=a2.id;
        insert hm5;
         Household_Member__c hm6 = Util02_TestData.insertHousehold();
        hm6.Household_ID__c=a2.id;
        insert hm6;
        Household_Member__c hm7 = Util02_TestData.insertHousehold();
        hm7.Household_ID__c=a2.id;
        insert hm7;

    controller.houseSearchText = 'Second';
    controller.searchHouseHold();
    controller.selectedRecord = a2.id;
    controller.next();
    
    for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where id=:a2.id AND Tech_Businesstrack__c='TELESALES']) {
                    controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(a));
         }
        for(Household_Member__c rParty : [select Id,name,age__c,gender__c,date_of_birth__c,last_name__c, first_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:a2.id]){
                controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(rParty));
         }
    controller.getRelatedParties();
    controller.getRelatedPartiesPrimary();
    VFCE03_CombineHouseHold.HouseHold h3h = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h3h.role='Domestic Partner';
       
        VFCE03_CombineHouseHold.HouseHold h3h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h3h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h3h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h3h2.role='Domestic Partner';
    
    controller.HouseHoldList1.add(h3h);
        controller.HouseHoldList1.add(h3h1);
        controller.HouseHoldList1.add(h3h2);
        
    controller.combineHouseHold();
}
 static testmethod void testnext5() {
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
    
    Test.setCurrentPageReference(new PageReference('Page.VFP03_SelectAccountToCombine'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE03_CombineHouseHold controller = new VFCE03_CombineHouseHold(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);

    Account a2 = Util02_TestData.insertAccount();
        a2.recordtypeId = accRT ;
        insert a2;
    a2.firstname = 'Second';
    a2.lastname = 'Name';
    update a2;
        Household_Member__c hm5 = Util02_TestData.insertHousehold();
        hm5.Household_ID__c=a2.id;
        insert hm5;
         Household_Member__c hm6 = Util02_TestData.insertHousehold();
        hm6.Household_ID__c=a2.id;
        insert hm6;
        Household_Member__c hm7 = Util02_TestData.insertHousehold();
        hm7.Household_ID__c=a2.id;
        insert hm7;

    controller.houseSearchText = 'Second';
    controller.searchHouseHold();
    controller.selectedRecord = a2.id;
    controller.next();
    
    for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where id=:a2.id AND Tech_Businesstrack__c='TELESALES']) {
                    controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(a));
         }
        for(Household_Member__c rParty : [select Id,name,age__c,gender__c,date_of_birth__c, first_name__c, last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:a2.id]){
                controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(rParty));
         }
    controller.getRelatedParties();
    controller.getRelatedPartiesPrimary();
    VFCE03_CombineHouseHold.HouseHold h4h = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h4h.role='--None--';
       
        VFCE03_CombineHouseHold.HouseHold h4h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h4h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h4h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h4h2.role='Domestic Partner';
    
    controller.HouseHoldList1.add(h4h);
        controller.HouseHoldList1.add(h4h1);
        controller.HouseHoldList1.add(h4h2);
    
    controller.combineHouseHold();

  }
   static testmethod void testnext6() {
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
    
    Test.setCurrentPageReference(new PageReference('Page.VFP03_SelectAccountToCombine'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE03_CombineHouseHold controller = new VFCE03_CombineHouseHold(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);

    Account a2 = Util02_TestData.insertAccount();
        a2.recordtypeId = accRT ;
        insert a2;
    a2.firstname = 'Second';
    a2.lastname = 'Name';
    update a2;
        Household_Member__c hm5 = Util02_TestData.insertHousehold();
        hm5.Household_ID__c=a2.id;
        insert hm5;
         Household_Member__c hm6 = Util02_TestData.insertHousehold();
        hm6.Household_ID__c=a2.id;
        insert hm6;
        Household_Member__c hm7 = Util02_TestData.insertHousehold();
        hm7.Household_ID__c=a2.id;
        insert hm7;

    controller.houseSearchText = 'Second';
    controller.searchHouseHold();
    controller.selectedRecord = a2.id;
    controller.next();
    
    for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where id=:a2.id AND Tech_Businesstrack__c='TELESALES']) {
                    controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(a));
         }
        for(Household_Member__c rParty : [select Id,name,age__c,gender__c,date_of_birth__c, first_name__c, last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:a2.id]){
                controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(rParty));
         }
    controller.getRelatedParties();
    controller.getRelatedPartiesPrimary();
    VFCE03_CombineHouseHold.HouseHold h4h = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h4h.role='Primary';
       
        VFCE03_CombineHouseHold.HouseHold h4h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h4h1.role='Primary';
        
    VFCE03_CombineHouseHold.HouseHold h4h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h4h2.role='Domestic Partner';
    
    controller.HouseHoldList2.add(h4h);
        controller.HouseHoldList2.add(h4h1);
        controller.HouseHoldList2.add(h4h2);
    
    controller.combineHouseHold();

  }
  static testmethod void testnext7() {
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
    
    Test.setCurrentPageReference(new PageReference('Page.VFP03_SelectAccountToCombine'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE03_CombineHouseHold controller = new VFCE03_CombineHouseHold(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);

    Account a2 = Util02_TestData.insertAccount();
        a2.recordtypeId = accRT ;
        insert a2;
    a2.firstname = 'Second';
    a2.lastname = 'Name';
    update a2;
        Household_Member__c hm5 = Util02_TestData.insertHousehold();
        hm5.Household_ID__c=a2.id;
        insert hm5;
         Household_Member__c hm6 = Util02_TestData.insertHousehold();
        hm6.Household_ID__c=a2.id;
        insert hm6;
        Household_Member__c hm7 = Util02_TestData.insertHousehold();
        hm7.Household_ID__c=a2.id;
        insert hm7;

    controller.houseSearchText = 'Second';
    controller.searchHouseHold();
    controller.selectedRecord = a2.id;
    controller.next();
    
    for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where id=:a2.id AND Tech_Businesstrack__c='TELESALES']) {
                    controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(a));
         }
        for(Household_Member__c rParty : [select Id,name,age__c,gender__c,date_of_birth__c, first_name__c, last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:a2.id]){
                controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(rParty));
         }
    controller.getRelatedParties();
    controller.getRelatedPartiesPrimary();

    VFCE03_CombineHouseHold.HouseHold h2h = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h2h.role='Spouse';
       
        VFCE03_CombineHouseHold.HouseHold h2h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h2h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h2h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h2h2.role='Spouse';
    
    controller.HouseHoldList2.add(h2h);
        controller.HouseHoldList2.add(h2h1);
        controller.HouseHoldList2.add(h2h2);
    
    controller.combineHouseHold();
}
 static testmethod void testnext8() {
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
    
    Test.setCurrentPageReference(new PageReference('Page.VFP03_SelectAccountToCombine'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE03_CombineHouseHold controller = new VFCE03_CombineHouseHold(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);

    Account a2 = Util02_TestData.insertAccount();
        a2.recordtypeId = accRT ;
        insert a2;
    a2.firstname = 'Second';
    a2.lastname = 'Name';
    update a2;
        Household_Member__c hm5 = Util02_TestData.insertHousehold();
        hm5.Household_ID__c=a2.id;
        insert hm5;
         Household_Member__c hm6 = Util02_TestData.insertHousehold();
        hm6.Household_ID__c=a2.id;
        insert hm6;
        Household_Member__c hm7 = Util02_TestData.insertHousehold();
        hm7.Household_ID__c=a2.id;
        insert hm7;

    controller.houseSearchText = 'Second';
    controller.searchHouseHold();
    controller.selectedRecord = a2.id;
    controller.next();
    
    for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where id=:a2.id AND Tech_Businesstrack__c='TELESALES']) {
                    controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(a));
         }
        for(Household_Member__c rParty : [select Id,name,age__c,gender__c,date_of_birth__c, first_name__c, last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:a2.id]){
                controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(rParty));
         }
    controller.getRelatedParties();
    controller.getRelatedPartiesPrimary();
    VFCE03_CombineHouseHold.HouseHold h3h = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h3h.role='Domestic Partner';
       
        VFCE03_CombineHouseHold.HouseHold h3h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h3h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h3h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h3h2.role='Domestic Partner';
    
    controller.HouseHoldList2.add(h3h);
        controller.HouseHoldList2.add(h3h1);
        controller.HouseHoldList2.add(h3h2);
        
    controller.combineHouseHold();
}
 static testmethod void testnext9() {
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
    
    Test.setCurrentPageReference(new PageReference('Page.VFP03_SelectAccountToCombine'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE03_CombineHouseHold controller = new VFCE03_CombineHouseHold(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);

    Account a2 = Util02_TestData.insertAccount();
        a2.recordtypeId = accRT ;
        insert a2;
    a2.firstname = 'Second';
    a2.lastname = 'Name';
    update a2;
        Household_Member__c hm5 = Util02_TestData.insertHousehold();
        hm5.Household_ID__c=a2.id;
        insert hm5;
         Household_Member__c hm6 = Util02_TestData.insertHousehold();
        hm6.Household_ID__c=a2.id;
        insert hm6;
        Household_Member__c hm7 = Util02_TestData.insertHousehold();
        hm7.Household_ID__c=a2.id;
        insert hm7;

    controller.houseSearchText = 'Second';
    controller.searchHouseHold();
    controller.selectedRecord = a2.id;
    controller.next();
    
    for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where id=:a2.id AND Tech_Businesstrack__c='TELESALES']) {
                    controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(a));
         }
        for(Household_Member__c rParty : [select Id,name,age__c,gender__c,date_of_birth__c, first_name__c, last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:a2.id]){
                controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(rParty));
         }
    controller.getRelatedParties();
    controller.getRelatedPartiesPrimary();
    VFCE03_CombineHouseHold.HouseHold h4h = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h4h.role='--None--';
       
        VFCE03_CombineHouseHold.HouseHold h4h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h4h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h4h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h4h2.role='Domestic Partner';
    
    controller.HouseHoldList2.add(h4h);
        controller.HouseHoldList2.add(h4h1);
        controller.HouseHoldList2.add(h4h2);
    
    controller.combineHouseHold();

  }
  static testmethod void testnext10() {
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
    
    Test.setCurrentPageReference(new PageReference('Page.VFP03_SelectAccountToCombine'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE03_CombineHouseHold controller = new VFCE03_CombineHouseHold(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);

    Account a2 = Util02_TestData.insertAccount();
        a2.recordtypeId = accRT ;
        insert a2;
    a2.firstname = 'Second';
    a2.lastname = 'Name';
    update a2;
        Household_Member__c hm5 = Util02_TestData.insertHousehold();
        hm5.Household_ID__c=a2.id;
        insert hm5;
         Household_Member__c hm6 = Util02_TestData.insertHousehold();
        hm6.Household_ID__c=a2.id;
        insert hm6;
        Household_Member__c hm7 = Util02_TestData.insertHousehold();
        hm7.Household_ID__c=a2.id;
        insert hm7;

    controller.houseSearchText = 'Second';
    controller.searchHouseHold();
    controller.selectedRecord = a2.id;
    controller.next();
    
    for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where id=:a2.id AND Tech_Businesstrack__c='TELESALES']) {
                    controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(a));
         }
        for(Household_Member__c rParty : [select Id,name,age__c,gender__c,date_of_birth__c, first_name__c, last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:a2.id]){
                controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(rParty));
         }
    controller.getRelatedParties();
    controller.getRelatedPartiesPrimary();
    VFCE03_CombineHouseHold.HouseHold h3h = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h3h.role='Domestic Partner';
       
        VFCE03_CombineHouseHold.HouseHold h3h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h3h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h3h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h3h2.role='Dependent';
    
    controller.HouseHoldList1.add(h3h);
        controller.HouseHoldList1.add(h3h1);
        controller.HouseHoldList1.add(h3h2);

    VFCE03_CombineHouseHold.HouseHold h4h = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h4h.role='Dependent';
       
        VFCE03_CombineHouseHold.HouseHold h4h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h4h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h4h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h4h2.role='Spouse';
    
    controller.HouseHoldList2.add(h4h);
        controller.HouseHoldList2.add(h4h1);
        controller.HouseHoldList2.add(h4h2);
    
    controller.combineHouseHold();

  }
   static testmethod void testnext11() {
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
    
    Test.setCurrentPageReference(new PageReference('Page.VFP03_SelectAccountToCombine'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE03_CombineHouseHold controller = new VFCE03_CombineHouseHold(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);

    Account a2 = Util02_TestData.insertAccount();
    a2.recordtypeId = accRT ;
        insert a2;
    a2.firstname = 'Second';
    a2.lastname = 'Name';
    update a2;
        Household_Member__c hm5 = Util02_TestData.insertHousehold();
        hm5.Household_ID__c=a2.id;
        insert hm5;
         Household_Member__c hm6 = Util02_TestData.insertHousehold();
        hm6.Household_ID__c=a2.id;
        insert hm6;
        Household_Member__c hm7 = Util02_TestData.insertHousehold();
        hm7.Household_ID__c=a2.id;
        insert hm7;

    controller.houseSearchText = 'Second';
    controller.searchHouseHold();
    controller.selectedRecord = a2.id;
    controller.next();
    
    for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where id=:a2.id AND Tech_Businesstrack__c='TELESALES']) {
                    controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(a));
         }
        for(Household_Member__c rParty : [select Id,name,age__c,gender__c,date_of_birth__c, first_name__c, last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:a2.id]){
                controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(rParty));
         }
    controller.getRelatedParties();
    controller.getRelatedPartiesPrimary();
    controller.backMethod();
    VFCE03_CombineHouseHold.HouseHold h3h = new VFCE03_CombineHouseHold.HouseHold(a1);
        h3h.role='Primary';
       
        VFCE03_CombineHouseHold.HouseHold h3h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h3h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h3h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h3h2.role='Domestic Partner';
    
    controller.HouseHoldList1.add(h3h);
        controller.HouseHoldList1.add(h3h1);
        controller.HouseHoldList1.add(h3h2);

    VFCE03_CombineHouseHold.HouseHold h4h = new VFCE03_CombineHouseHold.HouseHold(a2);
        h4h.role='Dependent';
       
        VFCE03_CombineHouseHold.HouseHold h4h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h4h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h4h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h4h2.role='Spouse';
    
    controller.HouseHoldList2.add(h4h);
        controller.HouseHoldList2.add(h4h1);
        controller.HouseHoldList2.add(h4h2);
    controller.primarySelected = 'FirstAccount';
    controller.selectedHousehold='SecondAccount';
    controller.combineHouseHold();

  }
  static testmethod void testnext12() {
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
    
    Test.setCurrentPageReference(new PageReference('Page.VFP03_SelectAccountToCombine'));
        System.currentPageReference().getParameters().put('id', a1.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a1);
        VFCE03_CombineHouseHold controller = new VFCE03_CombineHouseHold(sc);
        System.assertEquals(ApexPages.currentpage().getparameters().get('id'),a1.id);

    Account a2 = Util02_TestData.insertAccount();
    a2.recordtypeId = accRT ;
        insert a2;
    a2.firstname = 'Second';
    a2.lastname = 'Name';
    update a2;
        Household_Member__c hm5 = Util02_TestData.insertHousehold();
        hm5.Household_ID__c=a2.id;
        insert hm5;
         Household_Member__c hm6 = Util02_TestData.insertHousehold();
        hm6.Household_ID__c=a2.id;
        insert hm6;
        Household_Member__c hm7 = Util02_TestData.insertHousehold();
        hm7.Household_ID__c=a2.id;
        insert hm7;

    controller.houseSearchText = 'Second';
    controller.searchHouseHold();
    controller.selectedRecord = a2.id;
    controller.next();
    
    for(Account a: [select Id, firstname,lastname,age__c,gender__c,Tobacco_User__c,date_of_birth__c from Account where id=:a2.id AND Tech_Businesstrack__c='TELESALES']) {
                    controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(a));
         }
        for(Household_Member__c rParty : [select Id,name,age__c,gender__c,date_of_birth__c, first_name__c, last_name__c,Tobacco_User__c,Relationship_Type__c from Household_Member__c where Household_ID__c=:a2.id]){
                controller.HouseHoldList2.add(new VFCE03_CombineHouseHold.HouseHold(rParty));
         }
    controller.getRelatedParties();
    controller.getRelatedPartiesPrimary();
    VFCE03_CombineHouseHold.HouseHold h3h = new VFCE03_CombineHouseHold.HouseHold(a1);
        h3h.role='Domestic Partner';
       
        VFCE03_CombineHouseHold.HouseHold h3h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h3h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h3h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h3h2.role='Dependent';
    
    controller.HouseHoldList1.add(h3h);
        controller.HouseHoldList1.add(h3h1);
        controller.HouseHoldList1.add(h3h2);

    VFCE03_CombineHouseHold.HouseHold h4h = new VFCE03_CombineHouseHold.HouseHold(a2);
        h4h.role='Primary';
       
        VFCE03_CombineHouseHold.HouseHold h4h1 = new VFCE03_CombineHouseHold.HouseHold(hm2);
        h4h1.role='Dependent';
        
    VFCE03_CombineHouseHold.HouseHold h4h2 = new VFCE03_CombineHouseHold.HouseHold(hm1);
        h4h2.role='Spouse';
    
    controller.HouseHoldList2.add(h4h);
        controller.HouseHoldList2.add(h4h1);
        controller.HouseHoldList2.add(h4h2);
    controller.primarySelected='SecondAccount';
    controller.selectedHousehold='FirstAccount';
    controller.combineHouseHold();

  }
 }