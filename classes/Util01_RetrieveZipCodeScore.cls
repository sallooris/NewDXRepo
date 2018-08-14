/**********************************************************************
Class Name   : Util01_RetrieveZipCodeScore
Date Created : 04-May-2015
Created By   : Nagarjuna
Description  : This is a helper class to auto populate customer score.
Referenced/Used in : LeadBeforeUpdate Trigger. 
**********************************************************************/
Public with sharing Class Util01_RetrieveZipCodeScore
{   
    Public Static boolean isFirstRunAccInsert= true;
    Public Static boolean isFirstRunAccUpdate= true;
    Public Static boolean isFirstRunLeadInsert= true;
    Public Static boolean isFirstRunLeadUpdate= true;
    Public boolean isFindOne= False;
    Private Set<String> zipCodeVal =null ;
    Private Map<String,Decimal> customerScoreZipCodeMap = null;
    Private Map<String,List<Zip_DOB_Score__c>> zipCodewithScores = New Map<String,List<Zip_DOB_Score__c>>();
    
    /*
    Param 1 : Object List
    Param 2 : Zipcode
    Param 3 : Date of Birth
    Param 4 : Customer Score
    Return Type: Void
    Description : Used to populate the customer score field based on date of birth and zipe code  
    */
    Public Void customerScoreAutoPopulate(List<SObject> sObjList, String zipCode, String dob, String custScore)
    {
        try
        {
            System.Debug('#### CustomerScoreAutoPopulate Started ####');
            zipCodeVal = new Set<String>(); 
            System.Debug('ZipCode is: '+ zipCode);
            for(sObject obj : sObjList)
            { 
                if(String.ValueOf(Obj.get(zipCode)) != null && String.ValueOf(Obj.get(zipCode)) != '')
                {
                    zipCodeVal.add(String.ValueOf(Obj.get(zipCode)));
                    
                }
            }
            System.Debug('ZipCode val is: '+zipCodeVal);
            customerScoreZipCodeMap = new Map<String,Decimal>();
            
            List<Zip_DOB_Score__c> custScoreList = [SELECT 
                                                                Zip_Code__c, 
                                                                Score__c,
                                                                Start_Date__c,
                                                                End_Date__c
                                                        FROM    Zip_DOB_Score__c
                                                        WHERE   Zip_Code__c
                                                        IN      :zipCodeVal
                                                        ];
            System.Debug('custScoreList  is: '+custScoreList );
     
            if(custScoreList != null)
            {
                for(Zip_DOB_Score__c rec : custScoreList){
                    if(zipCodewithScores.containsKey(rec.Zip_Code__c)){
                        List<Zip_DOB_Score__c> existRecs = New List<Zip_DOB_Score__c>();
                        existRecs =  zipCodewithScores.get(rec.Zip_Code__c);
                        existRecs.add(rec);
                        zipCodewithScores.put(rec.Zip_Code__c,existRecs);  
                    }
                    else{
                        List<Zip_DOB_Score__c> existRecs = New List<Zip_DOB_Score__c>();
                        existRecs.add(rec);
                        zipCodewithScores.put(rec.Zip_Code__c,existRecs); 
                    }
                    
                }
            }
            System.Debug('Before lead update');
            for(sObject custObj: sObjList)
            {
                if(zipCodewithScores.containsKey(String.ValueOf(custObj.get(zipCode))))
                {
                   List<Zip_DOB_Score__c> matchList= new List<Zip_DOB_Score__c>();
                   
                   matchList = zipCodewithScores.get(String.ValueOf(custObj.get(zipCode)));
                   isFindOne = False;
                   for(Zip_DOB_Score__c newList: matchList)
                   {
                   System.Debug('dob is: '+ Date.valueOf(custObj.get(dob)));
                   System.Debug('start date is: '+Date.valueOf(newList.Start_Date__c));
                   System.Debug('end date is: '+Date.valueOf(newList.End_Date__c));
                       if(Date.valueOf(custObj.get(dob)) >= Date.valueOf(newList.Start_Date__c) && Date.valueOf(custObj.get(dob)) <= Date.valueOf(newList.End_Date__c))
                       {
                           System.Debug('dob inside is: '+Date.valueOf(custObj.get(dob)));
                           custObj.put(custScore, String.ValueOf(newList.Score__c));
                           custObj.put('Customer_Score_Source__c','Marketing');
                           isFindOne = True;
                       }                   
                       
                      if(isFindOne == False) {
                       custObj.put(custScore, '');
                       custObj.put('Customer_Score_Source__c','');
                        
                       } 
                       
                   }
    
                }
                else if(custObj.get(zipCode)!=null && custObj.get(zipCode)!='')
                {
                   custObj.put(custScore,'');
                   //custObj.put('Customer_Score_Source__c','');
                }
            }
            System.Debug('#### CustomerScoreAutoPopulate Ended ####');
        }
        catch(Exception e){
            throw e;
        }
     }
}