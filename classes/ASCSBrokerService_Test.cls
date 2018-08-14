@isTest
public with sharing class ASCSBrokerService_Test {

  static testmethod void testRetrieveBrokerData()
    {
        String brokerId = '12345678';
        ASCSBrokerService rbi = new ASCSBrokerService();
  
        OutboundWS__c ou = new OutboundWS__c();
        ou.Name = 'ASCS';
        ou.Endpoint__c = 'https://non-prods-dp.wellpoint.com:6443/Broker/1.01/BrokerInquiry';
        ou.Operation__c = 'getSummary';
        ou.SenderApp__c = 'SFISG';
        ou.ServiceName__c = 'BrokerInquiry';
        ou.SoapAction__c = 'http://wsdl/BrokerInquiry_Interface_V1/BrokerInquiry/getSummary/';
        ou.ServiceVersion__c = '1.0';
        ou.Timeout__c = '90000';
        ou.CertName__c = 'CA_Certificate_For_Integration';
        insert ou; 
         
        rbi.lookupHeaderInfo('ASCS'); 
        String currTxnId = rbi.txnId;
        system.debug('CurrTxn id from rbi = '+currTxnId);
        System.assertEquals('https://non-prods-dp.wellpoint.com:6443/Broker/1.01/BrokerInquiry', rbi.endPoint);
        System.assertEquals('http://wsdl/BrokerInquiry_Interface_V1/BrokerInquiry/getSummary/', rbi.soapAction);
        System.assertEquals('getSummary', rbi.opName);
        System.assertEquals('SFISG', rbi.sndrApp);
        System.assertEquals('BrokerInquiry', rbi.svcName);
        System.assertEquals('1.0', rbi.svcVersion);
        System.assertEquals('90000', rbi.timeout);
        System.assertEquals('CA_Certificate_For_Integration', rbi.certName);
        
        delete ou;

        //  testing function buildRequestBody
        String reqStr = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:v1="http://wellpoint.com/schema/getSummaryRequest/v1" xmlns:v2="http://wellpoint.com/esb/header/v2" xmlns:v21="http://wellpoint.com/schema/CodeTypes/v2" xmlns:v11="http://wellpoint.com/schema/Broker/v1" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><v2:ESBHeader><v2:srvcName>BrokerInquiry</v2:srvcName><v2:srvcVersion>1.0</v2:srvcVersion><v2:operName>getSummary</v2:operName><v2:senderApp>SFISG</v2:senderApp><v2:transId>'+currTxnId+'</v2:transId></v2:ESBHeader></soapenv:Header><soapenv:Body><v1:getSummaryRequest><v11:brokerIdentifier>12345678</v11:brokerIdentifier><v11:getHixCert>YES</v11:getHixCert></v1:getSummaryRequest></soapenv:Body></soapenv:Envelope>';
        String reqxml = rbi.buildRequestBody('12345678');
        system.debug('reqxml from rbi ='+reqxml);
        System.assertEquals(reqStr, reqxml);
        
        // testing function prepareHTTPReq 
        system.debug('reqStr = '+reqStr);
        HttpRequest hreq = rbi.prepareHTTPReq(reqxml);
        System.assertEquals('https://non-prods-dp.wellpoint.com:6443/Broker/1.01/BrokerInquiry', hreq.getEndpoint());
        System.assertEquals('text/xml', hreq.getHeader('Content-Type'));
        System.assertEquals('http://wsdl/BrokerInquiry_Interface_V1/BrokerInquiry/getSummary/', hreq.getHeader('soapAction'));
        System.assertEquals('POST', hreq.getMethod());
        
        OutboundWS__c ou2 = new OutboundWS__c();
        ou2.Name = 'CipherCloud';
        ou2.Endpoint__c = 'https://non-prods-dp.wellpoint.com:6443/Utility/1.01/DataProtectionCipherCloud';
        ou2.Operation__c = 'tokenize';
        ou2.SenderApp__c = 'SFISG';
        ou2.ServiceName__c = 'DataProtectionCipherCloud';
        ou2.ServiceVersion__c = '1.0';
        ou2.Timeout__c = '90000';
        ou2.AppName__c = 'ic';
        ou2.CertName__c = 'CA_Certificate_For_Integration';
        ou2.AppUrl__c = 'https://anthemssoidp--Config.cs15.my.salesforce.com/services/Soap/u/33.0/00De0000005VGP0';
        insert ou2;
        
        rbi.lookupHeaderInfo('CipherCloud');
        
        ASCSBrokerService asc1 = new ASCSBrokerService();
        ASCSServiceInfo ascInfo1 = new ASCSServiceInfo();
        DOM.Document brkResponse = new DOM.Document();
//      String brkResp = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><out12:getSummaryResponse xmlns:out4="wsdl.http://WSL_BrokerInquiryModule/GetSummaryIF" xmlns:xs4xs="http://www.w3.org/2001/XMLSchema" xmlns:io7="http://www.w3.org/2003/05/soap-envelope" xmlns:out14="http://wellpoint.com/schema/getSummaryRequest/v1" xmlns:io6="http://www.w3.org/2005/08/addressing" xmlns:out13="http://wellpoint.com/schema/Group/v2" xmlns:io5="http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0" xmlns:out12="http://wellpoint.com/schema/getSummaryResponse/v1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:out="http://wellpoint.com/schema/Base/v2" xmlns:io4="http://www.ibm.com/websphere/sibx/smo/v6.0.1" xmlns:out11="http://wellpoint.com/service/exception/v2" xmlns:io3="http://wellpoint.com/esb/header/v2" xmlns:out10="http://wellpoint.com/schema/IdentifierTypes/v2" xmlns:io2="http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0" xmlns:out9="http://WSL_BrokerInquiryModule/GetSummaryIF" xmlns:out8="http://wellpoint.com/schema/Broker/v1" xmlns:out7="http://wellpoint.com/schema/Vendor/v2" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:out6="http://wellpoint.com/schema/ContactInfo/v2" xmlns:out5="http://wellpoint.com/schema/CodeTypes/v2" xmlns:io="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:out3="http://wellpoint.com/schema/Primitives/v2" xmlns:out2="http://wellpoint.com/schema/Product/v2"><out8:BrokerSummary><out10:taxIdentifier>081220134</out10:taxIdentifier><out10:encryptedTaxIdentifier>GFDJGJKMVZ</out10:encryptedTaxIdentifier><out8:starBrokerTin>081220134S</out8:starBrokerTin><out8:nationalProducerNumber>0813205</out8:nationalProducerNumber><out:firstName>MIKE</out:firstName><out:middleName/><out:lastName>BAUM</out:lastName><out5:BrokerTypeCode><out5:code>Agent</out5:code></out5:BrokerTypeCode><out6:ContactAddress><out5:AddressTypeCode><out5:code>Mailing Address</out5:code></out5:AddressTypeCode><out:addressLine1Text>220 VIRGINIA AVE</out:addressLine1Text><out:addressLine2Text>MS IN020 B560</out:addressLine2Text><out:cityName>INDIANAPOLIS</out:cityName><out5:StateCode><out5:code>IN</out5:code></out5:StateCode><out5:PostalCode>46204</out5:PostalCode></out6:ContactAddress><out6:ContactElectronicMail><out:emailAddressText>MIKE.BAUM@ANTHEM.COM</out:emailAddressText></out6:ContactElectronicMail><out6:ContactTelephone><out5:TelephoneTypeCode><out5:code>OFFICE</out5:code></out5:TelephoneTypeCode><out:telephoneNumber>5133364758</out:telephoneNumber></out6:ContactTelephone><out8:Information><out5:StateCode><out5:code>GA</out5:code></out5:StateCode><out8:SalesContact><out8:AccountManager><out8:managerIdentifier>FCDFPHKTQZ</out8:managerIdentifier><out:firstName>maddy</out:firstName><out:middleName/><out:lastName>Kiki</out:lastName></out8:AccountManager><out8:AccountManager><out8:managerIdentifier>FCDFPHKTQZ</out8:managerIdentifier><out:firstName>DANIEL</out:firstName><out:middleName/><out:lastName>KIKOSICKI</out:lastName></out8:AccountManager></out8:SalesContact><out8:Relationship><out8:ContractType><out8:lineOfBusiness>INDIVIDUAL</out8:lineOfBusiness><out8:parentEncryptedTaxIdentifier>GFDJGJKMVZ</out8:parentEncryptedTaxIdentifier><out8:parentTaxIdentifier>081220134S</out8:parentTaxIdentifier><out8:parentAgencyName>MIKE BAUM</out8:parentAgencyName><out8:paidEncryptedTaxIdentifier>GFDJGJKMVZ</out8:paidEncryptedTaxIdentifier><out8:paidAgencyName>MIKE BAUM</out8:paidAgencyName><out8:reportEncryptedTaxIdentifier/><out:startDate>2013-08-12</out:startDate><out8:ascsIdentifier>BrkPrt117</out8:ascsIdentifier><out8:legacyIdentifier>A081220134000</out8:legacyIdentifier><out8:exchangeIndicator>Y</out8:exchangeIndicator></out8:ContractType><out8:ContractType><out8:lineOfBusiness>SMALLGROUP</out8:lineOfBusiness><out8:parentEncryptedTaxIdentifier>GFDJGJKMVZ</out8:parentEncryptedTaxIdentifier><out8:parentTaxIdentifier>081220134S</out8:parentTaxIdentifier><out8:parentAgencyName>MIKE BAUM</out8:parentAgencyName><out8:paidEncryptedTaxIdentifier>GFDJGJKMVZ</out8:paidEncryptedTaxIdentifier><out8:paidAgencyName>MIKE BAUM</out8:paidAgencyName><out8:reportEncryptedTaxIdentifier/><out:startDate>2013-08-12</out:startDate><out8:ascsIdentifier>BrkPl117G</out8:ascsIdentifier><out8:legacyIdentifier>A081220134000</out8:legacyIdentifier><out8:exchangeIndicator>Y</out8:exchangeIndicator></out8:ContractType></out8:Relationship><out8:Contract><out8:BusinessDivision><out8:lineOfBusiness>INDIVIDUAL</out8:lineOfBusiness><out8:BrokerCategoryCode><out5:code>ADVANTAGE</out5:code></out8:BrokerCategoryCode><out:startDate>2013-08-12</out:startDate><out8:internalExternal>External</out8:internalExternal></out8:BusinessDivision><out8:BusinessDivision><out8:lineOfBusiness>SMALLGROUP</out8:lineOfBusiness><out8:BrokerCategoryCode><out5:code>ADVANTAGE</out5:code></out8:BrokerCategoryCode><out:startDate>2013-08-12</out:startDate><out8:internalExternal>External</out8:internalExternal></out8:BusinessDivision></out8:Contract><out8:LicenseAppointment><out8:LicenseType><out8:lineOfBusiness>HEALTH</out8:lineOfBusiness><out8:licenseNumber>1220221</out8:licenseNumber><out8:appointmentStartDate>2013-08-01</out8:appointmentStartDate></out8:LicenseType></out8:LicenseAppointment><out8:LicenseAppointment><out8:LicenseType><out8:lineOfBusiness>HEALTH</out8:lineOfBusiness><out8:licenseNumber>0D75496</out8:licenseNumber><out8:licenseEndDate>2010-05-04</out8:licenseEndDate><out8:licenseEndDate>2016-09-30</out8:licenseEndDate></out8:LicenseType></out8:LicenseAppointment><out8:HixCert><out8:HixCertType><out8:exchangeType>a</out8:exchangeType><out8:lineOfBusiness>a</out8:lineOfBusiness><out8:certYear>a</out8:certYear><out8:certEffDate>1957-08-13</out8:certEffDate><out8:certSource>a</out8:certSource><out8:certNumber>a</out8:certNumber><out8:certTermDate>1957-08-13</out8:certTermDate><out8:certComplDate>1957-08-13</out8:certComplDate></out8:HixCertType></out8:HixCert></out8:Information></out8:BrokerSummary></out12:getSummaryResponse></soapenv:Body></soapenv:Envelope>';
        String brkResp = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><out12:getSummaryResponse xmlns:out4="wsdl.http://WSL_BrokerInquiryModule/GetSummaryIF" xmlns:xs4xs="http://www.w3.org/2001/XMLSchema" xmlns:io7="http://www.w3.org/2003/05/soap-envelope" xmlns:out14="http://wellpoint.com/schema/getSummaryRequest/v1" xmlns:io6="http://www.w3.org/2005/08/addressing" xmlns:out13="http://wellpoint.com/schema/Group/v2" xmlns:io5="http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0" xmlns:out12="http://wellpoint.com/schema/getSummaryResponse/v1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:out="http://wellpoint.com/schema/Base/v2" xmlns:io4="http://www.ibm.com/websphere/sibx/smo/v6.0.1" xmlns:out11="http://wellpoint.com/service/exception/v2" xmlns:io3="http://wellpoint.com/esb/header/v2" xmlns:out10="http://wellpoint.com/schema/IdentifierTypes/v2" xmlns:io2="http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0" xmlns:out9="http://WSL_BrokerInquiryModule/GetSummaryIF" xmlns:out8="http://wellpoint.com/schema/Broker/v1" xmlns:out7="http://wellpoint.com/schema/Vendor/v2" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:out6="http://wellpoint.com/schema/ContactInfo/v2" xmlns:out5="http://wellpoint.com/schema/CodeTypes/v2" xmlns:io="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:out3="http://wellpoint.com/schema/Primitives/v2" xmlns:out2="http://wellpoint.com/schema/Product/v2"><out8:BrokerSummary><out10:taxIdentifier>081220134</out10:taxIdentifier><out10:encryptedTaxIdentifier>GFDJGJKMVZ</out10:encryptedTaxIdentifier><out8:starBrokerTin>081220134S</out8:starBrokerTin><out8:nationalProducerNumber>0813205</out8:nationalProducerNumber><out:firstName>MIKE</out:firstName><out:middleName/><out:lastName>BAUM</out:lastName><out5:BrokerTypeCode><out5:code>Agent</out5:code></out5:BrokerTypeCode><out6:ContactAddress><out5:AddressTypeCode><out5:code>Mailing Address</out5:code></out5:AddressTypeCode><out:addressLine1Text>220 VIRGINIA AVE</out:addressLine1Text><out:addressLine2Text>MS IN020 B560</out:addressLine2Text><out:cityName>INDIANAPOLIS</out:cityName><out5:StateCode><out5:code>IN</out5:code></out5:StateCode><out5:PostalCode>46204</out5:PostalCode><out5:CountyCode><out5:code>a</out5:code></out5:CountyCode></out6:ContactAddress><out6:ContactElectronicMail><out:emailAddressText>MIKE.BAUM@ANTHEM.COM</out:emailAddressText></out6:ContactElectronicMail><out6:ContactTelephone><out5:TelephoneTypeCode><out5:code>OFFICE</out5:code></out5:TelephoneTypeCode><out:telephoneNumber>5133364758</out:telephoneNumber></out6:ContactTelephone><out8:Information><out5:StateCode><out5:code>GA</out5:code></out5:StateCode><out8:SalesContact><out8:AccountManager><out8:managerIdentifier>FCDFPHKTQZ</out8:managerIdentifier><out:firstName>maddy</out:firstName><out:middleName/><out:lastName>Kiki</out:lastName></out8:AccountManager><out8:AccountManager><out8:managerIdentifier>FCDFPHKTQZ</out8:managerIdentifier><out:firstName>DANIEL</out:firstName><out:middleName/><out:lastName>KIKOSICKI</out:lastName></out8:AccountManager></out8:SalesContact><out8:Relationship><out8:ContractType><out8:lineOfBusiness>INDIVIDUAL</out8:lineOfBusiness><out8:parentEncryptedTaxIdentifier>GFDJGJKMVZ</out8:parentEncryptedTaxIdentifier><out8:parentTaxIdentifier>081220134S</out8:parentTaxIdentifier><out8:parentAgencyName>MIKE BAUM</out8:parentAgencyName><out8:paidEncryptedTaxIdentifier>GFDJGJKMVZ</out8:paidEncryptedTaxIdentifier><out8:paidAgencyName>MIKE BAUM</out8:paidAgencyName><out8:reportEncryptedTaxIdentifier/><out:startDate>2013-08-12</out:startDate><out8:ascsIdentifier>BrkPrt117</out8:ascsIdentifier><out8:legacyIdentifier>A081220134000</out8:legacyIdentifier><out8:exchangeIndicator>Y</out8:exchangeIndicator></out8:ContractType><out8:ContractType><out8:lineOfBusiness>SMALLGROUP</out8:lineOfBusiness><out8:parentEncryptedTaxIdentifier>GFDJGJKMVZ</out8:parentEncryptedTaxIdentifier><out8:parentTaxIdentifier>081220134S</out8:parentTaxIdentifier><out8:parentAgencyName>MIKE BAUM</out8:parentAgencyName><out8:paidEncryptedTaxIdentifier>GFDJGJKMVZ</out8:paidEncryptedTaxIdentifier><out8:paidAgencyName>MIKE BAUM</out8:paidAgencyName><out8:reportEncryptedTaxIdentifier/><out:startDate>2013-08-12</out:startDate><out8:ascsIdentifier>BrkPl117G</out8:ascsIdentifier><out8:legacyIdentifier>A081220134000</out8:legacyIdentifier><out8:exchangeIndicator>Y</out8:exchangeIndicator></out8:ContractType></out8:Relationship><out8:Contract><out8:BusinessDivision><out8:lineOfBusiness>INDIVIDUAL</out8:lineOfBusiness><out8:BrokerCategoryCode><out5:code>ADVANTAGE</out5:code></out8:BrokerCategoryCode><out:startDate>2013-08-12</out:startDate><out:endDate>2017-08-11</out:endDate><out8:internalExternal>External</out8:internalExternal></out8:BusinessDivision><out8:BusinessDivision><out8:lineOfBusiness>SMALLGROUP</out8:lineOfBusiness><out8:BrokerCategoryCode><out5:code>ADVANTAGE</out5:code></out8:BrokerCategoryCode><out:startDate>2013-08-12</out:startDate><out:endDate>2017-08-11</out:endDate><out8:internalExternal>External</out8:internalExternal></out8:BusinessDivision></out8:Contract><out8:LicenseAppointment><out8:LicenseType><out8:lineOfBusiness>HEALTH</out8:lineOfBusiness><out8:licenseNumber>1220221</out8:licenseNumber><out8:appointmentStartDate>2013-08-01</out8:appointmentStartDate></out8:LicenseType></out8:LicenseAppointment><out8:LicenseAppointment><out8:LicenseType><out8:lineOfBusiness>HEALTH</out8:lineOfBusiness><out8:licenseNumber>0D75496</out8:licenseNumber><out8:licenseEndDate>2010-05-04</out8:licenseEndDate><out8:licenseEndDate>2016-09-30</out8:licenseEndDate></out8:LicenseType></out8:LicenseAppointment><out8:HixCert><out8:HixCertType><out8:exchangeType>a</out8:exchangeType><out8:lineOfBusiness>a</out8:lineOfBusiness><out8:certYear>a</out8:certYear><out8:certEffDate>1957-08-13</out8:certEffDate><out8:certSource>a</out8:certSource><out8:certNumber>a</out8:certNumber><out8:certTermDate>1957-08-13</out8:certTermDate><out8:certComplDate>1957-08-13</out8:certComplDate></out8:HixCertType></out8:HixCert></out8:Information></out8:BrokerSummary></out12:getSummaryResponse></soapenv:Body></soapenv:Envelope>';
        brkResponse.load(brkResp);
//      List <String> brokerRespData = asc1.parseResponse(brkResponse);
        ascInfo1 = asc1.parseResponse(brkResponse);
        ascInfo1.brokerType = 'Agent';
        ascInfo1.accList = asc1.accountList;
        ascInfo1.lAList = asc1.licenseList;
        ascInfo1.certiList = asc1.certList;
        ascInfo1.conList = asc1.contractList;
        ascInfo1.relationList = asc1.relationshipList;
        
        System.assertEquals(1, ascInfo1.accList.size());
        System.assertEquals(2, ascInfo1.lAList.size());
        System.assertEquals(1, ascInfo1.certiList.size());
        System.assertEquals(2, ascInfo1.conList.size());
        System.assertEquals(2, ascInfo1.relationList.size());
        
        ASCSBrokerService asc2 = new ASCSBrokerService();
        ASCSServiceInfo ascInfo2 = new ASCSServiceInfo();
        String agncyResp = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><v2:ESBHeader xmlns:v2="http://wellpoint.com/esb/header/v2"><v2:srvcName>BrokerInquiry</v2:srvcName><v2:srvcVersion>1.0</v2:srvcVersion><v2:operName>getSummary</v2:operName><v2:senderApp>PTB</v2:senderApp><v2:transId>12345</v2:transId></v2:ESBHeader></soapenv:Header><soapenv:Body><out12:getSummaryResponse xmlns:out2="http://wellpoint.com/schema/Product/v2" xmlns:out3="http://wellpoint.com/schema/Primitives/v2" xmlns:io="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:out5="http://wellpoint.com/schema/CodeTypes/v2" xmlns:out6="http://wellpoint.com/schema/ContactInfo/v2" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:out7="http://wellpoint.com/schema/Vendor/v2" xmlns:out8="http://wellpoint.com/schema/Broker/v1" xmlns:out9="http://WSL_BrokerInquiryModule/GetSummaryIF" xmlns:io2="http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0" xmlns:out10="http://wellpoint.com/schema/IdentifierTypes/v2" xmlns:io3="http://wellpoint.com/esb/header/v2" xmlns:out11="http://wellpoint.com/service/exception/v2" xmlns:io4="http://www.ibm.com/websphere/sibx/smo/v6.0.1" xmlns:out="http://wellpoint.com/schema/Base/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:out12="http://wellpoint.com/schema/getSummaryResponse/v1" xmlns:io5="http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0" xmlns:out13="http://wellpoint.com/schema/Group/v2" xmlns:io6="http://www.w3.org/2005/08/addressing" xmlns:out14="http://wellpoint.com/schema/getSummaryRequest/v1" xmlns:io7="http://www.w3.org/2003/05/soap-envelope" xmlns:xs4xs="http://www.w3.org/2001/XMLSchema" xmlns:out4="wsdl.http://WSL_BrokerInquiryModule/GetSummaryIF"><out8:BrokerSummary><out10:taxIdentifier>611121124</out10:taxIdentifier><out10:encryptedTaxIdentifier>GFLHHJKLMY</out10:encryptedTaxIdentifier><out8:starBrokerTin>611121124E</out8:starBrokerTin><out8:nationalProducerNumber>963291</out8:nationalProducerNumber><out8:agencyName>R H CLARKSON FINANCIAL SERVICES</out8:agencyName><out5:BrokerTypeCode><out5:code>Agency</out5:code><out5:description/></out5:BrokerTypeCode><out6:ContactAddress><out5:AddressTypeCode><out5:code>Mailing Address</out5:code></out5:AddressTypeCode><out:addressLine1Text>PO BOX 70529</out:addressLine1Text><out:addressLine2Text/><out:cityName>LOUISVILLE</out:cityName><out5:StateCode><out5:code>KY</out5:code></out5:StateCode><out5:PostalCode>40270</out5:PostalCode><out:postalCodeExtensionNumber/><out5:CountyCode><out5:code>a</out5:code></out5:CountyCode></out6:ContactAddress><out6:ContactElectronicMail><out:emailAddressText>MKAELIN@RHCGROUP.COM</out:emailAddressText></out6:ContactElectronicMail><out6:ContactTelephone><out5:TelephoneTypeCode><out5:code>OFFICE</out5:code></out5:TelephoneTypeCode><out:telephoneNumber>5025853600</out:telephoneNumber></out6:ContactTelephone><out6:ContactTelephone><out5:TelephoneTypeCode><out5:code>OFFICE EXTENSION</out5:code></out5:TelephoneTypeCode><out:telephoneNumber>3600</out:telephoneNumber></out6:ContactTelephone><out8:Information><out5:StateCode><out5:code>CA</out5:code></out5:StateCode><out8:Relationship><out8:ContractType><out8:lineOfBusiness>INDIVIDUAL</out8:lineOfBusiness><out8:parentEncryptedTaxIdentifier>GFLHHJKLMY</out8:parentEncryptedTaxIdentifier><out8:parentTaxIdentifier>611121124E</out8:parentTaxIdentifier><out8:parentAgencyName>R H CLARKSON FINANCIAL SERVICES</out8:parentAgencyName><out8:paidEncryptedTaxIdentifier>GFLHHJKLMY</out8:paidEncryptedTaxIdentifier><out8:paidAgencyName>R H CLARKSON FINANCIAL SERVICES</out8:paidAgencyName><out8:reportEncryptedTaxIdentifier/><out:startDate>2002-08-05</out:startDate><out8:ascsIdentifier>AAA161060</out8:ascsIdentifier><out8:exchangeIndicator>Y</out8:exchangeIndicator></out8:ContractType><out8:ContractType><out8:lineOfBusiness>SMALLGROUP</out8:lineOfBusiness><out8:parentEncryptedTaxIdentifier>GFLHHJKLMY</out8:parentEncryptedTaxIdentifier><out8:parentTaxIdentifier>611121124E</out8:parentTaxIdentifier><out8:parentAgencyName>R H CLARKSON FINANCIAL SERVICES</out8:parentAgencyName><out8:paidEncryptedTaxIdentifier>GFLHHJKLMY</out8:paidEncryptedTaxIdentifier><out8:paidAgencyName>R H CLARKSON FINANCIAL SERVICES</out8:paidAgencyName><out8:reportEncryptedTaxIdentifier/><out:startDate>2002-08-05</out:startDate><out8:ascsIdentifier>AAA161060</out8:ascsIdentifier><out8:exchangeIndicator>Y</out8:exchangeIndicator></out8:ContractType></out8:Relationship><out8:Contract><out8:BusinessDivision><out8:lineOfBusiness>INDIVIDUAL</out8:lineOfBusiness><out8:BrokerCategoryCode><out5:code>EXTERNAL AGENT</out5:code></out8:BrokerCategoryCode><out:startDate>2010-05-04</out:startDate><out8:internalExternal>External</out8:internalExternal></out8:BusinessDivision><out8:BusinessDivision><out8:lineOfBusiness>SENIOR</out8:lineOfBusiness><out8:BrokerCategoryCode><out5:code>EXTERNAL AGENT</out5:code></out8:BrokerCategoryCode><out:startDate>2010-05-04</out:startDate><out8:internalExternal>External</out8:internalExternal></out8:BusinessDivision><out8:BusinessDivision><out8:lineOfBusiness>SMALLGROUP</out8:lineOfBusiness><out8:BrokerCategoryCode><out5:code>EXTERNAL AGENT</out5:code></out8:BrokerCategoryCode><out:startDate>2010-05-04</out:startDate><out8:internalExternal>External</out8:internalExternal></out8:BusinessDivision></out8:Contract><out8:LicenseAppointment><out8:LicenseType><out8:lineOfBusiness>HEALTH</out8:lineOfBusiness><out8:licenseNumber>0D75496</out8:licenseNumber><out8:appointmentStartDate>2010-05-04</out8:appointmentStartDate><out8:appointmentEndDate>2016-09-30</out8:appointmentEndDate></out8:LicenseType></out8:LicenseAppointment></out8:Information><out8:Information><out5:StateCode><out5:code>GA</out5:code></out5:StateCode><out8:Relationship><out8:ContractType><out8:lineOfBusiness>INDIVIDUAL</out8:lineOfBusiness><out8:parentEncryptedTaxIdentifier>GFLHHJKLMY</out8:parentEncryptedTaxIdentifier><out8:parentTaxIdentifier>611121124E</out8:parentTaxIdentifier><out8:parentAgencyName>R H CLARKSON FINANCIAL SERVICES</out8:parentAgencyName><out8:paidEncryptedTaxIdentifier>GFLHHJKLMY</out8:paidEncryptedTaxIdentifier><out8:paidAgencyName>R H CLARKSON FINANCIAL SERVICES</out8:paidAgencyName><out8:reportEncryptedTaxIdentifier/><out:startDate>1969-01-01</out:startDate><out8:ascsIdentifier>112112400</out8:ascsIdentifier><out8:legacyIdentifier>B611121124000</out8:legacyIdentifier><out8:writingEncryptedTaxIdentifier>683476dsjshfsj</out8:writingEncryptedTaxIdentifier><out8:exchangeIndicator>Y</out8:exchangeIndicator></out8:ContractType><out8:ContractType><out8:lineOfBusiness>SMALLGROUP</out8:lineOfBusiness><out8:parentEncryptedTaxIdentifier>GFLHHJKLMY</out8:parentEncryptedTaxIdentifier><out8:parentTaxIdentifier>611121124E</out8:parentTaxIdentifier><out8:parentAgencyName>R H CLARKSON FINANCIAL SERVICES</out8:parentAgencyName><out8:paidEncryptedTaxIdentifier>GFLHHJKLMY</out8:paidEncryptedTaxIdentifier><out8:paidAgencyName>R H CLARKSON FINANCIAL SERVICES</out8:paidAgencyName><out8:reportEncryptedTaxIdentifier/><out:startDate>1969-01-01</out:startDate><out8:ascsIdentifier>112112400</out8:ascsIdentifier><out8:legacyIdentifier>B611121124000</out8:legacyIdentifier><out8:exchangeIndicator>Y</out8:exchangeIndicator></out8:ContractType></out8:Relationship><out8:Contract><out8:BusinessDivision><out8:lineOfBusiness>INDIVIDUAL</out8:lineOfBusiness><out8:BrokerCategoryCode><out5:code>ADVANTAGE</out5:code></out8:BrokerCategoryCode><out:startDate>2003-05-30</out:startDate><out8:internalExternal>External</out8:internalExternal></out8:BusinessDivision><out8:BusinessDivision><out8:lineOfBusiness>SMALLGROUP</out8:lineOfBusiness><out8:BrokerCategoryCode><out5:code>ADVANTAGE</out5:code></out8:BrokerCategoryCode><out:startDate>2003-05-30</out:startDate><out8:internalExternal>External</out8:internalExternal></out8:BusinessDivision></out8:Contract><out8:LicenseAppointment><out8:LicenseType><out8:lineOfBusiness>HEALTH</out8:lineOfBusiness><out8:licenseNumber>101958</out8:licenseNumber><out8:licenseStartDate>2003-05-30</out8:licenseStartDate></out8:LicenseType></out8:LicenseAppointment></out8:Information></out8:BrokerSummary></out12:getSummaryResponse></soapenv:Body></soapenv:Envelope>';
        DOM.Document agncyResponse = new DOM.Document();
        agncyResponse.load(agncyResp);
//      List <String> agencyRespData = asc2.parseResponse(agncyResponse);
        ascInfo2 = asc2.parseResponse(agncyResponse);
        System.assertEquals(1, asc2.accountList.size());

        ASCSBrokerService asc3 = new ASCSBrokerService();
        ASCSServiceInfo ascInfo3 = new ASCSServiceInfo();
        String faultResp = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><soapenv:Fault xmlns:m="http://schemas.xmlsoap.org/soap/envelope/"><faultcode>m:Server</faultcode><faultstring>1</faultstring><detail><ne1:ExceptionList xmlns:ne1="http://wellpoint.com/service/exception/v2"><ne1:errorCount>1</ne1:errorCount><ne1:Exception><ne1:UUID>WBSgetSummary1442333671488</ne1:UUID><ne1:timestamp>Tue Sep 15 12:14:31 EDT 2015</ne1:timestamp><ne1:node>va10tuvwbs022</ne1:node><ne1:process>BrokerInquiry</ne1:process><ne1:component>getSummary</ne1:component><ne1:code>1001</ne1:code><ne1:severity>HIGH</ne1:severity><ne1:message>‎MEMBER NOT FOUND‎</ne1:message><ne1:detail>Broker identifier not found in ASCS system</ne1:detail></ne1:Exception></ne1:ExceptionList></detail></soapenv:Fault></soapenv:Body></soapenv:Envelope>';
        DOM.Document faultResponse = new DOM.Document();
        faultResponse.load(faultResp);
//      List <String> agencyRespData = asc2.parseResponse(agncyResponse);
        ascInfo3 = asc3.parseResponse(faultResponse);

        /*OutboundWS__c ou2 = new OutboundWS__c();
        ou2.Name = 'CipherCloud';
        ou2.Endpoint__c = 'https://non-prods-dp.wellpoint.com:6443/Utility/1.01/DataProtectionCipherCloud';
        ou2.Operation__c = 'tokenize';
        ou2.SenderApp__c = 'SFISG';
        ou2.ServiceName__c = 'DataProtectionCipherCloud';
        ou2.ServiceVersion__c = '1.0';
        ou2.Timeout__c = '90000';
        ou2.AppName__c = 'ic';
        ou2.CertName__c = 'CA_Certificate_For_Integration';
        ou2.AppUrl__c = 'https://anthemssoidp--Config.cs15.my.salesforce.com/services/Soap/u/33.0/00De0000005VGP0';
        insert ou2;
        
        rbi.lookupHeaderInfo('CipherCloud'); */
        String currTxnId2 = rbi.txnId;
        system.debug('CurrTxn id from rbi = '+currTxnId);
        System.assertEquals('https://non-prods-dp.wellpoint.com:6443/Utility/1.01/DataProtectionCipherCloud', rbi.endPoint);
        System.assertEquals('tokenize', rbi.opName);
        System.assertEquals('SFISG', rbi.sndrApp);
        System.assertEquals('DataProtectionCipherCloud', rbi.svcName);
        System.assertEquals('1.0', rbi.svcVersion);
        System.assertEquals('90000', rbi.timeout);
        System.assertEquals('https://anthemssoidp--Config.cs15.my.salesforce.com/services/Soap/u/33.0/00De0000005VGP0', rbi.appUrl);
        System.assertEquals('ic', rbi.appName);
        
        /*            
        wsCiphercloudComDpaas.Field[] respFlds = new wsCiphercloudComDpaas.Field[8];
        
        respFlds[0] = new wsCiphercloudComDpaas.Field();
        respFlds[0].applicationName = 'ic';
        respFlds[0].entityName = 'Account';
        respFlds[0].fieldName = 'Name';
        respFlds[0].cipherTextValue = 'AANNN';
        
        respFlds[1] = new wsCiphercloudComDpaas.Field();
        respFlds[1].applicationName = 'ic';
        respFlds[1].entityName = 'Account';
        respFlds[1].fieldName = 'LastName';
        respFlds[1].cipherTextValue = 'AANNN';
        
        respFlds[2] = new wsCiphercloudComDpaas.Field();
        respFlds[2].applicationName = 'ic';
        respFlds[2].entityName = 'Account';
        respFlds[2].fieldName = 'BR_National_Producer_Number__c';
        respFlds[2].cipherTextValue = 'AANNN';
        
        respFlds[3] = new wsCiphercloudComDpaas.Field();
        respFlds[3].applicationName = 'ic';
        respFlds[3].entityName = 'Account';
        respFlds[3].fieldName = 'Billing_PostalCode__c';
        respFlds[3].cipherTextValue = 'AANNN';
        
        respFlds[4] = new wsCiphercloudComDpaas.Field();
        respFlds[4].applicationName = 'ic';
        respFlds[4].entityName = 'Account';
        respFlds[4].fieldName = 'PersonEmail';
        respFlds[4].cipherTextValue = 'AANNN';
        
        respFlds[5] = new wsCiphercloudComDpaas.Field();
        respFlds[5].applicationName = 'ic';
        respFlds[5].entityName = 'Account';
        respFlds[5].fieldName = 'Phone';
        respFlds[5].cipherTextValue = 'AANNN';
        
        respFlds[6] = new wsCiphercloudComDpaas.Field();
        respFlds[6].applicationName = 'ic';
        respFlds[6].entityName = 'Account';
        respFlds[6].fieldName = 'Billing_Street__c';
        respFlds[6].cipherTextValue = 'AANNN';
        
        respFlds[7] = new wsCiphercloudComDpaas.Field();
        respFlds[7].applicationName = 'ic';
        respFlds[7].entityName = 'Account';
        respFlds[7].fieldName = 'Billing_City__c';
        respFlds[7].cipherTextValue = 'AANNN';
        
        Account accRec = new Account();
        accRec.BR_Encrypted_TIN__c = 'BR983823';
        accRec.Name = 'ABC Agency';
        accRec.Billing_Street__c = '1122 Main St'+','+'Suite 201'; //
        accRec.Billing_City__c = 'Dallas'; //
        accRec.Billing_State__c = 'TX';
        accRec.Billing_PostalCode__c = '75033';
        accRec.PersonEmail = 'sam@abc.com';
        accRec.Phone = '817-444-2345';
                  
        asc2.accountList.add(accRec);
        asc2.brokerType = 'Agency';
//         wsCiphercloudComDpaas.Field[] ccInp = asc2.prepareCCRequest(6);
        
  //       If(!Test.isRunningTest()){
  //       wsCiphercloudComDpaas.Field[] ccOut = asc2.invokeCC(ccInp);
        
        //asc2.updateWithCCData(respFlds);
        */
        delete ou2;     
    }
}