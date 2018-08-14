/****************************************************************************
Class Name  :  QuoteCanvasExt_Test
Date Created:  25-June-2015
Created By  :  Daryl
Description :  This class is used to make a http callout to SOA service (CHUB - Anthem System) to check the DNC against the phone number
Change History :    
****************************************************************************/
public with sharing class DNCHttpCallout {

    public String endPoint = '';
    public String soapAction = '';
    public String svcName = '';
    public String opName = '';
    public String svcVersion = '';
    public String sndrApp = '';
    public String certName = '';
    public String timeout = '';
    public String txnId = genTxnId();
    public String respXML;
    public String reqXML;
    public String formattedPhNum;
    public String teleMktCd = ''; 
    // This method is accessible by the calling program to make a service call by passing the phone number    
    public String checkDNC(String phNum)
    {
        if(validatePhNum(phNum))
        {
            lookupHeaderInfo();
            reqXML =  buildRequestBody();
            HTTPRequest req = prepareHTTPReq(reqXML);
            try
            {
                DOM.Document svcResp = invokeWS(req);
                teleMktCd = parseResponse(svcResp);
            }
            catch(Exception e)
            {
                System.debug('Error invoking Web Service: '+e.getMessage());
            }
            return teleMktCd;
        }   
        else
            return 'Invalid Phone Number';
    }
    
    public String genTxnId()
    {
    	String hashStr = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
		Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashStr));
		return EncodingUtil.convertToHex(hash);
    }
    
    public boolean validatePhNum(String phNum)
    {
        boolean isValid;
        if (phNum.length()>0)
        {
            formattedPhNum = phNum.remove('(').remove(')').remove('-').remove(' ');
            isValid = true;
        }
        else
            isValid = false; 
        return isValid;
    }
    // Getting run time parameters from custom settings - OutboundWS
    public void lookupHeaderInfo()
    {
        OutboundWS__c esbData = OutboundWS__c.getValues('DNC');
        endPoint = esbData.Endpoint__c;
        soapAction = esbData.soapAction__c;
        opName = esbData.Operation__c;
        sndrApp = esbData.SenderApp__c;
        svcName = esbData.ServiceName__c;
        svcVersion = esbData.ServiceVersion__c;
        certName = esbData.CertName__c;
        if(certName == null) certName = 'ISGTelesales';
        timeout = esbData.Timeout__c;
    }
      // building http request body to be sent to SOA/DP 
    public String buildRequestBody()
    {
        String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        String serviceNS = 'http://wsdl/CommunicationPreference_Interface_v1/CommunicationPreference/';
        
        // Create the request envelope
        DOM.Document doc = new DOM.Document();
        DOM.Xmlnode envlop = doc.createRootElement('Envelope', soapNS, 'soapenv');
        envlop.setAttribute('xmlns:v1', 'http://wellpoint.com/schema/getCommunicationPreferenceRequest/v1');
        envlop.setAttribute('xmlns:v2', 'http://wellpoint.com/esb/header/v2');
        envlop.setAttribute('xmlns:v21', 'http://wellpoint.com/schema/Base/v2');
        envlop.setAttribute('xmlns:v22', 'http://wellpoint.com/schema/IdentifierTypes/v2');
        envlop.setAttribute('xmlns:v23', 'http://wellpoint.com/schema/Member/v2');              
               
        // Add ESBHeader
        DOM.Xmlnode header = envlop.addChildElement('Header', soapNS, null);                        
        DOM.Xmlnode esbHeader = header.addChildElement('v2:ESBHeader', null, null);
        DOM.Xmlnode srvcName = esbHeader.addChildElement('v2:srvcName', null, null).addTextNode('CommunicationPreference');
        DOM.Xmlnode srvcVersion = esbHeader.addChildElement('v2:srvcVersion', null, null).addTextNode('1.0');
        DOM.Xmlnode operName = esbHeader.addChildElement('v2:operName', null, null).addTextNode('getCommunicationPreference');
        DOM.Xmlnode senderApp = esbHeader.addChildElement('v2:senderApp', null, null).addTextNode(sndrApp);
        DOM.Xmlnode transId = esbHeader.addChildElement('v2:transId', null, null).addTextNode(txnId);

        //  Create the message body
        DOM.Xmlnode body = envlop.addChildElement('Body', soapNS, null);
        DOM.Xmlnode operation = body.addChildElement('v1:getCommunicationPreferenceRequest', null, null);
        operation.addChildElement('v21:telephoneNumber', null, null).addTextNode(formattedPhNum);
        System.debug('Request XML:' + doc.toXmlString());
        return doc.toXmlString();
    }
    
    public HttpRequest prepareHTTPReq(String reqxml)
    {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type', 'text/xml');
        req.setHeader('soapAction', soapAction);
        req.setBody(reqxml);
        req.setClientCertificateName(certName);
        return req;
    }
           
    public DOM.Document invokeWS(HttpRequest req)   
    {
        Http ht = new Http();
        HttpResponse response = ht.send(req);
        System.debug('Response Status:' + response.toString());
        DOM.Document respDoc = response.getBodyDocument();
        return respDoc;
    }   
    
    public String parseResponse(DOM.Document respDom)    
    {
        respXML = respDom.toXmlString();
        System.debug('Response XML:' + respXML);
                
        try
        {
            Dom.XMLNode respEnv = respDom.getRootElement();
            Dom.XMLNode respBody = respEnv.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/').getChildElement('getCommunicationPreferenceResponse','http://wellpoint.com/schema/getCommunicationPreferenceResponse/v1').getChildElement('Consumer', 'http://wellpoint.com/schema/getCommunicationPreferenceResponse/v1');
            for(Dom.XMLNode child : respBody.getChildElements()) 
            {
                for (Dom.XMLNode respData : child.getChildElements())
                {
                    if (respData.getName() == 'PhoneCallStatus')
                    {
                        for(Dom.Xmlnode callStat : respData.getChildElements())
                        {
                            if (callStat.getName() == 'CallStatusType')
                            {
                                for(Dom.XMLNode telemkt : callStat.getChildElements())
                                {
                                    if(telemkt.getName() == 'TelemarkettingDetails')
                                    {
                                        teleMktCd = telemkt.getChildElement('TelemarkettingTypeCode', 'http://wellpoint.com/schema/CodeTypes/v2').getChildElement('code','http://wellpoint.com/schema/CodeTypes/v2').getText();
                                        system.debug('Telemarketing code = '+teleMktCd);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Error parsing response: '+e.getMessage());
        }
        if (teleMktCd == '0')
            teleMktCd = 'Unknown/Not Specified';
        else if (teleMktCd == '7')
            teleMktCd = 'Opt In';
        else if (teleMktCd == '8')
            teleMktCd = 'Opt Out';
        else if (teleMktCd == '')
        	teleMktCd = 'No Response received';
        return teleMktCd;
    } 
}