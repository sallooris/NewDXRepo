@isTest
    public class sortTest{
    public static testMethod void sortAscendingTest(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List;
        Account Acc=new Account(Name='Alcero');
        Acc.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Business%' LIMIT 1].id;
        insert Acc;
        // DC
//        Account account= [Select id,name from Account where name='Alcero'];
        Account account= [Select id,name from Account where Id =: Acc.Id];
        // DC
        Contact contact= new Contact();
        //contact.Due_Date__c=System.now();
        contact.FirstName='Test';
        contact.LastName='LicenseTrigger';
        contact.AccountId=account.id;
        
        insert contact;
        
        List<Sobject> s = new List<Sobject>();
        s.add(contact);
        Test.startTest();
        
        Long start = system.currentTimeMillis();
        
        superSort.sortList(s,'AccountID','asc');
        
        system.debug(system.currentTimeMillis() - start);
        
        Test.stopTest(); 

       
    }
    
    public static testMethod void sortDescendingTest(){
        List<CS001_RecordTypeBusinessTrack__c> cs001List = Util02_TestData.createCS001Data();
        insert cs001List; 
        List<CS002_RTypeAssignOnLeadConvert__c> cs002List = Util02_TestData.createCS002Data();
        insert cs002List; 
        List<Opportunity> opps = new List<Opportunity>();
        for(integer i = 0; i<1000; i++){
            opps.add(new Opportunity(Name = 'test' + i, StageName ='Closed/Won',CloseDate = System.today(),Amount = 1000 * Math.random()));
        }
        
        Test.startTest();
        insert opps;
        superSort.sortList(opps,'Id','asc');
        Test.stopTest();
        
       
        Decimal assertValue = 1001;
       
    }
    }