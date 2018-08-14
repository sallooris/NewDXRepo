public class ManageMyBrokersController {

    public List<User> brokersList {get;set;}

    public void cancel() {
        brokersList  = [Select id,Name, Out_of_office__c,Language__c,Deactivate_Broker__c,IND__c,Back_up__c,IND_Only__c  from User Where IsActive = True and Sales_Rep__c =: Userinfo.getUserId()];
        //brokersList  = [Select id,Name, Out_of_office__c,Language__c,Deactivate_Broker__c,IND__c,IND_Only__c,Back_up__c  from User Where Sales_Rep__c =: '005e0000001zCPP'];
    }

    public void save() {
        ApexPages.Message myMsg ;
        try{
            List<User> userToUpdate = new List<User>();
            
            Map<id,User> preUser= new Map<id,User> ( [Select id,Name, Out_of_office__c,Language__c,Deactivate_Broker__c,IND__c ,Back_up__c,IND_Only__c    from User Where IsActive = True and Sales_Rep__c =: Userinfo.getUserId()]);  
            //Map<id,User> preUser= new Map<id,User> ( [Select id,Name, Out_of_office__c,Language__c,Deactivate_Broker__c,IND__c,Back_up__c,IND_Only__c    from User Where Sales_Rep__c =: '005e0000001zCPP']);       
        
            for(User newU: brokersList ){
                User oldU = preUser.get(newU.id);
                system.debug(newU.IND_Only__c);
                if(newU.Out_of_office__c!=oldU.Out_of_office__c || newU.Deactivate_Broker__c !=oldU.Deactivate_Broker__c || newU.IND__c  !=oldU.IND__c  || newU.Language__c!=oldU.Language__c || newU.Back_up__c!=oldU.Back_up__c || newU.IND_Only__c!=oldU.IND_Only__c      )
                    if(newU.IND_Only__c)
                        newU.IND__c = true;
                    userToUpdate.add(newU);
            }
            
            if(userToUpdate.size()>0){
                update userToUpdate;
                myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Changes have been saved');
                ApexPages.addMessage(myMsg);
            }
        }catch(exception e){
            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage());
            ApexPages.addMessage(myMsg);
        }
        
    }

    public ManageMyBrokersController (){
        brokersList  = [Select id,Name, Out_of_office__c,Language__c,Deactivate_Broker__c,IND__c  ,Back_up__c,IND_Only__c   from User  Where  IsActive = True and  Sales_Rep__c =: Userinfo.getUserId()];
        //brokersList  = [Select id,Name, Out_of_office__c,Language__c,Deactivate_Broker__c,IND__c ,Back_up__c,IND_Only__c     from User Where Sales_Rep__c =: '005e0000001zCPP'];
        
        
        if(brokersList.size()==0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'No brokers to display');
            ApexPages.addMessage(myMsg);
        }
    }
    
}