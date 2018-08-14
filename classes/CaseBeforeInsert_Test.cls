/**********************************************
 * Name:    CaseBeforeInsert_Test
 * Purpose:   Test class for Case before insert
 * @author: Rayson Landeta
 * @Date:   06-15-2013
 *********************************************/
@isTest
Public class CaseBeforeInsert_Test{ 
    // Test for the routing email address to change for BTS    
    public static testMethod void testCaseBeforeInsertBTS(){  
        Department_Email__c de1 = new Department_Email__c(Name = 'BTS', Email__c = 'test@email.com');
        insert de1;
        Department_Email__c de2 = new Department_Email__c(Name = 'Sales Support', Email__c = 'test1@email.com');
        insert de2;
        User testUser = BR_Util01_TestMethods.CreateTestUser();
        Case c = new Case(Origin = 'Phone', Subject = 'Test Email To Case', Status = 'New', BR_Department__c = 'BTS');
        
        Test.StartTest();
        System.runAs(testUser) {
            insert c;
        }
        Test.StopTest();
        
        Case emailCase = [SELECT Id, BR_Tech_Case_RoutingAddress__c FROM CASE WHERE ID =: c.Id];
        //case record should have email address for BTS as Case Routing Address
        //System.AssertEquals('test@email.com', emailCase.BR_Tech_Case_RoutingAddress__c);
    }
    
    // Test for the routing email address to change for Sales Support    
    public static testMethod void testCaseBeforeInsertSS(){  
        Department_Email__c de1 = new Department_Email__c(Name = 'BTS', Email__c = 'test@email.com');
        insert de1;
        Department_Email__c de2 = new Department_Email__c(Name = 'Sales Support', Email__c = 'test1@email.com');
        insert de2;
        User testUser = BR_Util01_TestMethods.CreateTestUser();
        Case c = new Case(Origin = 'Phone', Subject = 'Test Email To Case', Status = 'New', BR_Department__c = 'Sales Support');

        Test.StartTest();
            System.runAs(testUser) {
                insert c;
            }
        Test.StopTest();
        
        Case emailCase = [SELECT Id, BR_Tech_Case_RoutingAddress__c FROM CASE WHERE ID =: c.Id];
        //case record should have email address for Sales Support as Case Routing Address
        //System.AssertEquals('test1@email.com', emailCase.BR_Tech_Case_RoutingAddress__c);
    }

    // Test for populating Original Subject and Description upon Case creation
    public static testMethod void testOrigSubjectAndDescOnCaseInsert(){  

        User testUser = BR_Util01_TestMethods.CreateTestUser();
        Case c = new Case(Origin = 'Email', Subject = 'Test Email To Case', Status = 'New', Description='Test Description');
                
        Test.StartTest();
            System.runAs(testUser) {
                insert c;
            }
        Test.StopTest();
        
        Case emailCase = [SELECT Id, Subject, Description, OriginalSubject__c, OriginalDescription__c FROM CASE WHERE ID =: c.Id];
        // Original Subject should be the same as the created case record's subject
        //System.AssertEquals(c.Subject, emailCase.OriginalSubject__c);
        // Original Description should be the same as the created case record's description
        //System.AssertEquals(c.Description, emailCase.OriginalDescription__c);
    }

    // Test setting of Case Origin Custom Field
    public static testMethod void testCaseOriginCustom(){  

        User testUser = BR_Util01_TestMethods.CreateTestUser();
        List<Case> cList = new List<Case>();
        cList.add(new Case(Origin = 'Email - Test', Subject = 'Test Email To Case', Status = 'New', Description='Test Description'));
        CList.add(new Case(Case_Origin_Custom__c = 'Phone', Subject = 'Test Email To Case', Status = 'New', Description='Test Description'));
        

        Test.StartTest();
            System.runAs(testUser) {
                insert cList;
            }
        Test.StopTest();
        
        Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, origin, Case_Origin_Custom__c FROM CASE WHERE ID =: cList]);
        // Value of the Case Origin Custom field should be 'Email' for the 1st case
        //System.AssertEquals('Email', caseMap.get(cList[0].Id).Case_Origin_Custom__c);
        // Value of the Case Origin  field should be the same with the Case Origin Custom field for the 2nd case
        //System.AssertEquals(cList[1].Case_Origin_Custom__c, caseMap.get(cList[1].Id).Origin);
    }
}