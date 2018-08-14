/****************************************************
* Class Name : SFDCCustomObject
* Created date : AUG-12-2015
* Created by : Pointel Inc.,
* Purpose : To insert and update salesforce custom object and activity history for it.
****************************************************/

public class SFDCCustomObject {
    
    public string createRecord(string details)
    {
        if(details!=null&&String.isNotEmpty(details) && String.isNotBlank(details))
        {
            List<string> splitByCap=details.split('\\^');
            Call_Info__c customleadObj = new Call_Info__c();
            for(Integer i=0;i<splitByCap.size();i++)
            {
                string temp=splitByCap[i];
                List<string> splitByEquals=temp.split('\\=');
                if(splitByEquals.size()==2 && string.isNotBlank(splitByEquals[0]) && string.isNotEmpty(splitByEquals[0]) && string.isNotBlank(splitByEquals[1])&& string.isNotEmpty(splitByEquals[1]))
                {
                    try
                    {
                        Pattern p = Pattern.compile('(\\d{4})-(\\d{2})-(\\d{2}) (\\d{2}):(\\d{2}):(\\d{2})');
                        Matcher pm = p.matcher(splitByEquals[1]);
                        Pattern p1 = Pattern.compile('(\\d{4})-(\\d{2})-(\\d{2})');
                        Matcher pm1 = p1.matcher(splitByEquals[1]);
                        if(pm.matches())
                        {
                            customleadObj.put(splitByEquals[0], Datetime.valueOf(splitByEquals[1]));
                        }if(pm1.matches())
                        {
                            customleadObj.put(splitByEquals[0], date.valueOf(splitByEquals[1]));
                        }else{
                            customleadObj.put(splitByEquals[0],splitByEquals[1]);
                        }
                    }catch(Exception e)
                    {
                        system.debug('data'+splitByEquals[0]+'='+splitByEquals[1]);
                        system.debug(' Error- '+e);
                    }
                }
            }
            String s = JSON.serialize(customleadObj);
            Map<String,Object> obj = (Map<String,Object>) JSON.deserializeUntyped(s);
            Set<String> fieldsPresent = obj.keyset().clone();
            fieldsPresent.remove('attributes');
            if(!fieldsPresent.isEmpty())
            {
                insert customleadObj;    
                return customleadObj.Id;
            }
        }
        return 'error';
    }
    
    public string updateRecord(string details,string id)
    {
        if(details!=null&&String.isNotEmpty(details) && String.isNotBlank(details))
        {
            if(id!=null && string.isNotBlank(id) &&string.isNotEmpty(id))
            {
                List<string> splitByCap=details.split('\\^');
                Call_Info__c customleadObj = new Call_Info__c();
                for(Integer i=0;i<splitByCap.size();i++)
                {
                    string temp=splitByCap[i];
                    List<string> splitByEquals=temp.split('\\=');
                    if(splitByEquals.size()==2 && string.isNotBlank(splitByEquals[0]) && string.isNotEmpty(splitByEquals[0]) && string.isNotBlank(splitByEquals[1])&& string.isNotEmpty(splitByEquals[1]))
                    {
                        try
                        {
                            Pattern p = Pattern.compile('(\\d{4})-(\\d{2})-(\\d{2}) (\\d{2}):(\\d{2}):(\\d{2})');
                            Matcher pm = p.matcher(splitByEquals[1]);  
                            Pattern p1 = Pattern.compile('(\\d{4})-(\\d{2})-(\\d{2})');
                            Matcher pm1 = p1.matcher(splitByEquals[1]);
                            
                            if(pm.matches())
                            {
                                customleadObj.put(splitByEquals[0], Datetime.valueOf(splitByEquals[1]));
                            }if(pm1.matches())
                            { 
                                customleadObj.put(splitByEquals[0], date.valueOf(splitByEquals[1]));
                            }else{
                                customleadObj.put(splitByEquals[0],splitByEquals[1]);
                            }
                        }catch(Exception e)
                        {
                            system.debug(splitByEquals[0]+'='+splitByEquals[1]);
                            System.debug('Error in update -'+e);
                        }
                    }
                }
                String s = JSON.serialize(customleadObj);
                Map<String,Object> obj = (Map<String,Object>) JSON.deserializeUntyped(s);
                Set<String> fieldsPresent = obj.keyset().clone();
                fieldsPresent.remove('attributes');
                if(!fieldsPresent.isEmpty())
                {
                    customleadObj.Id=id;
                    update customleadObj;    
                    return customleadObj.Id;
                }
            }
        }
        return 'error';
    }
}