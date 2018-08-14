public with sharing class UpdateUserInfoController {

    public boolean showBackUpField {get;set;}
    public  User currentUser {get;set;}
    public  Boolean checkBox {get;set;}
    public String brokerProfile {get;set;}
     
    public UpdateUserInfoController(){
        this.brokerProfile = AnthemOppsProfiles.brokerProfile.id;
             
        showBackUpField =false; 
        currentUser =  [Select id, Out_of_office__c , Language__c,Back_up__c, profileID  from User Where id =: Userinfo.getUserId()];
        if(currentUser.Back_up__c !=null){
            checkBox=true;
            showBackUpField =true;   
        }        
    }
        
    public PageReference saveUser(){
        ApexPages.Message myMsg;
        try{
            if(!showBackUpField)
                currentUser.Back_up__c =null;
                
            if(showBackUpField && currentUser.Back_up__c==null ){
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Back-up user is needed');
            }else{
                update currentUser;
                myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Changes saved');
            }
        }catch (exception e){
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
        }
        ApexPages.addMessage(myMsg);
    return null;            
            
    }
        
    public void showBackup() {
        if(!showBackUpField )
            showBackUpField=true;
        else
            showBackUpField=false;
    }        

}