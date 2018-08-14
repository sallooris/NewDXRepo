/*************************************************************
Class Name   : AP25_ExactTargetController 
Date Created : 26-Oct-2015
Created By   : Kishore
Description  : This class is used to connect to exact target system and get the response back
*****************************************************************/
public class AP25_ExactTargetController {
    /*  
    Method name : retrieveExactTragetData
    Param 1     : XML_Generator__c object
    Return Type : Void
    Description : This method is used to pass the xml content to exact target system.
    */
    public String retrieveExactTragetData(XML_Generator__c xmlgenerator)
    {
        String statusValue = null;
        HTTPRequest req = prepareHTTPReq(xmlgenerator.XML_Content__c);
        String status = null;
        try{
            DOM.Document svcResp = invokeWS(req);
            statusValue = parseResponse(svcResp);
        }catch(Exception e){
            statusValue = e.getMessage();
            System.debug('Exception in retrieveExactTragetData::::'+e.getMessage());
        }
        return statusValue;
    }
    public String parseResponse(DOM.Document svcResp){
        String smcStatus = null;
        String respXML = svcResp.toXmlString();
            System.debug('Response xml'+respXML);
            Dom.XMLNode rootNode = svcResp.getRootElement();
            if(rootNode != null){
                if(!respXML.contains('faultcode')){
                    Dom.XMLNode respBody = rootNode.getChildElement('Body','http://www.w3.org/2003/05/soap-envelope').getChildElement('CreateResponse','http://exacttarget.com/wsdl/partnerAPI').getChildElement('Results','http://exacttarget.com/wsdl/partnerAPI');
                    String xmlStatus = respBody.getChildElement('StatusCode','http://exacttarget.com/wsdl/partnerAPI').getText();
                    if(xmlStatus.equalsIgnoreCase('OK')){
                        smcStatus = xmlStatus;
                    }else{
                     String statusMessage = respBody.getChildElement('StatusMessage','http://exacttarget.com/wsdl/partnerAPI').getText();  
                     smcStatus = statusMessage;
                    }
                }else{
                    Dom.XMLNode faultResp = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/').getChildElement('Fault','http://schemas.xmlsoap.org/soap/envelope/');
                    String faultCode = faultResp.getChildElement('faultstring',null).getText();
                    smcStatus = faultCode;
                }
            }
       return smcStatus;
    }
    /*  
    Method name : prepareHTTPReq
    Param 1     : request xml
    Return Type : HttpRequest
    Description : This method is used to prepare a request xml file.
    */
    public HttpRequest prepareHTTPReq(String reqxml)
    {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(System.Label.SMC_EndPointURL);
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('soapAction', 'Create');
        req.setBody(reqxml);
        return req;
    }
    /*   
    Method name : invokeWS
    Param 1     : HttpRequest
    Return Type : DOM.Document
    Description : This method is used to send the request to exact target and get the response from the same.
    */
    public DOM.Document invokeWS(HttpRequest req)   
    {
        Http ht = new Http();
        DOM.Document respDoc = new DOM.Document();
        HttpResponse response = ht.send(req);
        respDoc = response.getBodyDocument();
        return respDoc;
    }
    
}