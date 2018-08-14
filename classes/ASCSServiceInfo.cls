/*************************************************************
Class Name   : ASCSServiceInfo
Date Created : 04-Sep-2015
Created By   : Kishore Jonnadula
Description  : This class consists setters and getters
*************************************************************/
public class ASCSServiceInfo {
    public List<Account> accList{get;set;}
	public List<License_Appointment__c> lAList {get; set;}
	public List<Certification__c> certiList {get; set;}
    public List<License_Appointment__c> conList {get; set;}
    public List<Brokerage_Broker__c> relationList {get; set;}
 // public List<Sales_Team__c> salesTeamList {get; set;}
    public String errorMsg {get; set;}
    public String brokerType {get; set;}
}