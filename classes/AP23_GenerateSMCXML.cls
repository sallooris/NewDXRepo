/*************************************************************
Class Name   : AP23_GenerateSMCXML
Date Created : 26-Oct-2015
Created By   : Kishore
Description  : This class is used to construct the final SMC xml file
*****************************************************************/
public class AP23_GenerateSMCXML {
    
    DOM.Xmlnode Objects = null;
    public String generateXmlRequest(ID xmlId,XML_Generator__c xmlGenerator){
        String method = 'taskXmlRequest';
        XML_Generator__c[] eachTarget = new List<XML_Generator__c>();
        DOM.Document doc = new DOM.Document();
        try{
            DOM.Xmlnode envlop = doc.createRootElement('s:Envelope', null, null);
                envlop.setAttribute('xmlns:s', 'http://www.w3.org/2003/05/soap-envelope');
                envlop.setAttribute('xmlns:a', 'http://schemas.xmlsoap.org/ws/2004/08/addressing');
                envlop.setAttribute('xmlns:u', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd');
            // Add Header
            DOM.Xmlnode header = envlop.addChildElement('s:Header', null, null);                        
            
            DOM.Xmlnode esbHeader = header.addChildElement('o:Security', null, null);
            esbHeader.setAttribute('xmlns:o', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
            esbHeader.setAttribute('s:mustUnderstand', '1');
            
            DOM.Xmlnode srvcName = esbHeader.addChildElement('o:UsernameToken', null, null);
            srvcName.setAttribute('u:Id', 'uuid-f4119202-0c6f-4383-9872-4745b39f24f6-1');
            
            DOM.Xmlnode srvcVersion = srvcName.addChildElement('o:Username', null, null).addTextNode(System.Label.SMC_UserName);
            DOM.Xmlnode operName = srvcName.addChildElement('o:Password', null, null).addTextNode(System.Label.SMC_Password);
            //Body
            DOM.Xmlnode body = envlop.addChildElement('s:Body', null, null);
                body.setAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
                body.setAttribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
            DOM.Xmlnode createReq = body.addChildElement('CreateRequest', null, null);
                createReq.setAttribute('xmlns', 'http://exacttarget.com/wsdl/partnerAPI');
            DOM.Xmlnode options = createReq.addChildElement('Options', null, null);
            DOM.Xmlnode reqType = options.addChildElement('RequestType', null, null).addTextNode(System.Label.SMC_RequestType);
            DOM.Xmlnode priority = options.addChildElement('QueuePriority', null, null).addTextNode(System.Label.SMC_QueuePriority);
            
            Objects = createReq.addChildElement('Objects', null, null);
                Objects.setAttribute('xsi:type', 'TriggeredSend');
            
            List<String> allRequieredFields = fetchTargetFields();
            
            String requiredFields = String.join(allRequieredFields, ',');
            if(xmlGenerator == NULL){
                eachTarget = Database.query('SELECT ' + requiredFields + ' FROM XML_Generator__c where id= '+'\''+xmlId+'\' LIMIT 1');    
            }
            
           List<CS005_SMCXMLGeneration__c> serviceFields = [
                    SELECT Name, Request_Name__c, Default_Value__c,Sequence__c, Namespace_Prefix__c, Parent_Node__c, Type__c, XmlLabel__c, Source_Object__c, Field_Name__c, FieldRefName__c
                    FROM CS005_SMCXMLGeneration__c 
                    WHERE Request_Name__c = :method
                    ORDER BY Sequence__c];
            System.Debug('Found Target Fields Size: ' + serviceFields.size());
            //Add Target Details one by one
            if(!eachTarget.isEmpty()){
                appendSObjectToXml(eachTarget[0], serviceFields);
            }else{
                appendSObjectToXml(xmlGenerator, serviceFields);
            }
        }catch(Exception e){
            System.debug('Exception in AP23_GenerateSMCXML::::'+e.getMessage());
        }
        return doc.toXmlString();
    }
    //get fields from custom setting
    private List<String> fetchTargetFields(){
        List<CS005_SMCXMLGeneration__c> allServiceFields = [
                SELECT Name, Field_Name__c FROM CS005_SMCXMLGeneration__c
                WHERE Type__c = 'Field' and Source_Object__c = 'XML_Generator__c'];
        List<String> allFields = new List<String>();
        for(CS005_SMCXMLGeneration__c aServiceField : allServiceFields){
            allFields.add(aServiceField.Field_Name__c);
        }
        return allFields;
    }
    /*  
    Method name : appendSObjectToXml
    Param 1     : XML_Generator__c object,list of CS005_SMCXMLGeneration__c
    Return Type : Void
    Description : This method is used to construct total SMC xml file.
    */
    private void appendSObjectToXml(XML_Generator__c eachTarget, List<CS005_SMCXMLGeneration__c> serviceFields){
        System.debug('xmgenerator ::::::'+eachTarget);
        Map<string, dom.xmlnode> xmlnodemap = new Map<string, dom.xmlnode>();
        for(CS005_SMCXMLGeneration__c field : serviceFields){
            if(field.Type__c == 'XmlNode'){
                if(field.Parent_Node__c == 'Objects'){
                    Dom.XmlNode rootNode = Objects.addChildElement(field.XmlLabel__c, null, null);
                    xmlnodemap.put(field.XmlLabel__c, rootNode);
                }else{
                         xmlnodemap.put(field.XmlLabel__c, 
                                    xmlnodemap.get(field.parent_Node__c).addChildElement(field.XmlLabel__c, null, null));
                }
            }else if(field.Type__c == 'Field'){
                String innerText = '';
                Boolean isNull = true;
                //get the required field 
                sObject anAccount = eachTarget;
                if(field.Field_Name__c != null){
                    Object value = anAccount.get(field.Field_Name__c);
                    if(value != null){
                        innerText = String.valueOf(value);
                        isNull = false;
                    }
                }else if(field.Default_Value__c != NULL && field.Default_Value__c != ''){
                    Object value = field.Default_Value__c;
                    if(value != null){
                        innerText = String.valueOf(value);
                        isNull = false;
                    }
                }
                DOM.XmlNode xmlField = null;
                xmlField = xmlnodemap.get(field.parent_Node__c).addChildElement(field.xmlLabel__c, null, null); 
                xmlField.addTextNode(innerText);
            }else if(field.Type__c == 'Constant'){
                DOM.XmlNode xmlField1 = null;
                    xmlField1 = xmlnodemap.get(field.parent_Node__c).addChildElement(field.xmlLabel__c, null, null); 
                    if(field.FieldRefName__c != null)
                        xmlField1.addTextNode(field.FieldRefName__c);
                    else
                        xmlField1.addTextNode('');
            }
        }
    }

}