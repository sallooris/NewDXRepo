global with sharing class ApplicationLoader implements vlocity_ins.VlocityOpenInterface{

    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options)
    {
        if (methodName == 'loadData'){
            return loadData(inputMap, outputMap) ;
        }
        return false;
    }

    public Boolean loadData(Map<String,Object> tempinputMap, Map<String,Object> outputMap){
        Id applcationId = (Id)tempinputMap.get('ContextId');
        String dataJSON = [SELECT vlocity_ins__JSONData__c FROM vlocity_ins__Application__c WHERE ID =: applcationId LIMIT 1].vlocity_ins__JSONData__c;
        
        System.debug('The dataJSON is: ' + dataJSON);
        if(dataJSON == 'OmniScript Attachment'){
             Blob AttachedFile = [SELECT Id, Name, Body, ContentType FROM Attachment WHERE ParentId = :applcationId AND NAME='OmniScriptDataJSON.json' LIMIT 1].body;
            System.debug('The AttachedFile is: ' + AttachedFile.toString());
            dataJSON = AttachedFile.toString();
        }
        
        Map<String,Object> inputMap = (Map<String, Object>) JSON.deserializeUntyped(dataJSON);
        if(inputMap.get('CompanyInformation') != null)
            outputMap.put('CompanyInformation', inputMap.get('CompanyInformation'));
        if(inputMap.get('ApplicationType') != null)
            outputMap.put('ApplicationType', inputMap.get('ApplicationType'));
        if(inputMap.get('MedicalCoverage') != null)
            outputMap.put('MedicalCoverage', inputMap.get('MedicalCoverage'));
        if(inputMap.get('DentalCoverage') != null)
            outputMap.put('DentalCoverage', inputMap.get('DentalCoverage'));
        if(inputMap.get('Agent/Producer/BrokerCert') != null)
            outputMap.put('Agent/Producer/BrokerCert', inputMap.get('Agent/Producer/BrokerCert'));
        if(inputMap.get('VisionCoverage') != null)
            outputMap.put('VisionCoverage', inputMap.get('VisionCoverage'));
        if(inputMap.get('Eligibility') != null)
            outputMap.put('Eligibility', inputMap.get('Eligibility'));
        if(inputMap.get('MappedCode') != null)
            outputMap.put('MappedCode', inputMap.get('MappedCode'));
        if(inputMap.get('RatingArea') != null)
            outputMap.put('RatingArea', inputMap.get('RatingArea'));
        if(inputMap.get('Brand') != null)
            outputMap.put('Brand', inputMap.get('Brand'));
       
        Map<String,Object> CompanyInformationField = (Map<String,Object>) inputMap.get('CompanyInformation');
        String YEARField = (String)CompanyInformationField.get('AppEffectiveDateYear');
        
        System.debug('The YEARField is: ' + YEARField);
        
        if(YEARField != null)
            outputMap.put('YEAR', YEARField);
        if(inputMap.get('AgencyName') != null)
            outputMap.put('AgencyName', inputMap.get('AgencyName'));
        if(inputMap.get('Application Id') != null)
            outputMap.put('Application Id', inputMap.get('Application Id'));
        if(inputMap.get('BrokerId') != null)
            outputMap.put('BrokerId', inputMap.get('BrokerId'));
        if(inputMap.get('BrokerName') != null)
            outputMap.put('BrokerName', inputMap.get('BrokerName'));

        if(inputMap.get('NewEnrollment') != null)
            outputMap.put('NewEnrollment', inputMap.get('NewEnrollment'));
        if(inputMap.get('RequestedEffectiveDateEnText') != null)
            outputMap.put('RequestedEffectiveDateEnText', inputMap.get('RequestedEffectiveDateEnText'));

        if(inputMap.get('Class2NumberofEE+Children') != null)
            outputMap.put('Class2NumberofEE+Children', inputMap.get('Class2NumberofEE+Children'));
        if(inputMap.get('Class2NumberofEE+Spouse') != null)
            outputMap.put('Class2NumberofEE+Spouse', inputMap.get('Class2NumberofEE+Spouse'));
        if(inputMap.get('Class2NumberofFamily') != null)
            outputMap.put('Class2NumberofFamily', inputMap.get('Class2NumberofFamily'));
        if(inputMap.get('Class2NumberofSingles(EE)') != null)
            outputMap.put('Class2NumberofSingles(EE)', inputMap.get('Class2NumberofSingles(EE)'));
        if(inputMap.get('Class3NumberofEE+Children') != null)
            outputMap.put('Class3NumberofEE+Children', inputMap.get('Class3NumberofEE+Children'));
        if(inputMap.get('Class3NumberofEE+Spouse') != null)
            outputMap.put('Class3NumberofEE+Spouse', inputMap.get('Class3NumberofEE+Spouse'));
        if(inputMap.get('Class3NumberofFamily') != null)
            outputMap.put('Class3NumberofFamily', inputMap.get('Class3NumberofFamily'));
        if(inputMap.get('Class3NumberofSingles (EE)') != null)
            outputMap.put('Class3NumberofSingles (EE)', inputMap.get('Class3NumberofSingles (EE)'));

        if(inputMap.get('GroupName') != null)
            outputMap.put('GroupName', inputMap.get('GroupName'));
        if(inputMap.get('MappedCode') != null)
            outputMap.put('MappedCode', inputMap.get('MappedCode'));
        if(inputMap.get('MinInfo') != null)
            outputMap.put('MinInfo', inputMap.get('MinInfo'));
        if(inputMap.get('MinState') != null)
            outputMap.put('MinState', inputMap.get('MinState'));
        if(inputMap.get('NoDentalCoverage') != null)
            outputMap.put('NoDentalCoverage', inputMap.get('NoDentalCoverage'));
        if(inputMap.get('PartyAccountId') != null)
            outputMap.put('PartyAccountId', inputMap.get('PartyAccountId'));
        if(inputMap.get('QuotePreparedFor') != null)
            outputMap.put('QuotePreparedFor', inputMap.get('QuotePreparedFor'));
      /*  if(inputMap.get('SIC') != null)
            outputMap.put('SIC', inputMap.get('SIC'));*/
        if(inputMap.get('SICCode') != null)
            System.debug('The SICCode is: ' + inputMap.get('SICCode'));
            outputMap.put('SIC', inputMap.get('SIC'));
        if(inputMap.get('SelectMedicalCoverage') != null)
            outputMap.put('SelectMedicalCoverage', inputMap.get('SelectMedicalCoverage'));
        if(inputMap.get('VisionOptions') != null)
            outputMap.put('VisionOptions', inputMap.get('VisionOptions'));
        if(inputMap.get('ZipCode') != null)
            outputMap.put('ZipCode', inputMap.get('ZipCode'));
        if(inputMap.get('error') != null)
            outputMap.put('error', inputMap.get('error'));
        if(inputMap.get('id') != null)
            outputMap.put('id', inputMap.get('id'));
        if(inputMap.get('plan') != null)
            outputMap.put('plan', inputMap.get('plan'));
        if(inputMap.get('qOpportunityName') != null)
            outputMap.put('qOpportunityName', inputMap.get('qOpportunityName'));
        if(inputMap.get('qQuote Name') != null)
            outputMap.put('qQuote Name', inputMap.get('qQuote Name'));
        if(inputMap.get('sInstanceId') != null)
            outputMap.put('sInstanceId', inputMap.get('sInstanceId'));
        if(inputMap.get('textNode') != null)
            outputMap.put('textNode', inputMap.get('textNode'));
        if(inputMap.get('textNode2') != null)
            outputMap.put('textNode2', inputMap.get('textNode2'));
        if(inputMap.get('textNode3') != null)
            outputMap.put('textNode3', inputMap.get('textNode3'));
        if(inputMap.get('timeStamp') != null)
            outputMap.put('timeStamp', inputMap.get('timeStamp'));
        if(inputMap.get('userName') != null)
            outputMap.put('userName', inputMap.get('userName'));
        if(inputMap.get('userProfile') != null)
            outputMap.put('userProfile', inputMap.get('userProfile'));
        if(inputMap.get('vlcPersistentComponent') != null)
            outputMap.put('vlcPersistentComponent', inputMap.get('vlcPersistentComponent'));

         return true;
    }

}