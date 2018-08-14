@isTest
public with sharing class DNCHttpCallout_Test {
    
      @IsTest(SeeAllData=true) public static void testDNC()
    {
        String phone = '4085551234';
        DNCHttpCallout dnc = new DNCHttpCallout();
        String cRes = dnc.checkDNC(phone);
        System.debug('cRes - '+cRes);
        System.assertEquals(cRes, '');
       //
        phone = '';
        cRes = dnc.checkDNC(phone);
        System.debug('cRes - **'+cRes);
        System.assertEquals(cRes, 'Invalid Phone Number');
       
        phone = '4085551234';
             
        dnc.lookupHeaderInfo(); 
        String currTxnId = dnc.txnId;
        system.debug('CurrTxn id from dnc = '+currTxnId);
//        System.assertEquals('https://non-prods-dp.wellpoint.com:6443/Utility/1.01/CommunicationPreference', dnc.endPoint);
        System.assertEquals('http://wsdl/CommunicationPreference_Interface_v1/CommunicationPreference/getCommunicationPreference/', dnc.soapAction);
        System.assertEquals('getCommunicationPreference', dnc.opName);
        System.assertEquals('SFISG', dnc.sndrApp);
//        System.assertEquals('CommunicationPreference', dnc.svcName);
//        System.assertEquals('1.0', dnc.svcVersion);
//        System.assertEquals('90000', dnc.timeout);
                
        //  testing function buildRequestBody
        String reqStr = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:v1="http://wellpoint.com/schema/getCommunicationPreferenceRequest/v1" xmlns:v2="http://wellpoint.com/esb/header/v2" xmlns:v21="http://wellpoint.com/schema/Base/v2" xmlns:v22="http://wellpoint.com/schema/IdentifierTypes/v2" xmlns:v23="http://wellpoint.com/schema/Member/v2" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><v2:ESBHeader><v2:srvcName>CommunicationPreference</v2:srvcName><v2:srvcVersion>1.0</v2:srvcVersion><v2:operName>getCommunicationPreference</v2:operName><v2:senderApp>SFISG</v2:senderApp><v2:transId>'+currTxnId+'</v2:transId></v2:ESBHeader></soapenv:Header><soapenv:Body><v1:getCommunicationPreferenceRequest><v21:telephoneNumber>4085551234</v21:telephoneNumber></v1:getCommunicationPreferenceRequest></soapenv:Body></soapenv:Envelope>';
        String reqxml = dnc.buildRequestBody();
        system.debug('reqxml from dnc ='+reqxml);
        System.assertEquals(reqStr, reqxml);
        
        // testing function prepareHTTPReq
        HttpRequest hreq = dnc.prepareHTTPReq(reqStr);
  //      System.assertEquals('https://prods-dp.wellpoint.com:6443/Utility/1.01/CommunicationPreference', hreq.getEndpoint());
        System.assertEquals('text/xml', hreq.getHeader('Content-Type'));
        System.assertEquals('http://wsdl/CommunicationPreference_Interface_v1/CommunicationPreference/getCommunicationPreference/', hreq.getHeader('soapAction'));
        System.assertEquals('POST', hreq.getMethod());
        
        // testing function parseResponse
        DNCHttpCallout_Test dt = new DNCHttpCallout_Test();
        dt.testRespParser('0');
        dt.testRespParser('7');
        dt.testRespParser('8');
        dt.testRespParser(''); 
    }
    
    //  build fake response
    public void testRespParser (String tmCd)
    {
        DNCHttpCallout dnc1 = new DNCHttpCallout();
        DOM.Document response = new DOM.Document();
        DOM.Xmlnode envlop = response.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
        DOM.Xmlnode body = envlop.addChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/', null);
        DOM.Xmlnode getComPrefResp = body.addChildElement('getCommunicationPreferenceResponse', 'http://wellpoint.com/schema/getCommunicationPreferenceResponse/v1', null);
        DOM.Xmlnode consumer =  getComPrefResp.addChildElement('Consumer', 'http://wellpoint.com/schema/getCommunicationPreferenceResponse/v1', null);
        DOM.Xmlnode comprefDtls = consumer.addChildElement('CommunicationPreferenceDetails', null, null);
        DOM.Xmlnode phCallStat = comprefDtls.addChildElement('PhoneCallStatus', null, null);
        DOM.Xmlnode callStatTyp = phCallStat.addChildElement('CallStatusType', null, null);
        DOM.Xmlnode tlmktDtls = callStatTyp.addChildElement('TelemarkettingDetails', null, null);
        DOM.Xmlnode tlmktTypCd = tlmktDtls.addChildElement('TelemarkettingTypeCode', 'http://wellpoint.com/schema/CodeTypes/v2', null);
        DOM.Xmlnode code = tlmktTypCd.addChildElement('code', 'http://wellpoint.com/schema/CodeTypes/v2', null);
        code.addTextNode(tmCd);

        String result = dnc1.parseResponse(response);
        if (tmCd == '0')
            System.assertEquals(result, 'Unknown/Not Specified');
        else if (tmCd == '7')
            System.assertEquals(result, 'Opt In');
        else if (tmCd == '8')
            System.assertEquals(result, 'Opt Out');
        else if (tmCd == '')
            System.assertEquals(result, 'No Response received');          
    }
}