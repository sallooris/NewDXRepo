/**********************************************************************************
Class Name :   SGA_AP10_AttachQuotePDFToQuote
Date Created : 13-June-2017
Created By   : IDC Offshore
Description  : 1. This class is used to generate and attach the quote to quote record 
				  in notes and attachments section. 
			   2. This class is called from OmniScript
Change History : 
*************************************************************************************/
global with sharing class SGA_AP10_AttachQuotePDFToQuote implements vlocity_ins.VlocityOpenInterface
{
    /****************************************************************************************************
    Method Name : invokeMethod
    Parameters  : String, Map<String,Object>, Map<String,Object>, Map<String,Object>
    Return type : Boolean
    Description : This is the method which we need to provide implementation as we are implementing 
				  VlocityOpenInterface. From this method the actual method will be called.
    ******************************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        try{
            if (methodName.equalsIgnoreCase(SG01_Constants.ATTACH_PDF_METHOD))
            {
                return attachQuotePdf(inputMap,outMap,options);
            } 
         }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_SGA_AP10_ATTACHQUOTE, SG01_Constants.INVOKE_METHOD, SG01_Constants.BLANK, Logginglevel.ERROR);}
        return true;
    }
    
    /****************************************************************************************************
    Method Name : attachQuotePdf
    Parameters  : Map<String,Object>, Map<String,Object>, Map<String,Object>
    Return type : Boolean
    Description : This method is used to call the quote pdf creation and attachment to quote record class.
    ******************************************************************************************************/
    private Boolean attachQuotePdf(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        String quoteId = (String)inputMap.get(SG01_Constants.DRID_QUOTE);
        if(String.isNotBlank(quoteId)){
            Quote quoteObj = [select id,AccountId,Coverage_Options__c,Brand__c,vlocity_ins__EffectiveDate__c from Quote where Id =:quoteId limit 1];
            SGA_AP11_GenerateAndAttachQuotePDF genQuoteObj = new SGA_AP11_GenerateAndAttachQuotePDF(new ApexPages.StandardController(quoteObj));
            genQuoteObj.attachQuoteFromOmniScript();
        }
        
        return true;
    }
}