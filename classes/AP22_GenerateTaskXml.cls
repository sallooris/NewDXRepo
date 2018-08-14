/*************************************************************
Class Name   : AP22_GenerateTaskXml
Date Created : 27-Oct-2015
Created By   : Bhaskar
Description  : This class is used to call from the task triggers when send fulfillment task is created
*****************************************************************/
public class AP22_GenerateTaskXml{
    public static boolean isXmlGeneratorAfterInsert = true;
    public static boolean isXmlGeneratorAfterUpdate = true;
    public static boolean isXmlGeneratorAfterDelete = true;
    public static boolean isSMCXmlGeneratorAfterInsert = true;
    public static boolean isSMCXmlGeneratorAfterUpdate = true;
    /*  
    Method name : insertXmlFields
    Param 1     : Task object,Id of the current user,trigger context value
    Return Type : Void
    Description : This method is used to insert the SMC xml related field values in XML_Generator__c object which are used
                  construct the final XML file.
    */
    public void insertXmlFields(Task t,String uId,String contextValue){
        try{
            if(contextValue.equalsIgnoreCase('insert') || contextValue.equalsIgnoreCase('update')){
                XML_Generator__c[] xmlGeneratedTask = [select ID,isXMLExtracted__c from XML_Generator__c where Tech_Task_Reference__c =:t.id ];
                Task tsk = [SELECT WhatId,WhoId,Email_Address__c,Kit_ID__c,ID,Brand__c,Created_Date__c,Language__c,Residence_State__c FROM TASK WHERE ID=:t.ID];
                User usr = [SELECT ID,Type_of_Employer__c,Department,MobilePhone,Tax_ID__c,FirstName,LastName,LicenseNumber__c,
                                      Phone,NPN__c,Email,Hours_of_Operation__c,
                                      Parent_TIN__c,Fax,Street,City,State,PostalCode FROM USER WHERE ID=:uId] ;
                Account a = [select ID,FirstName,Name,Primary_Email__c,Secondary_Email__c,Household_ID__c from Account where id =:t.whatId];
                Licensing__c[] licensing = [select ID,Microsite_URL__c,Anthem_Producer_Number__c from Licensing__c 
                                        where ownerId=:usr.Id and state__c=:tsk.Residence_State__c LIMIT 1];
                Licensing__c[] licensing2 = [select ID,License_Number__c from Licensing__c 
                                        where NPN__c=:usr.NPN__c and state__c=:tsk.Residence_State__c LIMIT 1]; 
                Licensing__c license = new Licensing__c();
                if (licensing.size() > 0 ){
                    license.Microsite_URL__c = licensing[0].Microsite_URL__c;
                    license.Anthem_Producer_Number__c = licensing[0].Anthem_Producer_Number__c;
                }
                if(licensing2.size() > 0){
                    license.License_Number__c = licensing2[0].License_Number__c;
                }
                AP24_TaskInnerXmlGenerator txg = new AP24_TaskInnerXmlGenerator();
                String innerXml = txg.generateXmlRequest(tsk,usr,a,license);
                String personAccountEmailId = null;
                XML_Generator__c xmlGenerator = new XML_Generator__c();
                xmlGenerator.Tech_Task_Reference__c = t.id;
                xmlGenerator.Tech_Postcard_Info__c = innerXml;
                xmlGenerator.Tech_Brand__c = t.SMC_Brand__c;
                xmlGenerator.Tech_KitID__c= t.kit_Id__c;
                xmlGenerator.Tech_LanguageCode__c  = t.SMC_Language__c;
                xmlGenerator.Tech_PlanState__c = t.residence_state__c;
                xmlGenerator.Tech_CustomerKey__c = t.SMC_Customer_Key__c;
                if(t.Email_Address__c != NULL && t.Email_Address__c!= ''){
                    if(t.Email_Address__c.equalsIgnoreCase('Primary Email')){
                        personAccountEmailId = a.Primary_Email__c;
                    }else if(t.Email_Address__c.equalsIgnoreCase('Secondary Email')){
                        personAccountEmailId = a.Secondary_Email__c;
                    }
                }
                xmlGenerator.Tech_EmailAddress__c = personAccountEmailId;
                xmlGenerator.Tech_SubscriberKey__c = personAccountEmailId;
                xmlGenerator.Tech_PostcardFromName__c = usr.FirstName+' '+usr.LastName;
              // xmlGenerator.Tech_PostcardFromName__c = 'Gagan Rastogi';
                xmlGenerator.Tech_PostcardFromEmailAddress__c = usr.Email;
               //xmlGenerator.Tech_PostcardFromEmailAddress__c = 'gaganrastogi@hotmail.com';
                xmlGenerator.Tech_SalesforceID__c = a.Id;
                xmlGenerator.Tech_FulfillmentRequestId__c = t.Id;
                if(xmlGeneratedTask.size()>0){
                    if(xmlGeneratedTask[0].isXMLExtracted__c == true){
                        xmlGenerator.ID = xmlGeneratedTask[0].Id;
                        xmlGenerator.isXMLExtracted__c = false;
                    }else{
                        xmlGenerator.ID = xmlGeneratedTask[0].Id;
                    }
                   // update xmlGenerator;
                   generateSMCXMLFileUpdate(xmlGenerator);
                }else{
                    insert xmlGenerator;
                }
            }else if(contextValue.equalsIgnoreCase('Delete')){
                XML_Generator__c xmlGeneratedTaskDelete = [select ID from XML_Generator__c where Tech_Task_Reference__c =:t.id ];
                delete xmlGeneratedTaskDelete;
            }
        }catch(Exception e){
            System.debug('Exception in AP22_GenerateTaskXml:::'+e.getMessage());
        }
    }
    /*  
    Method name : insertLeadXmlFields
    Param 1     : Task object,Id of the current user,trigger context value
    Return Type : Void
    Description : This method is used to insert the SMC xml related field values in XML_Generator__c object which are used
                  construct the final XML file.
    */
    public void insertLeadXmlFields(Task t,String uId,String contextValue){
        try{
            if(contextValue.equalsIgnoreCase('insert') || contextValue.equalsIgnoreCase('update')){
                XML_Generator__c[] xmlGeneratedTask = [select ID,isXMLExtracted__c from XML_Generator__c where Tech_Task_Reference__c =:t.id ];
                Task tsk = [SELECT WhoId,WhatId,Email_Address__c,Kit_ID__c,ID,Brand__c,Created_Date__c,Language__c,Residence_State__c FROM TASK WHERE ID=:t.ID];
                User usr = [SELECT ID,Type_of_Employer__c,Department,MobilePhone,Tax_ID__c,FirstName,LastName,LicenseNumber__c,
                                      Phone,NPN__c,Email,Hours_of_Operation__c,
                                      Parent_TIN__c,Fax,Street,City,State,PostalCode FROM USER WHERE ID=:uId] ;
                Lead ld = [select ID,FirstName,Name,Email__c,Lead_ID__c from Lead where id =:t.whoId];
                Licensing__c[] licensing = [select ID,Microsite_URL__c,Anthem_Producer_Number__c from Licensing__c 
                                        where ownerId=:usr.Id and state__c=:tsk.Residence_State__c LIMIT 1];
                Licensing__c[] licensing2 = [select ID,License_Number__c from Licensing__c 
                                        where NPN__c=:usr.NPN__c and state__c=:tsk.Residence_State__c LIMIT 1]; 
                Licensing__c license = new Licensing__c();
                if (licensing.size() > 0 ){
                    license.Microsite_URL__c = licensing[0].Microsite_URL__c;
                    license.Anthem_Producer_Number__c = licensing[0].Anthem_Producer_Number__c;
                }
                if(licensing2.size() > 0){
                    license.License_Number__c = licensing2[0].License_Number__c;
                }
                AP24_TaskInnerXmlGenerator txg = new AP24_TaskInnerXmlGenerator();
                String innerXml = txg.generateXmlRequest(tsk,usr,ld,license);
                String leadEmailId = null;
                XML_Generator__c xmlGenerator = new XML_Generator__c();
                xmlGenerator.Tech_Task_Reference__c = t.id;
                xmlGenerator.Tech_Postcard_Info__c = innerXml;
                xmlGenerator.Tech_Brand__c = t.SMC_Brand__c;
                xmlGenerator.Tech_KitID__c= t.kit_Id__c;
                xmlGenerator.Tech_LanguageCode__c  = t.SMC_Language__c;
                xmlGenerator.Tech_PlanState__c = t.residence_state__c;
                xmlGenerator.Tech_CustomerKey__c = t.SMC_Customer_Key__c;
                leadEmailId = ld.Email__c;
                xmlGenerator.Tech_EmailAddress__c = leadEmailId;
                xmlGenerator.Tech_SubscriberKey__c = leadEmailId;
                xmlGenerator.Tech_PostcardFromName__c = usr.FirstName+' '+usr.LastName;
                xmlGenerator.Tech_PostcardFromEmailAddress__c = usr.Email;
                xmlGenerator.Tech_SalesforceID__c = ld.Id;
                xmlGenerator.Tech_FulfillmentRequestId__c = t.Id;
                if(xmlGeneratedTask.size()>0){
                    if(xmlGeneratedTask[0].isXMLExtracted__c == true){
                        xmlGenerator.ID = xmlGeneratedTask[0].Id;
                        xmlGenerator.isXMLExtracted__c = false;
                    }else{
                        xmlGenerator.ID = xmlGeneratedTask[0].Id;
                    }
                   // update xmlGenerator;
                   generateSMCXMLFileUpdate(xmlGenerator);
                }else{                    
                    insert xmlGenerator;
                }
            }else if(contextValue.equalsIgnoreCase('Delete')){
                XML_Generator__c xmlGeneratedTaskDelete = [select ID from XML_Generator__c where Tech_Task_Reference__c =:t.id ];
                delete xmlGeneratedTaskDelete;
            }
        }catch(Exception e){
            System.debug('Exception in AP22_GenerateTaskXml:::'+e.getMessage());
        }
    }
    /*  
    Method name : generateSMCXMLFileUpdate
    Param 1     : XML_Generator__c object
    Return Type : Void
    Description : This method is used to call when the task is getting updated
    */
    public void generateSMCXMLFileUpdate(XML_Generator__c xmlGenerator){
        AP23_GenerateSMCXML gsx = new AP23_GenerateSMCXML();
        String parentXML = (gsx.generateXmlRequest(xmlGenerator.id,xmlGenerator)).replace('&lt;', '<').replace('&gt;','>');
        xmlGenerator.XML_Content__c = parentXML;
        update xmlGenerator;
    }
    /*  
    Method name : generateSMCXMLFile
    Param 1     : XML_Generator__c ID
    Return Type : Void
    Description : This method is used to store final xml file and save it in XML_Generator__c object
    */
    public void generateSMCXMLFile(ID xmlId){
        AP23_GenerateSMCXML gsx = new AP23_GenerateSMCXML();
        try{
           String parentXML = (gsx.generateXmlRequest(xmlId,null)).replace('&lt;', '<').replace('&gt;','>');
            XML_Generator__c xmlGenerator = new XML_Generator__c();
            xmlGenerator.id = xmlId;
            xmlGenerator.XML_Content__c = parentXML;
            update xmlGenerator; 
        }catch(Exception e){
            System.debug('Exception in generateSMCXMLFile::::'+e.getMessage());
        }

    }
}