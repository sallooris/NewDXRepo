/*******************************************************
Class Name  :  ASCSBrokerService
Date Created:  8/11/2015
Created By  :  Daryl Coutinho
Description :  Class is used to retrieve data from ASCS Broker Service. 
Change History :
1. Modified by Kishore Jonnadula   
*******************************************************/
public with sharing class ASCSBrokerService {
 
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
    public String appUrl;
    public String appName;
    public Integer ccRecCount;
    public String brokerType;
    public List <Account> accountList = new List<Account>();
    public List <License_Appointment__c> licenseList = new List<License_Appointment__c>();
    public List <Certification__c> certList = new List<Certification__c>();
    public List <License_Appointment__c> contractList = new List<License_Appointment__c>();
    public List <Brokerage_Broker__c> relationshipList = new List <Brokerage_Broker__c>(); 
    public List<Sales_Team__c> salesTeamList = new List<Sales_Team__c>();
             
    public ASCSServiceInfo retrieveBrokerData(String brokerId)
    {
        ASCSServiceInfo ascsInfo = new ASCSServiceInfo();
        lookupHeaderInfo('ASCS');
        reqXML =  buildRequestBody(brokerId);
        HTTPRequest req = prepareHTTPReq(reqXML);
        try
        {
            DOM.Document svcResp = invokeWS(req, ascsInfo);
            if(ascsInfo.errorMsg == null){
                ascsInfo = parseResponse(svcResp);
            }
        }
        catch(Exception e)
        {
            System.debug('Error invoking Web Service: '+e.getMessage());
        }
        return ascsInfo;
    }
     
    public String genTxnId()
    {
        String hashStr = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashStr));
        return EncodingUtil.convertToHex(hash);
    }
       
    public void lookupHeaderInfo(String WebSvcName)
    {
        OutboundWS__c esbData = OutboundWS__c.getValues(WebSvcName);
        endPoint = esbData.Endpoint__c;
        soapAction = esbData.soapAction__c;
        opName = esbData.Operation__c;
        sndrApp = esbData.SenderApp__c;
        svcName = esbData.ServiceName__c;
        svcVersion = esbData.ServiceVersion__c;
        certName = esbData.CertName__c;
        timeout = esbData.Timeout__c;
        if (WebSvcName == 'CipherCloud')
        {
            appUrl = esbData.AppUrl__c;
            appName = esbData.AppName__c;
        }
    }
    
    public String buildRequestBody(String brkId)
    {
        String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        
        // Create the request envelope
        DOM.Document doc = new DOM.Document();
        DOM.Xmlnode envlop = doc.createRootElement('Envelope', soapNS, 'soapenv');
        envlop.setAttribute('xmlns:v1', 'http://wellpoint.com/schema/getSummaryRequest/v1');
        envlop.setAttribute('xmlns:v2', 'http://wellpoint.com/esb/header/v2');
        envlop.setAttribute('xmlns:v21', 'http://wellpoint.com/schema/CodeTypes/v2');
        envlop.setAttribute('xmlns:v11', 'http://wellpoint.com/schema/Broker/v1');
                                    
        // Add ESBHeader
        DOM.Xmlnode header = envlop.addChildElement('Header', soapNS, null);                        
        DOM.Xmlnode esbHeader = header.addChildElement('v2:ESBHeader', null, null);
        DOM.Xmlnode srvcName = esbHeader.addChildElement('v2:srvcName', null, null).addTextNode(svcName);
        DOM.Xmlnode srvcVersion = esbHeader.addChildElement('v2:srvcVersion', null, null).addTextNode(svcVersion);
        DOM.Xmlnode operName = esbHeader.addChildElement('v2:operName', null, null).addTextNode(opName);
        DOM.Xmlnode senderApp = esbHeader.addChildElement('v2:senderApp', null, null).addTextNode(sndrApp);
        DOM.Xmlnode transId = esbHeader.addChildElement('v2:transId', null, null).addTextNode(txnId);

        //  Create the message body
        DOM.Xmlnode body = envlop.addChildElement('Body', soapNS, null);
        DOM.Xmlnode operation = body.addChildElement('v1:getSummaryRequest', null, null);
        operation.addChildElement('v11:brokerIdentifier', null, null).addTextNode(brkId);
        operation.addChildElement('v11:getHixCert', null, null).addTextNode('YES');
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
           
    public DOM.Document invokeWS(HttpRequest req, ASCSServiceInfo ascsInfo)   
    {
        Http ht = new Http();
        DOM.Document respDoc = new DOM.Document();
        try{
            HttpResponse response = ht.send(req);
            respDoc = response.getBodyDocument();
            System.Debug('respDoc-->'+respDoc);
        }catch(Exception e){
            if(e.getMessage() != null)
                ascsInfo.errorMsg = 'There is an issue in connecting to ASCS. Please check with Administrator';
            System.debug('HttpResponse::::'+e.getMessage());
        }
        return respDoc;
    }   
    
    public ASCSServiceInfo parseResponse(DOM.Document respDom)    
    {
        respXML = respDom.toXmlString();
        System.debug('Response XML:' + respXML);
        String brkTaxId;
        String brkEncTaxId;
        String brkNPN;
        String agncyName;
        String brkFName;
        String brkLName;
        String addrType;
        String addrLine1; 
        String addrLine2;
        String city;
        String state;
        String zip;
        String email;
        String phone;
        String countyCode;
        
        ASCSServiceInfo brokerInfo = new ASCSServiceInfo();
        try
        {
            Dom.XMLNode respEnv = respDom.getRootElement();
            if(!respXML.contains('Fault')){
                Dom.XMLNode respBody = respEnv.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/').getChildElement('getSummaryResponse','http://wellpoint.com/schema/getSummaryResponse/v1').getChildElement('BrokerSummary', 'http://wellpoint.com/schema/Broker/v1');
                brkTaxId = respBody.getChildElement('taxIdentifier', 'http://wellpoint.com/schema/IdentifierTypes/v2').getText();
                brkEncTaxId = respBody.getChildElement('encryptedTaxIdentifier', 'http://wellpoint.com/schema/IdentifierTypes/v2').getText();
                brkNPN = respBody.getChildElement('nationalProducerNumber', 'http://wellpoint.com/schema/Broker/v1').getText();
                brokerType = respBody.getChildElement('BrokerTypeCode', 'http://wellpoint.com/schema/CodeTypes/v2').getChildElement('code','http://wellpoint.com/schema/CodeTypes/v2').getText();
                Account accountRec = new Account();
                accountRec.BR_Encrypted_TIN__c = brkEncTaxId;
                accountRec.BR_National_Producer_Number__c = brkNPN;
                accountRec.BR_Tax_Identification_Number__c = brkTaxId;
                if (brokerType.contains('Agency'))
                {
                   agncyName = respBody.getChildElement('agencyName', 'http://wellpoint.com/schema/Broker/v1').getText();
                    accountRec.Name = agncyName;
                    brokerType = 'Agency';
                }
                else
                {
                    brkFName = respBody.getChildElement('firstName', 'http://wellpoint.com/schema/Base/v2').getText();
                    brkLName = respBody.getChildElement('lastName', 'http://wellpoint.com/schema/Base/v2').getText();
                    accountRec.Name = brkFName + ',' + brkLName;
                    accountRec.FirstName = brkFName;
                    accountRec.LastName = brkLName; 
                }
                //system.debug('brkLName = '+brkLName);
                for(Dom.XMLNode respData : respBody.getChildElements()) 
                {
                    if (respData.getName() == 'ContactAddress')
                    {
                        addrType = respData.getChildElement('AddressTypeCode', 'http://wellpoint.com/schema/CodeTypes/v2').getChildElement('code','http://wellpoint.com/schema/CodeTypes/v2').getText();
                        addrLine1 = respData.getChildElement('addressLine1Text', 'http://wellpoint.com/schema/Base/v2').getText();
                        if(respXML.contains('addressLine2Text'))
                            addrLine2 = respData.getChildElement('addressLine2Text', 'http://wellpoint.com/schema/Base/v2').getText();
                        city = respData.getChildElement('cityName', 'http://wellpoint.com/schema/Base/v2').getText();
                        state = respData.getChildElement('StateCode', 'http://wellpoint.com/schema/CodeTypes/v2').getChildElement('code','http://wellpoint.com/schema/CodeTypes/v2').getText();
                        zip = respData.getChildElement('PostalCode', 'http://wellpoint.com/schema/CodeTypes/v2').getText();
                        countyCode = respData.getChildElement('CountyCode', 'http://wellpoint.com/schema/CodeTypes/v2').getChildElement('code','http://wellpoint.com/schema/CodeTypes/v2').getText();
                        accountRec.Billing_Street__c = addrLine1+','+addrLine2; //
                        accountRec.Billing_City__c = city; //
                        accountRec.Billing_State__c = state;
                        accountRec.Billing_PostalCode__c = zip; //
                        accountRec.BillingCountry = countyCode;
                    }
                    else if (respData.getName() == 'ContactElectronicMail')
                    {
                        email = respData.getChildElement('emailAddressText', 'http://wellpoint.com/schema/Base/v2').getText();
                        accountRec.PersonEmail = email; //
                    }
                    else if (respData.getName() == 'ContactTelephone')
                    {
                        if (respData.getChildElement('TelephoneTypeCode', 'http://wellpoint.com/schema/CodeTypes/v2').getChildElement('code', 'http://wellpoint.com/schema/CodeTypes/v2').getText() == 'OFFICE')
                            phone = respData.getChildElement('telephoneNumber', 'http://wellpoint.com/schema/Base/v2').getText();
                        accountRec.Work_Phone__c = phone; //
                    }
                    else if (respData.getName() == 'Information')
                    {
                        String stateCd = respData.getChildElement('StateCode', 'http://wellpoint.com/schema/CodeTypes/v2').getChildElement('code','http://wellpoint.com/schema/CodeTypes/v2').getText();
                        
                        for(Dom.XMLNode child : respData.getChildElements()) 
                        {
                            if (child.getName() == 'LicenseAppointment')
                            {                       
                                for(Dom.XMLNode licChild : child.getChildElements()) 
                                {
                                    String licLOB = licChild.getChildElement('lineOfBusiness', 'http://wellpoint.com/schema/Broker/v1').getText();
                                    if (licLOB == 'HEALTH')
                                    {
                                        String recType;
                                        String startDt;
                                        String endDt;
                                        License_Appointment__c licenseRec = new License_Appointment__c();
                                        licenseRec.BR_State__c = stateCd;
                                        licenseRec.BR_Encrypt_ID__c = brkEncTaxId;
                                        
                                        for(Dom.XMLNode lic : licChild.getChildElements())
                                        {
                                            //  if (lic.getName() == 'licenseNumber')
                                            //  licenseRec.BR_Number__c = lic.getText();
                                            if(lic.getName() == 'licenseStartDate')
                                            {
                                                licenseRec.BR_Start_Date__c = date.parse(lic.getText().substring(5,7)+'/'+lic.getText().substring(8,lic.getText().length())+'/'+lic.getText().substring(0,4));
                                                licenseRec.BR_Type__c = 'License'; 
                                            } 
                                            else if (lic.getName() == 'appointmentStartDate')
                                            {
                                                licenseRec.BR_Start_Date__c = date.parse(lic.getText().substring(5,7)+'/'+lic.getText().substring(8,lic.getText().length())+'/'+lic.getText().substring(0,4));
                                                licenseRec.BR_Type__c = 'Appointment'; 
                                            }
                                            else if (lic.getName() == 'licenseEndDate')
                                                licenseRec.BR_End_Date__c = date.parse(lic.getText().substring(5,7)+'/'+lic.getText().substring(8,lic.getText().length())+'/'+lic.getText().substring(0,4));
                                            else if (lic.getName() == 'appointmentEndDate')
                                                licenseRec.BR_End_Date__c = date.parse(lic.getText().substring(5,7)+'/'+lic.getText().substring(8,lic.getText().length())+'/'+lic.getText().substring(0,4));
                                            
                                        }
                                        licenseList.add(licenseRec);
                                    }
                                }
                            }
                            else if (child.getName() == 'Relationship')
                            {
                                for(Dom.XMLNode relnChild : child.getChildElements()) 
                                {
                                    String lob = relnChild.getChildElement('lineOfBusiness','http://wellpoint.com/schema/Broker/v1').getText();
                                    if (lob == 'INDIVIDUAL' || lob == 'SMALLGROUP')
                                    {
                                        Brokerage_Broker__c relnshipRec = new Brokerage_Broker__c();
                                        if (brokerType == 'Agency')
                                            relnshipRec.BR_Broker_Type__c = 'A';
                                        else
                                            relnshipRec.BR_Broker_Type__c = 'B';
                                        relnshipRec.BR_Contract_Type__c = lob;
                                        relnshipRec.BR_State__c = stateCd;
                                        for(Dom.XMLNode reln : relnChild.getChildElements())
                                        {
                                        //  if (reln.getName() == 'ascsIdentifier')
                                        //      relnshipRec.BR_ASCS_Broker_Code__c = reln.getText();
                                            if(reln.getName() == 'legacyIdentifier')
                                                relnshipRec.BR_ASCS_Co_Id__c = reln.getText();
                                            else if (reln.getName() == 'paidEncryptedTaxIdentifier')
                                                relnshipRec.BR_Paid_Encrypted_TIN__c = reln.getText();
                                            else if (reln.getName() == 'parentEncryptedTaxIdentifier')
                                                relnshipRec.BR_Parent_Encrypted_TIN__c = reln.getText();
                                        //  else if (reln.getName() == 'parentTaxIdentifier')
                                        //      relnshipRec.BR_Parent_TIN__c = reln.getText();
                                            else if (reln.getName() == 'writingEncryptedTaxIdentifier')
                                                relnshipRec.BR_Writing_Encrypted_TIN__c = reln.getText();                                           
                                       //    else if (reln.getName() == 'parentAgencyName')
                                       //         relnshipRec.BR_Writing_Encrypted_TIN__c = reln.getText(); // change field name
                                            else if (reln.getName() == 'startDate')
                                                relnshipRec.BR_Start_Date__c = date.parse(reln.getText().substring(5,7)+'/'+reln.getText().substring(8,reln.getText().length())+'/'+reln.getText().substring(0,4));
                                        } 
                                        relationshipList.add(relnshipRec);
                                    }                                   
                                }
                            }
                            else if (child.getName() == 'HixCert')
                            {
                                for(Dom.XMLNode certChild : child.getChildElements()) 
                                {
                                    Certification__c certRec = new Certification__c();
                                    certRec.BR_State__c = stateCd;
                                    for(Dom.XMLNode cert : certChild.getChildElements())
                                    {
                                        if (cert.getName() == 'certNumber')
                                            certRec.BR_Certificate_Number__c = cert.getText();
                                        else if(cert.getName() == 'certYear')
                                            certRec.BR_Certificate_Year__c = cert.getText();
                                        else if (cert.getName() == 'exchangeType')
                                            certRec.BR_Exchange_Type__c = cert.getText();
                                        else if (cert.getName() == 'certEffDate')
                                            certRec.BR_Certificate_Effective_Date__c = date.parse(cert.getText().substring(5,7)+'/'+cert.getText().substring(8,cert.getText().length())+'/'+cert.getText().substring(0,4));
                                        else if (cert.getName() == 'certTermDate')
                                            certRec.BR_Certificate_End_Date__c = date.parse(cert.getText().substring(5,7)+'/'+cert.getText().substring(8,cert.getText().length())+'/'+cert.getText().substring(0,4));
                                        else if(cert.getName() == 'lineOfBusiness')
                                            certRec.BR_MBU_Type__c = cert.getText();
                                    } 
                                    certList.add(certRec);
                                }
                            }
                            /*
                            else if (child.getName() == 'SalesContact')
                            {
                                for(Dom.XMLNode salesConChild : child.getChildElements()) 
                                {
                                    if (salesConChild.getName() == 'AccountManager')
                                    {
                                        if(salesConChild.getChildren() != NULL)
                                        {
                                            Sales_Team__c salesConRec = new Sales_Team__c();
                                            for(Dom.XMLNode temp1 : salesConChild.getChildElements())
                                            {
                                                String accMgrName = salesConChild.getChildElement('firstName','http://wellpoint.com/schema/Base/v2').getText()+' '+salesConChild.getChildElement('lastName','http://wellpoint.com/schema/Base/v2').getText(); 
                                                if (accMgrName != null && salesConRec.BR_RSM_Name__c == null)
                                                {
                                                    salesConRec.BR_State__c = stateCd;
                                                    salesConRec.BR_RSM_Name__c = accMgrName;
                                                    salesTeamList.add(salesConRec);
                                                }
                                            }
                                        }
                                    }
                                }
                            } 
                            */
                            else if (child.getName() == 'Contract')
                            {                       
                                for(Dom.XMLNode contractChild : child.getChildElements()) 
                                {
                                    String contrLOB = contractChild.getChildElement('lineOfBusiness', 'http://wellpoint.com/schema/Broker/v1').getText();
                                    if (contrLOB == 'INDIVIDUAL' || contrLOB == 'SMALLGROUP')
                                    {
                                        License_Appointment__c contractRec = new License_Appointment__c();
                                        contractRec.BR_Type__c = 'Contract'; 
                                        contractRec.BR_State__c = stateCd;
                                        contractRec.BR_Encrypt_ID__c = brkEncTaxId;
                                        for(Dom.XMLNode con : contractChild.getChildElements())
                                        {
                                            if(con.getName() == 'startDate')
                                                contractRec.BR_Start_Date__c = date.parse(con.getText().substring(5,7)+'/'+con.getText().substring(8,con.getText().length())+'/'+con.getText().substring(0,4));
                                            else if (con.getName() == 'endDate')
                                                contractRec.BR_End_Date__c = date.parse(con.getText().substring(5,7)+'/'+con.getText().substring(8,con.getText().length())+'/'+con.getText().substring(0,4));
    //                                      else if (con.getName() == 'BrokerCategoryCode')
    //                                          contractRec.BR_Broker_Type__c = con.getChildElement('code', 'http://wellpoint.com/schema/CodeTypes/v2').getText();
    //                                      else if (con.getName() == 'internalExternal')
     //                                         contractRec.BR_Broker_Type__c = con.getText();  // check and change field name
                                        }
                                        contractList.add(contractRec);
                                    }
                                }
                            }                       
                        }
                    }
                }
                accountList.add(accountRec);
                //system.debug('relationshipList list size = '+relationshipList.size());
                //system.debug('licenseList list size = '+licenseList.size());
                //system.debug('ContractList list size = '+contractList.size());
                //system.debug('certList list size = '+certList.size());
                //system.debug('salesTeamList list size = '+salesTeamList.size());
                //system.debug('accountList list size = '+accountList.size());
    
                // for cc
				/*
                if (brokerType == 'Agency')
                    ccRecCount= accountList.size()*6;
                else 
                    ccRecCount= accountList.size()*7;
                
                wsCiphercloudComDpaas.Field[] ccInput;
                wsCiphercloudComDpaas.Field[] ccOutput;
                try{
                    ccInput = prepareCCRequest(ccRecCount);
                    ccOutput = invokeCC(ccInput);
                }catch(Exception ex){
                   brokerInfo.errorMsg = 'Issue while Invoking Ciphercloud. Please check with the administrator.';
                   System.debug('Error invoking CipherCloud: '+ex.getMessage()); 
                }
                */
                
                if(brokerInfo.errorMsg == null)
                {
//                    updateWithCCData(ccOutput);
                    // for cc
                    brokerInfo.lAList = licenseList;
                    brokerInfo.accList = accountList;
                    brokerInfo.relationList = relationshipList;
                    brokerInfo.certiList = certList;
                    brokerInfo.conList = contractList;
                    brokerInfo.brokerType = brokerType;
        //          brokerInfo.add(String.valueOf(salesTeamList));
                }
            }else{
                Dom.XMLNode faultResponseBody = respEnv.getchildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/').getChildElement('Fault', 'http://schemas.xmlsoap.org/soap/envelope/');
                for(Dom.XMLNode faultRespData : faultResponseBody.getChildElements()){
                    if (faultRespData.getName() == 'detail')
                    {
                        Dom.XMLNode execptionL = faultRespData.getChildElement('ExceptionList', 'http://wellpoint.com/service/exception/v2').getChildElement('Exception', 'http://wellpoint.com/service/exception/v2');
                        String exceptionMsg = execptionL.getChildElement('message','http://wellpoint.com/service/exception/v2').getText(); 
                        if(exceptionMsg != null)
                           brokerInfo.errorMsg = 'Member not found in ASCS system';
                    }
                }
            }
        }
        catch(Exception e)
        {
            //brokerInfo.errorMsg = 'Response parsing issue. Please check with the administrator.';
            System.debug('Error parsing response: '+e.getMessage());
        }
        return brokerInfo;
    } 
       
    /*
    public wsCiphercloudComDpaas.Field[] prepareCCRequest(Integer recCount)
    {
        wsCiphercloudComDpaas.Field[] inpFlds = new wsCiphercloudComDpaas.Field[recCount];
        Integer i = 0;
        lookupHeaderInfo('CipherCloud');
        /*
            for(Integer m = 0; m <= licenseList.size()-1; m++)
            {
                inpFlds[i] = new wsCiphercloudComDpaas.Field();
                inpFlds[i].applicationName = appName;
                inpFlds[i].clearTextValue = licenseList[m].BR_Number__c;
                inpFlds[i].entityName = 'License/Appointment';
                inpFlds[i].fieldName = 'Number';
                i++;
                inpFlds[i] = new wsCiphercloudComDpaas.Field();
                inpFlds[i].applicationName = appName;
                inpFlds[i].clearTextValue = licenseList[m].BR_State__c;
                inpFlds[i].entityName = 'License/Appointment';
                inpFlds[i].fieldName = 'State';
                i++;
            }
            system.debug('inpFlds after license = '+inpFlds+' and i = '+i);
            
            for(Integer j = 0; j <= relationshipList.size()-1; j++)
            {
                inpFlds[i] = new wsCiphercloudComDpaas.Field();
                inpFlds[i].applicationName = appName;
                inpFlds[i].clearTextValue = relationshipList[j].BR_Parent_TIN__c;
                inpFlds[i].entityName = 'Brokerage_Broker__c';
                inpFlds[i].fieldName = 'Parent TIN';
                i++;
                inpFlds[i] = new wsCiphercloudComDpaas.Field();
                inpFlds[i].applicationName = appName;
                inpFlds[i].clearTextValue = relationshipList[j].BR_State__c;
                inpFlds[i].entityName = 'Brokerage_Broker__c';
                inpFlds[i].fieldName = 'State';
                i++;                
                inpFlds[i] = new wsCiphercloudComDpaas.Field();
                inpFlds[i].applicationName = appName;
                inpFlds[i].clearTextValue = relationshipList[j].BR_ASCS_Broker_Code__c;
                inpFlds[i].entityName = 'Brokerage_Broker__c';
                inpFlds[i].fieldName = 'Agent Code';
                i++;        
            }
            system.debug('inpFlds after relationship = '+inpFlds+' and i = '+i);
            
            for(Integer k = 0; k <= salesTeamList.size()-1; k++)
            {
                inpFlds[i] = new wsCiphercloudComDpaas.Field();
                inpFlds[i].applicationName = appName;
                inpFlds[i].clearTextValue = salesTeamList[k].BR_RSM_Name__c;
                inpFlds[i].entityName = 'Sales_Team__c';
                inpFlds[i].fieldName = 'RSM Name';
                i++;
            }
        
        inpFlds[i] = new wsCiphercloudComDpaas.Field();
        inpFlds[i].applicationName = appName;
        inpFlds[i].entityName = 'Account';
        inpFlds[i].fieldName = 'Name';
        inpFlds[i].clearTextValue = accountList[0].Name;
        i++;
        
        if (brokerType != 'Agency')
        {
            inpFlds[i] = new wsCiphercloudComDpaas.Field();
            inpFlds[i].applicationName = appName;
            inpFlds[i].entityName = 'Account';
            inpFlds[i].fieldName = 'LastName';
            inpFlds[i].clearTextValue = accountList[0].LastName;
            i++;
        }
        
        
        inpFlds[i] = new wsCiphercloudComDpaas.Field();
        inpFlds[i].applicationName = appName;
        inpFlds[i].entityName = 'Account';
        inpFlds[i].fieldName = 'National Producer Number';
        inpFlds[i].clearTextValue = accountList[0].BR_National_Producer_Number__c;
        i++;
        
        inpFlds[i] = new wsCiphercloudComDpaas.Field();
        inpFlds[i].applicationName = appName;
        inpFlds[i].entityName = 'Account';
        inpFlds[i].fieldName = 'Tax Identification Number';
        inpFlds[i].clearTextValue = accountList[0].BR_Tax_Identification_Number__c;
        i++;
        
        inpFlds[i] = new wsCiphercloudComDpaas.Field();
        inpFlds[i].applicationName = appName;
        inpFlds[i].entityName = 'Account';
        inpFlds[i].fieldName = 'PersonEmail';
        inpFlds[i].clearTextValue = accountList[0].PersonEmail;
        i++;
        inpFlds[i] = new wsCiphercloudComDpaas.Field();
        inpFlds[i].applicationName = appName;
        inpFlds[i].entityName = 'Account';
        inpFlds[i].fieldName = 'Phone';
        inpFlds[i].clearTextValue = accountList[0].Phone;
        i++;
        inpFlds[i] = new wsCiphercloudComDpaas.Field();
        inpFlds[i].applicationName = appName;
        inpFlds[i].entityName = 'Account';
        inpFlds[i].fieldName = 'Billing_Street__c';
        inpFlds[i].clearTextValue = accountList[0].Billing_Street__c;
        i++;
        inpFlds[i] = new wsCiphercloudComDpaas.Field();
        inpFlds[i].applicationName = appName;
        inpFlds[i].entityName = 'Account';
        inpFlds[i].fieldName = 'Billing_City__c';
        inpFlds[i].clearTextValue = accountList[0].Billing_City__c;
        i++;
        inpFlds[i] = new wsCiphercloudComDpaas.Field();
        inpFlds[i].applicationName = appName;
        inpFlds[i].entityName = 'Account';
        inpFlds[i].fieldName = 'Billing_PostalCode__c';
        inpFlds[i].clearTextValue = accountList[0].Billing_PostalCode__c;
        
        i++;
        return inpFlds;
    }
    
    public wsCiphercloudComDpaas.Field[] invokeCC (wsCiphercloudComDpaas.Field[] inpFlds)
    {
        //lookupHeaderInfo('CipherCloud');
        String sessId = UserInfo.getSessionId();
        String appurl = appUrl;
        CCwellpointComEsbHeaderV3.ESBHeaderType esbhead = new CCwellpointComEsbHeaderV3.ESBHeaderType();
        esbhead.operName = opName;
        esbhead.senderApp = sndrApp;            
        esbhead.srvcName = svcName;
        esbhead.srvcVersion = svcVersion;
        esbhead.transId = txnId;
        wsCiphercloudComDpaas.DataProtectionCipherCloudPort cc = new wsCiphercloudComDpaas.DataProtectionCipherCloudPort();     
        cc.request_header = esbhead;
        cc.clientCertName_x = certName;
        wsCiphercloudComDpaas.Field[] outFlds;
           
            outFlds = cc.tokenize(sessId, appurl, inpFlds);
            system.debug('outFlds = '+outFlds);
        
        return outFlds;
    }   
    public void updateWithCCData(wsCiphercloudComDpaas.Field[] outFlds)
    {
        for (Integer n = 0; n <= outFlds.size()-1; n++)
        {
            if (outFlds[n].entityName == 'Account' && outFlds[n].fieldName == 'Name')
                accountList[0].Name = outFlds[n].cipherTextValue.substringAfter('A[').substringBefore(']');
            else if (outFlds[n].entityName == 'Account' && outFlds[n].fieldName == 'LastName')
                accountList[0].LastName = outFlds[n].cipherTextValue;
            else if (outFlds[n].entityName == 'Account' && outFlds[n].fieldName == 'PersonEmail')
                accountList[0].PersonEmail = outFlds[n].cipherTextValue;
            else if (outFlds[n].entityName == 'Account' && outFlds[n].fieldName == 'Phone')
                accountList[0].Phone = outFlds[n].cipherTextValue;
            else if (outFlds[n].entityName == 'Account' && outFlds[n].fieldName == 'Billing_Street__c')
                accountList[0].Billing_Street__c = outFlds[n].cipherTextValue;
            else if (outFlds[n].entityName == 'Account' && outFlds[n].fieldName == 'Billing_City__c')
                accountList[0].Billing_City__c = outFlds[n].cipherTextValue;
            else if (outFlds[n].entityName == 'Account' && outFlds[n].fieldName == 'Billing_PostalCode__c')
                accountList[0].Billing_PostalCode__c = outFlds[n].cipherTextValue;
            
            System.debug('After Cipher:::::'+accountList[0].Name);
        }
    }
    */
    
}