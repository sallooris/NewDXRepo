trigger AccountAI on Account (after Insert) {
 List<RegistrationLayer__c> t= new List<RegistrationLayer__c>();
 
 For(Account a:Trigger.New){
 
   RegistrationLayer__c r= new RegistrationLayer__c();
   
    r.Id__c=a.Id;
    r.PointsYR1__c=a.NumberOfEmployees;
    r.RecordTypeId ='0121I000000R5aE';
    
    t.add(r);
}
insert t;
}