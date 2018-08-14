public with sharing class AssociateActivityToLeadAndAccount
{
    public static String currObjId;
    public static boolean isEntityFirstUpdate = true;
        
    public void AssociateActivity(String entity, String entityId)
    {
        try
        {
            System.Debug('#### Method:AssociateActivity Started ####');
            system.debug('currObjId = '+currObjId);
            String ANI = '';
            String homePh;
            String workPh;
            String mobilePh;
            String ANISearchStr = '';
            String queryStr = '';
            String entityState;
            String zip;
            boolean updMktInfo = false;
            String campRecTypeId = '';
            String leadStat = '';
            String useAntCamp = '';
                        
            Account acc;
            Lead ld;
            Task[] cTask;
            Task[] trfTask;
            String taskId;
            System.Debug('Entity = '+entity);
            System.Debug('EntityId = '+entityId);
            
                                
            //  Account Block
            if (entity == 'Account')    // check if owner needs to included in the query
            {
                acc = [SELECT Id, Inbound_Activity_Id__c, State__c, Zip_Code__c, Vendor_Customer_ID__c, Marketing_Event__c, Phone, Work_Phone__c, Mobile_Phone__c, RecordTypeId from Account where Id =:entityId];
                entityState = acc.State__c;
                zip = acc.Zip_Code__c;
                //  8/9 - AC39926 - retrieving the Record Type Id to be used in the campaign lookup
                campRecTypeId = acc.RecordTypeId;
                

 /*               if (acc.Phone != null)
                {
//                    homePh = acc.Phone.remove(' ').remove('(').remove(')').remove('-');
                    homePh = acc.Phone;                    
                    ANISearchStr = 'ANI__c = \''+homePh+ '\'';  
                }  
                
                if (acc.Work_Phone__c != null)
                {
//                    workPh = acc.Work_Phone__c.remove(' ').remove('(').remove(')').remove('-');
                    workPh = acc.Work_Phone__c;                    
                    if (ANISearchStr.length() > 0)
                        ANISearchStr = ANISearchStr + ' OR ANI__c = \''+workPh + '\'';
                    else
                        ANISearchStr = 'ANI__c = \''+workPh+ '\'';
                }
                system.debug('after work ph check');
                if (acc.Mobile_Phone__c != null)
                {
//                    mobilePh = acc.Mobile_Phone__c.remove(' ').remove('(').remove(')').remove('-');
                    mobilePh = acc.Mobile_Phone__c;                    
                    if (ANISearchStr.length() > 0)
                        ANISearchStr = ANISearchStr + ' OR ANI__c = \''+mobilePh + '\'';
                    else
                        ANISearchStr = 'ANI__c = \''+mobilePh+ '\'';
                } */
                if (acc.Inbound_Activity_Id__c != null)
                    taskId = acc.Inbound_Activity_Id__c;
            } 
            //  Lead Block
            else if (entity == 'Lead')  // check if owner needs to included in the query
            {
                ld = [SELECT Id, Inbound_Activity_Id__c, Status, Vendor_Customer_ID__c, Marketing_Event__c, State__c, Zip_Code__c, Phone, Work_Phone__c, Mobile_Phone__c, RecordTypeId from Lead where Id =:entityId];                
                entityState = ld.State__c;
                zip = ld.Zip_Code__c;
                system.debug('lead zip code = '+zip);
                leadStat = ld.Status;
                if (leadStat == 'Group Lead')
                    useAntCamp = 'Y';
                system.debug('lead status = '+leadStat);
                system.debug('useAntCamp = '+ useAntCamp);
                
                //  8/9 - AC39926 - retrieving the Record Type Id to be used in the campaign lookup
                campRecTypeId = ld.RecordTypeId;
                system.debug('lead campRecTypeId = '+campRecTypeId);
/*                if (ld.Phone !=NULL)
                {
//                    homePh = ld.Phone.remove(' ').remove('(').remove(')').remove('-');
                    homePh = ld.Phone;
                    ANISearchStr = 'ANI__c = \''+homePh+ '\'';
                } 
                if (ld.Work_Phone__c != NULL)
                {
//                    workPh = ld.Work_Phone__c.remove(' ').remove('(').remove(')').remove('-');
                    workPh = ld.Work_Phone__c;                    
                    if (ANISearchStr.length() > 0)
                        ANISearchStr = ANISearchStr + ' OR ANI__c = \''+workPh + '\'';
                    else
                        ANISearchStr = 'ANI__c = \''+workPh+ '\'';                    
                }
                if(ld.Mobile_Phone__c != NULL)
                {
//                    mobilePh = ld.Mobile_Phone__c.remove(' ').remove('(').remove(')').remove('-');
                    mobilePh = ld.Mobile_Phone__c;                    
                    if (ANISearchStr.length() > 0)
                        ANISearchStr = ANISearchStr + ' OR ANI__c = \''+mobilePh + '\'';
                    else
                        ANISearchStr = 'ANI__c = \''+mobilePh+ '\'';                    
                } */
                if (ld.Inbound_Activity_Id__c != null)
                    taskId = ld.Inbound_Activity_Id__c;
            }
            system.debug('taskId = '+taskId); 
            system.debug('ANISearchStr = '+ANISearchStr);
            
            //  Start looking for the Activity record
            if (taskId != null)
            {
                cTask = [SELECT Id, DNIS__c, Sending_Agent_Activity_ID__c, Phone_Number_Dialed__c, Marketing_ID__c, Vendor_Customer_ID__c, createddate, OwnerId, Status, WhoId, WhatId from Task where Id =: taskId AND createddate >=: system.now().addMinutes(-60)];  
            }
            else if (ANISearchStr != null && ANISearchStr.length() > 0)            
            {
                system.debug('searching with ANI:');
                DateTime dt = system.now().addMinutes(-60);
                String formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\''); //   2016-04-15T07:00:00Z
                queryStr = 'SELECT Id, DNIS__c, Sending_Agent_Activity_ID__c, Marketing_ID_Number__c, Marketing_ID__c, Marketing_Campaign__c, Vendor_Customer_ID__c, createddate, OwnerId, Status, WhoId, WhatId from Task where OwnerID = \''+UserInfo.getUserId()+'\' AND ('+ANISearchStr+ ') AND WhoId = NULL and WhatId = NULL AND createddate >='+formattedDt+'order by createddate desc limit 1';                
                system.debug('queryStr = ' +queryStr);
                cTask = Database.query(queryStr);
            }
            if(cTask == null || cTask.isEmpty())    // Look for Open Activity created in the last 5 minutes
            {
                system.debug('before searching for open activity:');
                cTask = [SELECT Id, DNIS__c, Sending_Agent_Activity_ID__c, Marketing_ID__c, Vendor_Customer_ID__c, createddate, OwnerId, Status, WhoId, WhatId from Task where OwnerID =: UserInfo.getUserId() AND WhoId = NULL and WhatId = NULL AND createddate >=: system.now().addMinutes(-15) order by createddate desc limit 1];
//                system.debug('after time check - '+cTask[0].Id);                                
            }               
            
            //  Assume it's an exact match scenario & look for assigned activity
                
            if(cTask == null || cTask.isEmpty())            
            {
                system.debug('inside exact match lookup');
                cTask = [SELECT Id, DNIS__c, Sending_Agent_Activity_ID__c, Marketing_ID__c, Vendor_Customer_ID__c, createddate, OwnerId, Status, WhoId, WhatId from Task where OwnerID =: UserInfo.getUserId() AND Marketing_ID__c = null AND Vendor_Customer_ID__c = null AND DNIS__c <> null AND Activity_Type__c = 'Inbound Call' AND Status = 'Complete' AND (WhoId =:entityId OR WhatId =:entityId) AND createddate >=: system.now().addMinutes(-30) order by createddate desc limit 1];                
            }

            // check if user chose a different lead/account than the one identified by CTI
            if(cTask == null || cTask.isEmpty())            
            {
                system.debug('inside non matching lookup');
                cTask = [SELECT Id, DNIS__c, Sending_Agent_Activity_ID__c, Marketing_ID__c, Vendor_Customer_ID__c, createddate, OwnerId, Status, WhoId, WhatId from Task where OwnerID =: UserInfo.getUserId() AND DNIS__c <> null AND Activity_Type__c = 'Inbound Call' AND Status = 'Complete' AND (WhoId <> null OR WhatId <> null) AND createddate >=: system.now().addMinutes(-5) order by createddate desc limit 1];
            }
                       
            if (!cTask.isEmpty())   // An Open Activity record was found
            {
                system.debug('An Open Activity record was found');
                //  begin - check for transfer
                if (cTask[0].Sending_Agent_Activity_ID__c != null)   // transfer activity            
                {
                    system.debug('Inside transfer activity check block');
                    trfTask = [SELECT Id, Vendor_Customer_ID__c, WhoId, WhatId from Task where Id =:cTask[0].Sending_Agent_Activity_ID__c];
                    if (trfTask[0].Vendor_Customer_ID__c == null)   // check if marketing data has already been updated
                        updMktInfo = true;
                }
                else    // not a transferred call
                    updMktInfo = true;
                // End - check for transfer
                //  Start Lookup Marketing ref details
                if (updMktInfo)
                {
                    if (cTask[0].DNIS__c != null)
                    {
                         system.debug('entityState == '+entityState);       
    //                    if (entityState == null)
      //                  {
                            Postal_Code_County__c [] zipState;
                            zipState = [SELECT State__c, Id FROM Postal_Code_County__c where Id =:zip];
                            entityState = zipState[0].State__c;
                            system.debug('entity state after lookup = '+entityState);
        //                }
                        
                        String mktinfo = lookupMktRefNum(cTask[0].DNIS__c, entityState, useAntCamp, campRecTypeId);
//                        String mktinfo = lookupMktRefNum(cTask[0].DNIS__c, entityState);                        
                        if (mktinfo != null && mktinfo.length() > 0)
                        {
                            String[] mktInfoArray = mktinfo.split(':');
                            if(entity == 'Account')
                            {
                                acc.Marketing_Event__c = mktInfoArray[0];
                                acc.Vendor_Customer_ID__c = mktInfoArray[3];  
                                acc.Inbound_Activity_Id__c = null;
                                update acc;
                            }
                            else if (entity == 'Lead')
                            {
                                ld.Marketing_Event__c = mktInfoArray[0];
                                ld.Vendor_Customer_ID__c = mktInfoArray[3];
                                ld.Inbound_Activity_Id__c = null;
                                update ld;
                            }
                            
                          	cTask[0].Marketing_ID__c = mktInfoArray[1];
                            cTask[0].Vendor_Customer_ID__c = mktInfoArray[3];
                            cTask[0].Marketing_Campaign_Name__c = mktInfoArray[2];                      
                        }
                        else if (useAntCamp == 'Y' && mktinfo.length() <= 0)	// update event ID to FAIL at activity and lead
                        {
                        	system.debug('before updating to fail');
                            cTask[0].Marketing_ID__c = 'FAIL';
                            if (entity == 'Lead')
                            {
                            	ld.Event_Code__c = 'FAIL';
                            	// lookup dummy campaign id
                            	Campaign[] dumCamp;
                            	dumCamp = [SELECT Id, Name, IsActive, Event_Code__c, State__c from Campaign where Name = 'FAIL' AND Event_Code__c = 'FAIL' AND State__c = 'NA'];
                            	if (dumCamp != null && !dumCamp.isEmpty())
                            		ld.Marketing_Event__c = dumCamp[0].Id;
                            	//ld.Marketing_Event__c = '7016300000024AOAAY';
                            	update ld;	
                            }
						}
                    }
                    //  End Lookup Marketing ref details
                }
                if(entity == 'Account')
                {
                    cTask[0].WhatId = acc.Id;
                    if (cTask[0].WhoId != null)
                        cTask[0].WhoId = null;
                }
                else if (entity == 'Lead')
                {
                    cTask[0].WhoId = ld.Id;
                    if (cTask[0].WhatId != null)
                        cTask[0].WhatId = null;
                }
                system.debug('before update - task id = '+cTask[0].Id);
                update cTask[0];
                system.debug('after update');
            }
            else
                system.debug('No Open Activity available for association');
        }
        catch(Exception e)
        {
            System.Debug('Error occured in Method:AssociateActivity: '+e.getMessage());
        }
    }  
    
    public String lookupMktRefNum(String mktTfn, String state, String useAnthOpps, String entityRecTypId)    
//    public String lookupMktRefNum(String mktTfn, String state)
    {
        String updMktTfn = '(' + mktTfn.substring(0, 3) + ') '+ mktTfn.substring(3, 6) + '-' + mktTfn.substring(6,10);
        String mktRefId;
        String mktRefNum;
        String mktCampDesc;
        String mktData = '';
        String vendorCustId;
        String campType = '';
        Campaign[] camp;
    
        
        System.debug('lookupMktRefNum entityRecTypId = '+entityRecTypId);
        
        try
        {
            // Lookup record type for Telesales Marketing Camapaigns
//            System.debug('Record type Id used in campaign lookup = '+campRecType);
            
            
            List<RecordType> recList = [SELECT Id, name FROM RECORDTYPE WHERE Id =:entityRecTypId];
            if (recList[0].Name == 'Anthem Opps')
                campType = 'Anthem Opps';
            else  
                campType = 'TS MASTER';
            
            if (useAnthOpps == 'Y')
                campType = 'Anthem Opps';
                
            System.debug('lookupMktRefNum final campType = '+campType);
            
            List<RecordType> campRecList = [SELECT Id, name FROM RECORDTYPE WHERE Name =:campType and sObjectType = 'Campaign'];
            
            Datetime ctime = Datetime.now();  
            Date cdt = ctime.Date();
    
            //camp = [SELECT Id, Name, Description, IsActive, Event_Code__c, State__c, Toll_Free_Number__c, endDate from Campaign where RecordTypeId =:recList[0].Id AND (Toll_Free_Number__c =:mktTfn OR Toll_Free_Number__c =:updMktTfn) AND StartDate < :cdt AND EndDate >= :cdt AND IsActive = true];
//            camp = [SELECT Id, Name, Description, IsActive, Event_Code__c, State__c, Toll_Free_Number__c, endDate from Campaign where RecordTypeId =:recList[0].Id AND (Toll_Free_Number__c =:mktTfn OR Toll_Free_Number__c =:updMktTfn) AND StartDate < :cdt order by StartDate desc];         
            camp = [SELECT Id, Name, Description, IsActive, Event_Code__c, State__c, Toll_Free_Number__c, endDate from Campaign where RecordTypeId =:campRecList[0].Id AND (Toll_Free_Number__c =:mktTfn OR Toll_Free_Number__c =:updMktTfn) AND StartDate < :cdt order by StartDate desc];
            
            if (camp != null && !camp.isEmpty())    // Record was found with TFN
            {
                if (camp.size() == 1)   //  Single Match
                {
                    mktRefId = camp[0].Id;
                    mktRefNum = camp[0].Name;
                    mktCampDesc = camp[0].Description;
                    mktData =  mktRefId+':'+mktRefNum +':'+mktCampDesc;
                    system.debug('Single Match mktRefId = '+mktRefId);  
                }
                else    //  Multiple matches
                {
                    system.debug('nultiple matches');
                    for(Campaign cmp : camp)
                    {
                        if (cmp.State__c == state)    // If Lead/Account state matches, pick that record
                        {
                            system.debug('inside for loop - state matches');
                            mktRefId = cmp.Id;
                            mktRefNum = cmp.Name;
                            mktCampDesc = cmp.Description;
                            mktData =  mktRefId+':'+mktRefNum +':'+mktCampDesc;
                            break;
                        } 
                        else if (cmp.State__c == 'UK')  // else, pick the record with the unknown state
                        {
                            system.debug('inside for loop - unknown state');
                            mktRefId = cmp.Id;
                            mktRefNum = cmp.Name;
                            mktCampDesc = cmp.Description;
                            mktData =  mktRefId+':'+mktRefNum +':'+mktCampDesc;
                            break;
                        }
                    }
                }
                // generate vendor cust Id
                if (mktRefId != null)
                {
                    Datetime currTime = system.now();
                    String currMS = String.valueOf(currTime.getTime());
                    vendorCustId = 'SFDC'+currMS.substring(currMS.length()-12);
                    system.debug('new vendorCustId = '+vendorCustId);
                    mktData = mktData + ':'+ vendorCustId;
                }
            }
            system.debug('returning marketingdata as = '+mktData);
        }
        catch(Exception e)
        {
            System.Debug('Error occured in Method:lookupMktRefNum: '+e.getMessage());
        }
        return mktData; 
    }         
}