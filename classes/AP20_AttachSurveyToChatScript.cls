public class AP20_AttachSurveyToChatScript{
    public static boolean isBeforeIsertFirstRun = true;
    Set<String> chatKeys = new Set<String>();
    Map<String,String> liveChatSurveyMap = new Map<String,String>();
    Map<String,ID> liveChatSurveyMap2 = new Map<String,ID>();
    public void attachSurveyTranscript(List<Live_Agent_Chat_Survey__c> surveyList){
        for(Live_Agent_Chat_Survey__c lacs : surveyList){
             if(lacs.chatKey__c != NULL && lacs.chatKey__c != '')
                 liveChatSurveyMap.put(lacs.chatKey__c,null);
        }
        if(!liveChatSurveyMap.isEmpty()){
            List<LiveChatTranscript> lct = [select id,name,chatKey from LiveChatTranscript where chatKey in : liveChatSurveyMap.keySet()];
            for(LiveChatTranscript lc : lct){
                if(liveChatSurveyMap.containsKey(lc.chatKey)){
                    liveChatSurveyMap2.put(lc.chatKey,lc.id);
                }
            }
            for(Live_Agent_Chat_Survey__c lacs : surveyList){
                if(liveChatSurveyMap2.containsKey(lacs.chatKey__c)){
                    lacs.Live_Chat_Transcript_ID__c = liveChatSurveyMap2.get(lacs.chatKey__c);
                }
            }
       }
    }
}