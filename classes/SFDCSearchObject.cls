/****************************************************
* Class Name : SFDCSearchObject
* Created date : 08-SEP-2015
* Created by : Pointel
  Updateddate: 31-OCT-2015
* Purpose : To find and query salesforce object.
  Update Notes: Updated class to search all given format
****************************************************/
public class SFDCSearchObject{
    public string Search(String SFsearchkey,String SearchCondition,String format,String Pagename) {
        try{
            List<List<SObject>> result;
            string temp='';
            if( Pagename!=null &&String.isNotEmpty(Pagename) && String.isNotBlank(Pagename) && SFsearchkey!=null&&String.isNotEmpty(SFsearchkey) && String.isNotBlank(SFsearchkey) )
            {
                string skey='';
                string querystring='';
                String JSONString ='';
                LIST<string> searchkey= SFsearchKey.split(',');
                LIST<string> phformate=new List<string>();
                system.debug('Page Names '+Pagename);
                system.debug('Search Format '+format);
                system.debug('Search Value'+SFsearchkey);
                if(SFsearchkey.isNumeric() && SFsearchkey.length()==8 &&(Pagename.contains('Account')||Pagename.contains('account')))
                {
                    system.debug('Account household search with '+SFsearchkey);
                    querystring='SELECT ID FROM ACCOUNT WHERE Household_ID__c= \''+SFsearchkey+'\'';
                    system.debug('Query = '+querystring);
                    List<Account> accountResult=Database.query(querystring);
                    JSONString = JSON.serialize(accountResult); 
                    
                  JSONString=(JSONString=='[]') ?'[[]]':'['+JSONString+']';                        
                    
                    system.debug('Result = '+JSONString);
                    return JSONString; 
                }
                if(format!=null  &&String.isNotEmpty(format) && String.isNotBlank(format))
                {
                    phformate=format.split(',');
                }
                if(phformate.size()>0)
                {
                    system.debug('Query= FIND \''+SFsearchKey.replaceAll(',',' '+SearchCondition+' ' ) +'\' IN ALL FIELDS RETURNING '+Pagename);
                    querystring='FIND \''+SFsearchKey.replaceAll(',',' '+SearchCondition+' ' ) +'\' IN ALL FIELDS RETURNING '+Pagename;
                    result=search.query(querystring);
                    JSONString = JSON.serialize(result); 
                    system.debug('result= '+JSONString);
                    return (JSONString.contains('Id'))?JSONString:GetFormatProcess(searchkey,phformate,SearchCondition,Pagename);
                }else
                    if(SearchCondition!=null&&String.isNotEmpty(SearchCondition) && String.isNotBlank(SearchCondition))
                {
                    querystring='FIND \''+SFsearchKey.replaceAll(',',' '+SearchCondition+' ' ) +'\' IN ALL FIELDS RETURNING '+Pagename;
                    system.debug('Query =FIND \''+SFsearchKey.replaceAll(',',' '+SearchCondition+' ' ) +'\' IN ALL FIELDS RETURNING '+Pagename );
                    result=search.query(querystring);
                    JSONString = JSON.serialize(result); 
                    system.debug('result= '+JSONString);
                    return JSONString;    
                }else
                {
                    querystring='FIND \''+SFsearchKey+'\' IN ALL FIELDS RETURNING '+Pagename;
                    system.debug('Query = FIND \''+SFsearchKey+'\' IN ALL FIELDS RETURNING '+Pagename);
                    result=search.query(querystring);
                    JSONString = JSON.serialize(result); 
                    system.debug('result= '+JSONString);
                    return JSONString;   
                }
            }
            return '[[]]';
        } 
        catch(Exception e)
        {
            System.debug('SFDCSearchObject Error'+e.getStackTraceString());
            return '[[]]';
        }
    }
    public string Phoneformate(string digits, string inputformat)
    {
        system.debug('input format ='+inputformat );
        List<string> format=inputformat.split('');
        //format.remove(0);
        string finalValue = '';
        Integer lastIntIndex = 0;
        Integer incrementValue = 0;
        boolean IsIncrementValue = true;
        string splChar='';
        system.debug('digits ='+digits +' formate size = '+format.size()+' ');
        for (Integer j = 0; j <= format.size() - 1; )
        {
            
            if (format[j]!='x')
            {
                finalValue += digits.Substring(lastIntIndex, incrementValue);
                splChar=format[j];
                finalValue += format[j];
                lastIntIndex = incrementValue;
                IsIncrementValue = false;
            }
            j++;
            if (IsIncrementValue)
                incrementValue++;
            else
                IsIncrementValue =!IsIncrementValue;
            
        }
        finalValue += digits.Substring(lastIntIndex , incrementValue<=digits.length()?incrementValue:digits.length());
        if((finalvalue.Substring(finalvalue.length()-1,finalvalue.length()))==splChar)
        {
            finalvalue=finalvalue.Substring(0,finalvalue.length()-1);
        }
        system.debug('finalvalue - '+finalvalue);
        return finalvalue;
    }    
    public string GetFormatProcess(LIST<string> searchkey,LIST<string> phformate,string SearchCondition,string Pagename)
    {
        string querystring='';
        string JSONString ='[[]]';
        string returndata ='[[]]';
        boolean flag=false;
        List<List<SObject>> result;        
        for(integer j=0;j<phformate.size();j++)
        {
            string skey='';
            for(integer i=0;i<searchkey.size();i++)
            {
                string temp=searchkey[i];
                if(temp.isNumeric() && temp.length()==10)
                {
                    temp=Phoneformate(searchkey[i],phformate[j]);
                }
                if(SearchCondition!=null && String.isNotEmpty(SearchCondition) && String.isNotBlank(SearchCondition))
                {
                    skey+=temp+',';
                }else{
                    skey+=temp;  
                }
            }
            if(!skey.equals(''))
            {
                if((skey.Substring(skey.length()-1,skey.length()))==',')
                {
                    skey=skey.Substring(0,skey.length()-1);
                }
                querystring='FIND \''+skey.replaceAll(',',' '+SearchCondition+' ' )+'\' IN ALL FIELDS RETURNING '+Pagename;
                system.debug('Query= FIND \''+skey.replaceAll(',',' '+SearchCondition+' ' )+'\' IN ALL FIELDS RETURNING '+Pagename);
                result=search.query(querystring);
                JSONString = JSON.serialize(result); 
                system.debug('result= '+JSONString);
                flag=(JSONString.contains('Id'))?true:(phformate.size()-1==j)?true:false; 
                if(flag)
                {
                    returndata= JSONString;
                    break;
                }
            }
        }
        return returndata;
    }  
}