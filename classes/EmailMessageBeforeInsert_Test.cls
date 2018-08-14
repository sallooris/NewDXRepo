/*************************************************************
Trigger Name : EmailMessageBeforeInsert_Test 
Date Created : 25-Aug-2015
Created By   : Nagarjuna Kaipu
Description  : Test class for EmailMessageBeforeInsert trigger
Change History: 
*****************************************************************/
@isTest
private class EmailMessageBeforeInsert_Test {
    
    // Test setting of Tech Case Routing Address when an e-mail-to-case record is created
    static testMethod void testUpdateRoutingAddress() {
        
        User testUser=BR_Util01_TestMethods.CreateTestUser();
        insert(testUser);
        system.runAs(testUser){
            Id btsCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BTS Case').getRecordTypeId();
            Case c = new Case(Origin = 'Email - Test', Case_Origin_Custom__c = 'Email', Subject = 'Test Email To Case', Status = 'New', OwnerId = testUser.Id, RecordTypeId = btsCaseId);
            insert c;

            system.debug('Case inserted: '+c.OwnerId);
            EmailMessage[] newEmail = new EmailMessage[0];
            //will change the value of cc and bcc.
            newEmail.add(new EmailMessage(FromAddress = 'nagarjuna.kaipu@accenture.com', Incoming = True, ToAddress= 'kishore.jonnadula@accenture.com', Subject = 'Email to Case Test email', TextBody = 'Test', ParentId = c.Id, CcAddress = 'boss.redone@gmail.com', BccAddress = 'sir.redone@gmail.com')); 
            
            Test.startTest();  
            try
            {
                insert newEmail;
            }
            catch(Exception ex){
                  System.debug('Exception in Test Class'+ex.getMessage());
            }
            Test.stopTest(); 
                
             Case emailCase = [SELECT Id, Case_Origin_Custom__c , BR_Tech_Case_RoutingAddress__c FROM CASE WHERE ID =: c.Id];
             system.debug('Case after insert: '+emailCase.BR_Tech_Case_RoutingAddress__c);
             System.AssertEquals('kishore.jonnadula@accenture.com', emailCase.BR_Tech_Case_RoutingAddress__c);
        }
    }

    //Test case re-opening when an e-mail for a closed Case is received
    static testMethod void testCaseReopen() {
        
        User testUser=BR_Util01_TestMethods.CreateTestUser();
        insert(testUser);
        system.runAs(testUser){
            Id btsCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BTS Case').getRecordTypeId();
            Case c = new Case(Origin = 'Email', Subject = 'Test Email To Case', Status = 'New', OwnerId = testUser.Id, RecordTypeId = btsCaseId);
            insert c;

            // Close case
            c.Status = 'Closed';
            Update c;

            // Create new e-mail for case
            EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(FromAddress = 'nagarjuna.kaipu@accenture.com', Incoming = True, ToAddress= 'kishore.jonnadula@accenture.com', Subject = 'Email to Case Test email', TextBody = 'Test', ParentId = c.Id, CcAddress = 'boss.redone@gmail.com', BccAddress = 'sir.redone@gmail.com'));
            
            Test.startTest();  
            try
            {
                insert newEmail;
            }
            catch(Exception ex){
                System.debug('Exception in Test Class'+ex.getMessage());
            }
            Test.stopTest(); 
                
            Case emailCase = [SELECT Id, Status, OwnerId FROM CASE WHERE ID =: c.Id];
            
            //new Case status should be 'Closed - Reopen'
            System.AssertEquals('Closed - Reopen', emailCase.Status);
            
            //Case will have new owner based on existing Assignment Rules
            System.assert(c.OwnerId != emailCase.OwnerId);
        }
    }
}