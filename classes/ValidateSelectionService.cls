global without sharing class ValidateSelectionService implements vlocity_ins.VlocityOpenInterface
{
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        try{
            if (methodName.equalsIgnoreCase('validateMedical'))
            {
                return validateMedical(inputMap,outMap,options);
            }
            else if (methodName.equalsIgnoreCase('validateSelectedMedical'))
            {
                return validateSelectedMedical(inputMap,outMap,options);
            }
            else if (methodName.equalsIgnoreCase('validateDental'))
            {
                return validateDental(inputMap,outMap,options);
            }
            else if (methodName.equalsIgnoreCase('validateVision'))
            {
                return validateVision(inputMap,outMap,options);
            }
            else if (methodName.equalsIgnoreCase('validateQuoteMedical'))
            {
                return validateQuoteMedical(inputMap,outMap,options);
            }
            else if (methodName.equalsIgnoreCase('validateQuoteDental'))
            {
                return validateQuoteDental(inputMap,outMap,options);
            }
            else if (methodName.equalsIgnoreCase('validateQuoteVision'))
            {
                return validateQuoteVision(inputMap,outMap,options);
            }
            
            else if (methodName.equalsIgnoreCase('validateZipCode'))
            {
                return validateZipCode(inputMap,outMap,options);
            }
            
            
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_VALIDATESELECTIONSERVICE, SG01_Constants.INVOKEMETHOD, '', Logginglevel.ERROR);}
        return true;
    }
    
    
    
    private Boolean validateMedical(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Map<String,Object> selectCoverageMap = (Map<String,Object>)inputMap.get('MedicalCoverage');
        List<Object> selectCoverageOutputList = (List<Object>) selectCoverageMap.get('MedicalAccounts');
        Map<String, Object> validationErrJSON = new Map<String, Object>();
        String quoteEnrollMultipleProdErrorMsg = 'You may not enroll in more than three Medical plans';
        String quoteEnrollNoProdErrorMsg = 'You must enroll in at least one Medical plan';
        Try{
            if (selectCoverageOutputList!=null && selectCoverageOutputList.size()>3)
                
            {
                outMap.put('error',quoteEnrollMultipleProdErrorMsg);
            }
            else if (selectCoverageOutputList == null)
            {
                outMap.put('error',quoteEnrollNoProdErrorMsg);
            }
            
            if (validationErrJSON.keySet().size() > 0)
                outMap.put('error', validationErrJSON);
            
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_VALIDATESELECTIONSERVICE, SG01_Constants.VALIDATEQUOTEDENTAL, '', Logginglevel.ERROR);}
        
        return true;
    }
    
    private Boolean validateSelectedMedical(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Map<String,Object> selectCoverageMap = (Map<String,Object>)inputMap.get('MedicalCoverage');
        List<Object> selectCoverageOutputList = (List<Object>) selectCoverageMap.get('MedicalAccounts');
        Boolean isConflictRider29Plans = (Boolean) selectCoverageMap.get('isConflictRider29Plans');
        Map<String, Object> validationErrJSON = new Map<String, Object>();
        String quoteEnrollRider29ProdErrorMsg = 'During enrollment you must only pick plans with or without age 29, not both.';
        String quoteEnrollMultipleProdErrorMsg = 'You may not enroll in more than three Medical plans';
        Try{
            if(isConflictRider29Plans){
                outMap.put('error',quoteEnrollRider29ProdErrorMsg);
            }
            else if (selectCoverageOutputList!=null && selectCoverageOutputList.size()>3)
            {
                outMap.put('error',quoteEnrollMultipleProdErrorMsg);
            }
            
            if (validationErrJSON.keySet().size() > 0)
                outMap.put('error', validationErrJSON);
            
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_VALIDATESELECTIONSERVICE, SG01_Constants.VALIDATEQUOTEDENTAL, '', Logginglevel.ERROR);}
        
        return true;
    }
    
    private Boolean validateDental(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Map<String,Object> selectCoverageMap = (Map<String,Object>)inputMap.get('DentalCoverage');
        List<Object> selectCoverageOutputList = (List<Object>) selectCoverageMap.get('DentalAccounts');
        Map<String, Object> validationErrJSON = new Map<String, Object>();
        String quoteEnrollMultipleProdErrorMsg = 'You may not enroll in more than two Dental plans';
        String quoteEnrollNoProdErrorMsg = 'You must enroll in at least one Dental plan';
        Try{
            if (selectCoverageOutputList!=null && selectCoverageOutputList.size()>2)
            {
                outMap.put('error',quoteEnrollMultipleProdErrorMsg);
            }
            else if (selectCoverageOutputList == null)
            { 
                outMap.put('error',quoteEnrollNoProdErrorMsg);
            }
            
            if (validationErrJSON.keySet().size() > 0)
                outMap.put('error', validationErrJSON);
            
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_VALIDATESELECTIONSERVICE, SG01_Constants.VALIDATEDENTAL, '', Logginglevel.ERROR);}
        return true;
    }
    
    private Boolean validateVision(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Map<String,Object> selectCoverageMap = (Map<String,Object>)inputMap.get('VisionCoverage');
        List<Object> selectCoverageOutputList = (List<Object>) selectCoverageMap.get('VisionAccounts');
        Map<String, Object> validationErrJSON = new Map<String, Object>();
        String quoteEnrollMultipleProdErrorMsg = 'You may not enroll in more than one Vision plan';
        String quoteEnrollNoProdErrorMsg = 'You must enroll in at least one Vision plan';
        Try{
            if (selectCoverageOutputList!=null && selectCoverageOutputList.size()!=1)
                
            {
                outMap.put('error',quoteEnrollMultipleProdErrorMsg);
            }
            else if (selectCoverageOutputList == null)
            {
                outMap.put('error',quoteEnrollNoProdErrorMsg);
            }
            
            if (validationErrJSON.keySet().size() > 0)
                outMap.put('error', validationErrJSON);
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_VALIDATESELECTIONSERVICE, SG01_Constants.VALIDATEVISION, '', Logginglevel.ERROR);}
        return true;
    }
    
    private Boolean validateQuoteMedical(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Map<String,Object> selectCoverageMap = (Map<String,Object>)inputMap.get('SelectMedicalCoverage');
        List<Object> selectCoverageOutputList = (List<Object>) selectCoverageMap.get('output2');
        Map<String, Object> validationErrJSON = new Map<String, Object>();
        String quoteEnrollMultipleProdErrorMsg = 'You may not quote more than ten Medical plans';
        String quoteEnrollNoProdErrorMsg = 'You must enroll in at least one Medical plan';
        Try{
            if (selectCoverageOutputList!=null && selectCoverageOutputList.size()>10)
                
            {
                outMap.put('error',quoteEnrollMultipleProdErrorMsg);
            }
            else if (selectCoverageOutputList == null)
            {
                outMap.put('error',quoteEnrollNoProdErrorMsg);
            }
            
            if (validationErrJSON.keySet().size() > 0)
                outMap.put('error', validationErrJSON);
            
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_VALIDATESELECTIONSERVICE, SG01_Constants.VALIDATEQUOTEDENTAL, '', Logginglevel.ERROR);}
        return true;
    }
    
    private Boolean validateQuoteDental(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Map<String,Object> selectCoverageMap = (Map<String,Object>)inputMap.get('SelectDentalPlans');
        List<Object> selectCoverageOutputList = (List<Object>) selectCoverageMap.get('output3');
        Map<String, Object> validationErrJSON = new Map<String, Object>();
        String quoteEnrollMultipleProdErrorMsg = 'You may not quote more than ten Dental plans';
        String quoteEnrollNoProdErrorMsg = 'You must enroll in at least one Dental plan';
        Try{
            if (selectCoverageOutputList!=null && selectCoverageOutputList.size()>10)
                
            {
                outMap.put('error',quoteEnrollMultipleProdErrorMsg);
            }
            else if (selectCoverageOutputList == null)
            {
                outMap.put('error',quoteEnrollNoProdErrorMsg);
            }
            
            if (validationErrJSON.keySet().size() > 0)
                outMap.put('error', validationErrJSON);
            
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_VALIDATESELECTIONSERVICE, SG01_Constants.VALIDATEQUOTEDENTAL, '', Logginglevel.ERROR);}
        
        return true;
    }
    
    private Boolean validateQuoteVision(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Map<String,Object> selectCoverageMap = (Map<String,Object>)inputMap.get('SelectVisionPlans');
        List<Object> selectCoverageOutputList = (List<Object>) selectCoverageMap.get('output4');
        Map<String, Object> validationErrJSON = new Map<String, Object>();
        String quoteEnrollMultipleProdErrorMsg = 'You may not quote more than ten Vision plans';
        String quoteEnrollNoProdErrorMsg = 'You must enroll in at least one Vision plan';
        Try{
            if (selectCoverageOutputList!=null && selectCoverageOutputList.size()>10)
                
            {
                outMap.put('error',quoteEnrollMultipleProdErrorMsg);
            }
            else if (selectCoverageOutputList == null)
            {
                outMap.put('error',quoteEnrollNoProdErrorMsg);
            }
            
            if (validationErrJSON.keySet().size() > 0)
                outMap.put('error', validationErrJSON);
            
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_VALIDATESELECTIONSERVICE, SG01_Constants.VALIDATEQUOTEVISION, '', Logginglevel.ERROR);}
        
        return true;
    }
    private Boolean validateZipCode(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        Map<String,Object> zipCodeMap = (Map<String,Object>)inputMap.get('Step');
        String zipCodeErrorMsg = 'You may have entered Invalid ZipCode';
        System.debug('inside validate zip code method');
        Try
        {
            if(zipCodeMap.get('CheckZipCode') != 1){
                outMap.put('error',zipCodeErrorMsg);
            }else{
                 //calling validateDuplicateAccount method as validateZipCode method is directly calling 
                 //from GroupProfileStep to validate the account is dupliate or not
                 validateDuplicateAccount(inputMap,outMap,options);
            }
           
            
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,SG01_Constants.CLS_VALIDATESELECTIONSERVICE, SG01_Constants.VALIDATEQUOTEDENTAL, SG01_Constants.BLANK, Logginglevel.ERROR);}
        
        return true;
    }
    /**
     * Method Name : validateDuplicateAccount
     * Parameters  : Map<String,Object>,Map<String,Object>,Map<String,Object>
     * Return Type : Boolean
     * Description : This method is calling from validateZipCode method, is used to validate the account is duplicate or not.
     */
    private Boolean validateDuplicateAccount(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        /***********************IDC Offshore Code Starts *********************************/
        Map<String,Object> stepMap = (Map<String,Object>)inputMap.get('Step');
        if(stepMap != NULL && !stepMap.isEmpty()){
            //this block of code is used to check and restrict duplicate account creation.
            Map<String,Object> typeAheadBrokerMap = (Map<String,Object>)stepMap.get(System.Label.SG40_TypeAheadBrokerBlock);
            String brokerId = (String)typeAheadBrokerMap.get(System.Label.SG37_BrokerId);
            String taxId = (String)stepMap.get(System.Label.SG38_TaxId);
            Map<String, Object> validationErrJSON = new Map<String, Object>();
            String duplicateAccountError = System.Label.SG36_DuplicateErrMessage;
            Id grpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.SG_GroupRecordTypeName).getRecordTypeId();
            //retriving the user ids where the user entered broker id matches
            List<User> userList = [select id from User where contactid =:brokerId LIMIT 1];
            //checking the user is present in the user list and the same is exist in any of the account teams
            if(userList != NULL && !userList.isEmpty() && String.isNotBlank(taxId)){
                
                List<AccountTeamMember> accTeamMemList = [SELECT Id FROM AccountTeamMember 
                                                          where Account.Employer_EIN__c =:taxId AND Account.RecordTypeId =:grpRecordTypeId 
                                                          AND TeamMemberRole =:System.Label.SG72_AccountTeamRole and UserId =:userList[0].Id LIMIT 1];
                if(accTeamMemList != NULL && !accTeamMemList.isEmpty()){
                    outMap.put(System.Label.SG41_Error,duplicateAccountError);
                }
            }
        }
        /***********************IDC Offshore Code Ends *********************************/
        return true;
    }
}