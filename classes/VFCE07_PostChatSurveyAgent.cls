public class VFCE07_PostChatSurveyAgent{
    public Live_Agent_Chat_Survey__c lacs {get;set;}
    public String cId= null;
    LiveChatTranscript lct;
    public VFCE07_PostChatSurveyAgent(ApexPages.StandardController controller) {
        this.lacs = (Live_Agent_Chat_Survey__c)controller.getRecord();
    }
    public PageReference submit(){
        this.cId = ApexPages.currentpage().getparameters().get('cid');
        try{
            if(cId.startsWith('00Q')){
                List<Lead> ld = [select id,(select id from LiveChatTranscripts order by createddate desc limit 1) from Lead where id=:cId];
                for(Lead l : ld){
                    lct = l.LiveChatTranscripts;
                }
            }else if(cId.startsWith('001')){
                List<Account> acc = [select id,(select id from LiveChatTranscripts order by createddate desc limit 1) from Account where id=:cId];
                for(Account a : acc){
                    lct = a.LiveChatTranscripts;
                }
              //  lct = [Select id from LiveChatTranscript where AccountID =:cId ORDER BY CreatedDate DESC LIMIT 1];
            }
            if(lct == null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Chat Script Added for this Record');
                ApexPages.addMessage(myMsg);
                return null;
            }else{
                lacs.Live_Chat_Transcript_ID__c = lct.id;
                insert lacs;
            }
            return new PageReference('javascript:window.close();');
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Chat Script Added for this Record');
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
}