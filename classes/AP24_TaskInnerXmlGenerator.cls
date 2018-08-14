/*************************************************************
Class Name   : AP24_TaskInnerXmlGenerator  
Date Created : 26-Oct-2015
Created By   : Kishore
Description  : This class is used to generate payload xml ( inner xml) file
*****************************************************************/
public class AP24_TaskInnerXmlGenerator {
    DOM.Xmlnode root = null;
    public String generateXmlRequest(Task tk,User usr,sObject acc,Licensing__c license){
    String method = 'taskXmlRequest';
    String cdataString = '';
    DOM.Document doc = new DOM.Document();
        try{
            root = doc.createRootElement('Payload', null, null);
            List<CS004_TaskXmlGenerator__c> serviceFields = [
                    SELECT Name, Request_Name__c, Default_Value__c,Sequence__c, Namespace_Prefix__c, Parent_Node__c, Type__c, XmlLabel__c, Source_Object__c, Field_Name__c
                    FROM CS004_TaskXmlGenerator__c 
                    WHERE Request_Name__c = :method
                    ORDER BY Sequence__c];
            appendSObjectToXml(tk,usr,acc,license,serviceFields);
            String str1 = '<![CDATA[';
            String str2 = ']]>';
            cdataString = str1 + doc.toXmlString() + str2;
        }catch(Exception e){
            System.debug('Exception in AP24_TaskInnerXmlGenerator::::'+e.getMessage());
        }
    return cdataString;
    }
    /*  
    Method name : appendSObjectToXml
    Param 1     : task object,account object,licensing object,CS004_CustomsettingData as object
    Return Type : Void
    Description : This method is used to construct inner xml file.
    */
    private void appendSObjectToXml(Task tk,User usr,sObject acc,Licensing__c license,List<CS004_TaskXmlGenerator__c> serviceFields){
        Map<string, dom.xmlnode> xmlnodemap = new Map<string, dom.xmlnode>();
         for(CS004_TaskXmlGenerator__c field : serviceFields){
             if(field.Type__c == 'XmlNode'){
                if(field.Parent_Node__c == 'root'){
                    Dom.XmlNode rootNode = root.addChildElement(field.XmlLabel__c, null, null);
                    xmlnodemap.put(field.XmlLabel__c, rootNode);
                }else{
                    xmlnodemap.put(field.XmlLabel__c, 
                                   xmlnodemap.get(field.parent_Node__c).addChildElement(field.XmlLabel__c, null, null));
                }
             }else if(field.Type__c == 'Field'){
                String innerText = '';
                //get the required field 
                sObject anAccount = tk;
                sObject uObject = usr;
                sObject accObject = acc;
                sObject licenseObject = license;
                Object value = null;
                if(field.Field_Name__c != null ){
                    System.debug('inside if  not lead or account');
                    if(field.Source_Object__c.equalsIgnoreCase('Task')){
                        value = anAccount.get(field.Field_Name__c);
                    }else if(field.Source_Object__c.equalsIgnoreCase('User')){
                        value = uObject.get(field.Field_Name__c);
                    }else if(field.Source_Object__c.equalsIgnoreCase('Licensing__c')){
                        value = licenseObject.get(field.Field_Name__c);
                    }else if(field.Source_Object__c.equalsIgnoreCase('LeadANDAccount')){                    
                        if(field.Field_Name__c.equalsIgnoreCase('Email') && string.valueOf(anAccount.get('whatId'))!=null && 
                        String.valueOf(anAccount.get('Email_Address__c')).equalsIgnoreCase('Primary Email')){
                            value = accObject.get('Primary_Email__c');
                        }else if(field.Field_Name__c.equalsIgnoreCase('Email') && string.valueOf(anAccount.get('whatId'))!=null && 
                        String.valueOf(anAccount.get('Email_Address__c')).equalsIgnoreCase('Secondary Email')){
                            value = String.valueOf(accObject.get('Secondary_Email__c'));
                        }else if(field.Field_Name__c.equalsIgnoreCase('Email') && string.valueOf(anAccount.get('whoId'))!=null){
                            value = accObject.get('Email__c');
                        }else if(field.Field_Name__c.equalsIgnoreCase('LHName')){
                             if(tk.whatId!=Null){
                                value = accObject.get('household_id__c');
                             }else{
                                 value = accObject.get('lead_id__c');
                             }
                        }else if(!field.Field_Name__c.equalsIgnoreCase('Email') && !field.Field_Name__c.equalsIgnoreCase('LHName')){
                            value = accObject.get(field.Field_Name__c);
                        }
                    }
                }else if(field.Default_Value__c != NULL){
                    value = field.Default_Value__c;
                }
                if(value != null){
                        innerText = String.valueOf(value);
                    }
                 DOM.XmlNode xmlField = null;
                 xmlField = xmlnodemap.get(field.parent_Node__c).addChildElement(field.xmlLabel__c, null, null); 
                 xmlField.addTextNode(innerText);
             }
         }
     }
}