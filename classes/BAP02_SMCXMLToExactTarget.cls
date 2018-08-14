/**********************************************************************
Class Name   : BAP02_SMCXMLToExactTarget 
Date Created : 27-Oct-2015
Created By   : Bhaskar
Description  : Used to extract the SMC XML file from XML Generator object and send it to Exact Target
Referenced/Used in : Used to in batch apex
**********************************************************************/
global with sharing class BAP02_SMCXMLToExactTarget implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.stateful
{
global String str_SOQL = 'SELECT Id, XML_Content__c,Tech_Task_Reference__c,isSuccessORFailure__c FROM XML_Generator__c where isXMLExtracted__c = FALSE';
global List<XML_Generator__c> updateXML = new List<XML_Generator__c>();   
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(str_SOQL);
    }
   
    global void execute(Database.BatchableContext BC, List<XML_Generator__c> scope)
    {
        AP25_ExactTargetController exactTargetObj = new AP25_ExactTargetController();
            for(XML_Generator__c xg : scope){
                System.debug('inside for loop:::::::::::::');
               String status =  exactTargetObj.retrieveExactTragetData(xg);
               if(status.equalsIgnoreCase('OK')){
                   xg.isXMLExtracted__c=true;  
                   xg.isSuccessORFailure__c=status;             
                   updateXML.add(xg);
               }else{
                   xg.isXMLExtracted__c=false;  
                   xg.isSuccessORFailure__c=status;             
                   updateXML.add(xg);
               }
            } 
    }   
    global void finish(Database.BatchableContext BC){
            if(!updateXML.isEmpty()){
               update updateXML;
            }
    }
}