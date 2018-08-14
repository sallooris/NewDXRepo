/************************************************************************
* Class Name  : SGA_AP49_CreateOptyProducts
* Created By  : IDC Offshore
* Created Date: 9/19/2017
* Description : It is used to create/update Opportunity Products from
*                Opportunity Detail page.
* 
**********************************************************************/
public with sharing class SGA_AP49_CreateOptyProducts {
    public final Opportunity oppObj {get;set;}
    public static final string FRWD_SLASH = '/';
    public Integer rowIndex {get;set;}
    public List<Opportunity_Products__c> fetchOptyProdRecList {get;set;} 
    public List<Opportunity_Products__c> delOptyProdRecList {get;set;}
    private static final string ROW_INDEX = 'rowIndex';
    private Static final string CLS_SGA_AP49='SGA_AP49_CreateOptyProducts';
    private Static final string SGA_AP49_Fetch_opty ='fetchOptyProdRec';
    private static final string NONE = 'None';
    private static final string WON = 'Won';
    
    /**************************************
    *Constructor for the class.
    ************************************/
    public SGA_AP49_CreateOptyProducts(ApexPages.StandardController controller){
        oppObj = (Opportunity)controller.getRecord();
        fetchOptyProdRecList = new List<Opportunity_Products__c>();
        delOptyProdRecList = new List<Opportunity_Products__c>();
    }
    /*************************************************************************************
    * Method Name : fetchOptyProdRec
    * Parameters  : None
    * Return Type : void
    * Description : The method will call when the page is loaded which is used
    *               to create 3 records by default. User will delete if they do not want.
    **************************************************************************************/
    public void fetchOptyProdRec(){
        try
        {
            fetchOptyProdRecList = [SELECT ID,Opportunity__c,State__c,Product_Type__c,X24_Month_Rate_Guarantee__c,Current_Carrier__c,
                                    Business_Lost_To__c,Won_Lost_Status__c,Lost_Reason__c,Comments__c FROM Opportunity_Products__c WHERE
                                    Opportunity__c =:oppObj.ID];
            if(fetchOptyProdRecList.isEmpty()){
                for(Integer i = 0; i < 3; i++ ){
                    fetchOptyProdRecList.add(new Opportunity_Products__c(Opportunity__c = oppObj.ID));
                }
            }
        }catch(Exception e){UTIL_LoggingService.logHandledException(e, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP49,SGA_AP49_Fetch_opty, SG01_Constants.BLANK, Logginglevel.ERROR);}        
    }
    
    /*************************************************************************************
    * Method Name : save
    * Parameters  : None
    * Return Type : PageReference
    * Description : The method is used to upsert the opportunity product records 
    *               and deletes the records.
    **************************************************************************************/
    public PageReference save() {
        PageReference pageRef = null;
        try
        {
            if(!delOptyProdRecList.isEmpty()){
                delete delOptyProdRecList;
            }
            
            if(!fetchOptyProdRecList.isEmpty()){
                for(Opportunity_Products__c oppPrd : fetchOptyProdRecList){
                    if((!String.isBlank(oppPrd.Business_Lost_To__c) && 
                        WON.equalsIgnoreCase(oppPrd.Won_Lost_Status__c)) || 
                       (!String.isBlank(oppPrd.Business_Lost_To__c) && 
                        String.isBlank(oppPrd.Won_Lost_Status__c))) {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.SG90_BusinessLostError));
                            return null;
                        }
                }
                upsert fetchOptyProdRecList;
            }
            pageRef = new PageReference(FRWD_SLASH+oppObj.Id);
        }catch(Exception e){UTIL_LoggingService.logHandledException(e, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP49,SGA_AP49_Fetch_opty, SG01_Constants.BLANK, Logginglevel.ERROR);        }        
        return pageRef;
    }
    /*************************************************************************************
    * Method Name : deleteRow
    * Parameters  : None
    * Return Type : void
    * Description : The method is used add the deleted rows in the list
    **************************************************************************************/
    public void deleteRow() {
        try
        {
            rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get(ROW_INDEX));
            Opportunity_Products__c toBeDelRec = fetchOptyProdRecList.remove(rowIndex);
            if(String.isNotBlank(toBeDelRec.Id)){
                delOptyProdRecList.add(toBeDelRec);
            }
        }catch(Exception e){UTIL_LoggingService.logHandledException(e, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP49,SGA_AP49_Fetch_opty, SG01_Constants.BLANK, Logginglevel.ERROR);}        
        
    }
    /*************************************************************************************
    * Method Name : addRow
    * Parameters  : None
    * Return Type : void
    * Description : The method is used add the new records to list
    **************************************************************************************/
    public void addRow() {
        try
        {
            fetchOptyProdRecList.add(new Opportunity_Products__c(Opportunity__c = oppObj.Id));
        }catch(Exception e){UTIL_LoggingService.logHandledException(e, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLS_SGA_AP49,SGA_AP49_Fetch_opty, SG01_Constants.BLANK, Logginglevel.ERROR);}        
    }
}