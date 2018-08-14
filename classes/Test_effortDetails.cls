/**
   @Author - Shashank Singhal
   
   @name - Test_updateReleaseLOE
   
   @CreateDate - 01/16/2014
   
   @Description - Test class to test the case scenarios for the controller class effortDetails
                  
   @Version - 1.0
   
   @reference - None
  */
@isTest
private class Test_effortDetails{

    /**
    *  Description -  This method is a test method that creates the test data to cover different scenarios
    *
    *  @name - testEffortDetails
    *
    *  @param - None
    *
    *  @return - None
    *
    *  @throws exception- None
    */
    public static testMethod void testEffortDetails()
    {
         // this will store the request records which will be inserted
        List<Request__c> requestList = new List<Request__c>();
        
        //Creating capability record which will be used in Request creation
        Capability__c capability = new Capability__c();
        capability.name='Lead';
        insert capability;
    
        //creating project record which will be used in Release and Request creation
        Project__c project = new Project__c();
        project.name='Telesales';
        insert project;

        // creating release record which will be the parent record for the requests record
        Release__c release = PMODataUnitHelper.insertReleaseForRequest('Test Release' + 1);
        release.Project__c=project.id;
        // Inserting release record
        insert(release);
        
        // Creating request records
        for (Integer countRequest = 0; countRequest < 200; countRequest++)
        {
          Request__c currentRequest = PMODataUnitHelper.insertRequest('Test Request' + countRequest,release.Id);
          currentRequest.Project__c = project.id;
          currentRequest.Capability__c = capability.id;
          requestList.add(currentRequest);
        }  
        
        // Test scenario starts here
        Test.startTest();
        
        // Inserting list of requests
        insert(requestList); 
        
        // Initialise the parameterised constructor of the controller 
        ApexPages.StandardController stdCont = new ApexPages.StandardController(release);
        effortdetails controller = new effortdetails(stdCont); 
        
        // Test scenario ends here
        Test.stopTest();
        
        List<Request__c> insertedRequest = [SELECT TotEst__c
                                            FROM Request__c
                                            WHERE Id IN: requestList];
    
        // Checking if the size of reteived records is equal or not to size of inserted records
        System.assertEquals(requestList.size(),200,'Number of request record returned is incorrect.The result has '+ 
                            requestList.size()+' records-Expected 200');
        
    }

}