public class VFCE06_PostChatSurvey{
    public Live_Agent_Chat_Survey__c lacs {get;set;}
    public Static String chatterKey{
        get;
        set {
            chatterKey = value;
        }
    }
    public VFCE06_PostChatSurvey(ApexPages.StandardController controller) {
        this.lacs = (Live_Agent_Chat_Survey__c)controller.getRecord();
    }
    public PageReference submit(){
        lacs.chatKey__c = chatterKey;
        if(lacs.Please_rate_your_chat_experience__c != NULL || lacs.Please_rate_your_operator__c != NULL || 
            lacs.Comments__c != NULL){
            insert lacs;
        }
        return new PageReference('javascript:window.close();');
    }
}