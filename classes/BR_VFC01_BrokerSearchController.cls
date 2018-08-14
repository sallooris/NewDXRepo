/*******************************************************
Class Name  :  BR_VFC01_BrokerSearchController
Date Created:
Created By  :  Vijay Krishnakumar
Description :  Class used for Broker Search. 
Change History :
1. Modified by Kishore Jonnadula   
*******************************************************/
public with sharing class BR_VFC01_BrokerSearchController
{
   public string AgencyTIN{get;set;}
   public string AgencyCode{get;set;}
   public string AgencyName{get;set;}
   public string AgencyETIN{get;set;}
   public string BrokerTIN{get;set;}
   public string BrokerETIN{get;set;}
   public string BrokerNPN{get;set;}
   public string BrokerName{get;set;}
   public Boolean showCheckboxandBtn {get;set;}
   public string errorMsg{get;set;}
   public Boolean agencyCodeStatus = false;
   public ASCSServiceInfo brokerData{get;set;}
   public List<wrapAccount> wrapAccountList {get;set;}
   public String accountId{get; set;}
   
   //ASCSServiceInfo 
                    
   public BR_VFC01_BrokerSearchController(){
        
   }
   
   public void SearchBroker()
   {
       try
       {
       showCheckboxandBtn = false;
       errorMsg = null;
       brokerData = new ASCSServiceInfo();
       String brokerId = null;
       Account account = null;
      List<Account> accounts = new List<Account>();
           string sSearchParam = 'Select Id, Name, BR_Tax_Identification_Number__c, BR_Encrypted_TIN__c,RecordType.Name from Account ' + getSearchParam();
           if(agencyCodeStatus == false){
                accounts = Database.query(sSearchParam);
           }
           if(accounts.size() > 0){
               wrapBrokerResults(accounts); 
           }else{
               if(AgencyTIN.length() > 0){
                   brokerId = AgencyTIN;
               }else if(AgencyETIN.length() > 0){
                   brokerId = AgencyETIN;
               }else if(BrokerTIN.length() > 0){
                   brokerId = BrokerTIN;
               }else if(BrokerETIN.length() > 0){
                   brokerId = BrokerETIN;
               }else if(BrokerNPN.length() > 0){
                   brokerId = BrokerNPN;
               }
               ASCSBrokerService service = new ASCSBrokerService();
               if(''.equals(brokerId) || brokerId == null)
                  errorMsg = 'No records to display. Please search either by TIN or Encrypted TIN to Continue.'; 
               else
                    brokerData = service.retrieveBrokerData(brokerId);
               if(brokerData.accList != null){
                   showCheckboxandBtn = true;
                   wrapBrokerResults(brokerData.accList);
               }else if(brokerData.errorMsg != null){
                   errorMsg = brokerData.errorMsg;
               }
           }
        }
        catch(Exception e)
        {
            errorMsg = e.getMessage();
            System.debug('Error while searching: '+e.getMessage());
        }
   }
   @TestVisible 
   private void wrapBrokerResults(List<Account> account1){
       wrapAccountList = new List<wrapAccount>();
       String brokerType = null;
       if(brokerData != null && brokerData.brokerType != null){
           brokerType = brokerData.brokerType;
       }
       if(account1.size() > 0){
           for(Account acc: account1){
               wrapAccountList.add(new wrapAccount(acc, brokerType));  
           }
       }
   }
   public class wrapAccount {
        public Account acc {get; set;}
        public Boolean selected {get; set;}
        public String accountType {get; set;}
        public wrapAccount(Account a, String brokerType) {
            acc = a;
            if(brokerType != null){
                if(brokerType.contains('Agency'))
                   accountType = 'Agency';
                else
                   accountType = 'Broker';
            }else{
               accountType = acc.RecordType.Name;
            }
            selected = false; 
        }
   }
   private string getSearchParam()
   {
        string sSearchParam = ' WHERE ';
        string sBrokerSearch = ' AND RecordType.Name=\'Broker\'';
        string sAgencySearch = ' AND RecordType.Name=\'Agency\'';
        string sIdValue = null;
        if(BrokerTIN.length() > 0){
            sIdValue = BrokerTIN;
        }
        else if(BrokerETIN.length() > 0){
            sIdValue = BrokerETIN;
        }
        else if(AgencyTIN.length() > 0){
            sIdValue = AgencyTIN;
        }
        else if(AgencyETIN.length() > 0){
            sIdValue = AgencyETIN;
        }
        else if(BrokerNPN.length() > 0){
            sIdValue = BrokerNPN;
        } 
        else if(AgencyCode.length() > 0){
            String broker = null;
            List<Brokerage_Broker__c> brokerageList = [Select BR_Broker__c from Brokerage_Broker__c where BR_ASCS_Broker_Code__c =: AgencyCode];
            if(brokerageList.size() > 0){
                for(Brokerage_Broker__c brokerage : brokerageList){
                    broker = brokerage.BR_Broker__c;
                }
            }
            if(broker != null){
              sSearchParam += 'Id = \'' + broker + '\'';
            }else{
                agencyCodeStatus = true;
            }
        }
        else if(BrokerName.length() > 0){
            sSearchParam += 'Name LIKE \'' + BrokerName + '%\'' + sBrokerSearch ;
        }
        else if(AgencyName.length() > 0){
            sSearchParam += 'Name LIKE \'' + AgencyName + '%\'' + sAgencySearch;
        }
        if(''.equals(sIdValue) || sIdValue == null){
            return(sSearchParam);      
        }
        else{
            sSearchParam += '(';
            sSearchParam += 'BR_Tax_Identification_Number__c = \'' + sIdValue+ '\' OR ';
            sSearchParam += 'BR_Encrypted_TIN__c = \'' + sIdValue+ '\' OR ';
            sSearchParam += '(BR_National_Producer_Number__c = \'' + sIdValue+ '\'' + sBrokerSearch + ') ';
            sSearchParam += ')';
            return(sSearchParam); 
        }    
    }
    public void ClearFields()
    {
       AgencyTIN = '';
       AgencyCode = '';
       AgencyName = '';
       AgencyETIN = '';
       BrokerTIN = '';
       BrokerETIN = '';
       BrokerNPN = '';
       BrokerName = '';
       showCheckboxandBtn = false;
       wrapAccountList = null;
       errorMsg = null;
       agencyCodeStatus = false;
    }
    
    public PageReference createSelectedData() {
                
        for(wrapAccount wrapAccountObj : wrapAccountList) {
            if(wrapAccountObj.selected == true) {
                
                string sEncryptedTin = wrapAccountObj.acc.BR_Encrypted_TIN__c;
                if(sEncryptedTin != null){
                //Account account = null;
                List<Account> accountlist = new List<Account>();
                string sSearchParam = 'Select Id, Name, BR_Tax_Identification_Number__c, BR_Encrypted_TIN__c,RecordType.Name from Account where BR_Encrypted_TIN__c = \'' + sEncryptedTin + '\'';
                accountlist = Database.query(sSearchParam);
               //if(account != null)
                if(accountlist.size() > 0)
                {
                    PageReference acctPage = null;
                    for(Account acc: accountlist){
                    acctPage = new ApexPages.StandardController(acc).view();
                    acctPage.setRedirect(true);
                    }
                    return acctPage;             
                }
                }
            }
        }
        Account acc1 = new Account();
        License_Appointment__c LAInfo;
        Certification__c certficationInfo;
        Brokerage_Broker__c relationshipInfo;
        
        List<License_Appointment__c> licenseInfoList;
        List<Certification__c> certificationInfoList;
        List<Brokerage_Broker__c> relationInfoList;
        List<RecordType> recList = null; 
        
        for(wrapAccount wrapAccountObj : wrapAccountList) {
            if(wrapAccountObj.selected == true) {
                if(brokerData.brokerType != null && !'Agency'.equals(brokerData.brokerType)){
                    if(wrapAccountObj.acc.LastName != null)
                        acc1.LastName = wrapAccountObj.acc.LastName.substringAfter('A[').substringBefore(']');
                    if(wrapAccountObj.acc.PersonEmail != null)
                        acc1.PersonEmail = wrapAccountObj.acc.PersonEmail.substringAfter('A[').substringBefore(']');
                    acc1.FirstName = wrapAccountObj.acc.FirstName;
                }else{
                    acc1.Name = wrapAccountObj.acc.Name;
                }
                if(wrapAccountObj.acc.Work_Phone__c != null)
                    acc1.Work_Phone__c = wrapAccountObj.acc.Work_Phone__c.substringAfter('A[').substringBefore(']');
                if(wrapAccountObj.acc.Billing_City__c != null)
                    acc1.Billing_City__c = wrapAccountObj.acc.Billing_City__c.substringAfter('A[').substringBefore(']');  
                if(wrapAccountObj.acc.Billing_Street__c != null)
                   acc1.Billing_Street__c = wrapAccountObj.acc.Billing_Street__c.substringAfter('A[').substringBefore(']'); 
                if(wrapAccountObj.acc.Billing_PostalCode__c != null)
                    acc1.Billing_PostalCode__c = wrapAccountObj.acc.Billing_PostalCode__c.substringAfter('A[').substringBefore(']');
                acc1.BR_Encrypted_TIN__c = wrapAccountObj.acc.BR_Encrypted_TIN__c;
                acc1.BR_National_Producer_Number__c = wrapAccountObj.acc.BR_National_Producer_Number__c;
                acc1.BR_Tax_Identification_Number__c = wrapAccountObj.acc.BR_Tax_Identification_Number__c;
                acc1.Billing_State__c  = wrapAccountObj.acc.Billing_State__c;
                acc1.BillingCountry  = wrapAccountObj.acc.BillingCountry;
            }else{
                pagereference p = apexpages.Currentpage();
                apexpages.Message msg = new Apexpages.Message(ApexPages.severity.WARNING,'Please select checkbox');
                apexpages.addmessage(msg);
                return p;
            }
        }
        Savepoint sp = null;
        try{
            if(acc1.FirstName == null){
                recList  = [SELECT id, Name FROM RECORDTYPE WHERE Name = 'Agency' AND sObjectType = 'Account'];
            }else{
                recList  = [SELECT id, Name FROM RECORDTYPE WHERE Name = 'Broker' AND sObjectType = 'Account'];
            }
            if(brokerData.brokerType != null && !'Agency'.equals(brokerData.brokerType))
                acc1.BR_External_Id__c = acc1.BR_Encrypted_TIN__c + '_' + 'P';
            else
                acc1.BR_External_Id__c = acc1.BR_Encrypted_TIN__c + '_' + 'C';
            acc1.RecordTypeId = recList[0].Id;
            sp = Database.setSavepoint();
            insert acc1; 
            
            if(acc1.Id != null)
            {   
                //License Information - KVM - External IDs should be blank for child records. Will be populated by batch
                if(brokerData.lAList != null){
                    licenseInfoList = new List<License_Appointment__c>();
                    LAInfo = new License_Appointment__c();
                    for(License_Appointment__c LA : brokerData.lAList){
                        LAInfo = LA;
                        if('Agency'.equals(brokerData.brokerType)){
                            LAInfo.BR_Agency__c = acc1.Id;
                            //LAInfo.BR_External_Id__c = acc1.BR_Encrypted_TIN__c + '_' + 'C';
                        }else{
                            LAInfo.BR_Broker__c = acc1.Id;
                            //LAInfo.BR_External_Id__c = acc1.BR_Encrypted_TIN__c + '_' + 'P';
                        }
                        licenseInfoList.add(LAInfo);
                    }
                insert licenseInfoList;
                    
             }
                //Certification Information
                if(brokerData.certiList != null){
                    certificationInfoList = new List<Certification__c>();
                    certficationInfo = new Certification__c();
                    for(Certification__c certInfo : brokerData.certiList){
                        certficationInfo = certInfo;
                        if('Agency'.equals(brokerData.brokerType)){
                            certficationInfo.BR_Agency__c = acc1.Id;
                            //certficationInfo.BR_External_Id__c = acc1.BR_Encrypted_TIN__c + '_' + 'C';
                        }else{
                            certficationInfo.BR_Broker__c = acc1.Id;
                            //certficationInfo.BR_External_Id__c = acc1.BR_Encrypted_TIN__c + '_' + 'P';
                        }
                        certificationInfoList.add(certficationInfo);
                    }
                insert certificationInfoList;
                   
                }
                //Contracts Information
                if(brokerData.conList != null){
                    licenseInfoList = new List<License_Appointment__c>();
                    LAInfo = new License_Appointment__c();
                    for(License_Appointment__c contractsInfo : brokerData.conList){
                        LAInfo = contractsInfo;
                        if('Agency'.equals(brokerData.brokerType)){
                            LAInfo.BR_Agency__c = acc1.Id;
                            //LAInfo.BR_External_Id__c = acc1.BR_Encrypted_TIN__c + '_' + 'C';
                        }else{
                            LAInfo.BR_Broker__c = acc1.Id;
                            //LAInfo.BR_External_Id__c = acc1.BR_Encrypted_TIN__c + '_' + 'P';
                        }
                        licenseInfoList.add(LAInfo);
                        
                    }
                insert licenseInfoList;
                   
                }
                //Brokerage/Broker Information
                if(brokerData.relationList != null){
                    relationInfoList = new List<Brokerage_Broker__c>();
                    relationshipInfo = new Brokerage_Broker__c();
                    for(Brokerage_Broker__c brokerageInfo : brokerData.relationList){
                        relationshipInfo = brokerageInfo;
                        if('Agency'.equals(brokerData.brokerType)){
                            relationshipInfo.BR_Agency__c = acc1.Id;
                            //relationshipInfo.BR_External_Id__c = acc1.BR_Encrypted_TIN__c + '_' + 'C';
                        }else{
                            relationshipInfo.BR_Broker__c = acc1.Id;
                            //relationshipInfo.BR_External_Id__c = acc1.BR_Encrypted_TIN__c + '_' + 'P';
                        }
                        relationInfoList.add(relationshipInfo);
                    }
                if(relationshipInfo.BR_Agency__c != null && relationshipInfo.BR_Broker__c != null)
                insert relationInfoList;
                }
                            
                PageReference acctPage = new ApexPages.StandardController(acc1).view();
                acctPage.setRedirect(true);
                return acctPage; 
            }
        }catch(Exception e){
            errorMsg = 'Data Insertion Issue. Please check with Administrator.';
            System.debug('Exception in createSelectedData():::::'+e);
            Database.rollback(sp);
        }
    return null;
    }
}