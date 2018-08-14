/************************************************************************************
* Class Name     : SGA_AP50_RenewalUpsellOps
* Created By     : IDC Offshore
* Created Date   : 09/22/2017
* Description    : This is used create Renewal Opportunities and Upsell Opportunities
*                   when the Account Renewal Packet Data load.
* Change History :
************************************************************************************/
public without sharing class SGA_AP50_RenewalUpsellOps {
    private static final String RENEWAL = 'Renewal';
    private static final String UPSELL = 'Upsell';
    private static final String ACCTEAM_AM_ROLE = 'Account Manager (AM)';
    private static final String COMMA = ',';
    private static final String SPACE = ' ';
    private static final String OPP_NAME =' Opp - ';
    private static final String REN_OPP_STAGE = 'Quote Provided';
    private static final String UPSELL_OPP_STAGE = 'New Opportunity';
    private static final String BLANK = '';
    private static final String ACC_TYPE = 'Enrolled';
    private static final String INSERT_OP = 'Insert';
    private static final String UPDATE_OP = 'Update';
    private static final String DEFAULT_DATE='1/1/2999';
    private static final String DATE_FORMAT = 'MM/dd/YYYY';
    public static Boolean isAfterInsertUpdate = true;
    //short forms map for Medical,Dental,Vision, Life and Disability
    private static final Map<String, String> shortFormsMap = new Map<String, String>{'Medical' => 'Med','Dental' => 'Den','Vision' => 'Vis','Life' => 'Lif','Disability' => 'Dis'};
        //SG Quoting Opportunity Rec Type ID
        public static final Id oppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SG Quoting').getRecordTypeId();    
    public static final String CLASS_NAME = 'SGA_AP50_RenewalUpsellOps';
    public static final String METHOD_NAME = 'createRenewalUpsellOpps';
    /*************************************************************************************
* Method Name : createRenewalUpsellOpps
* Parameters  : newMap, oldMap and Operation(Insert or Update)
* Return Type : void
* Description : This is method will call from SGA_AP42_AccountTeamOwner_Update class
*                once the account team is created for new Account.
*                1. It is used to create the Renewal Opportunity with all Sold Products
*                2. It is used to create the Upsell Opportunity with all unsld products
* ***********************************************************************************/
    public void createRenewalUpsellOpps(Map<ID,Account> newMap,Map<ID,Account> oldMap,String operation){
        try{
            //Map to store the account ids to create renewal opportunity and the sold opportuntiy prodcuts
            Map<ID,String> renewalOppPrdMap = new Map<ID,String>();
            //Map to store the account ids to create upsell opportunity and unsold opportuntiy prodcuts
            Map<ID,String> upsellOppPrdMap = new Map<ID,String>();
            //renewal shot form map is used to construct the name of the opportunity with sold products
            Map<ID,String> renewalShortFormMap = new Map<ID,String>();
            //upsell shot form map is used to construct the name of the opportunity with unsold products
            Map<ID,String> upsellShortFormMap = new Map<ID,String>();
            //if the account having sold products, adding that account to this list so that only the renewal accounts will be processed
            List<Account> renewalAccList = new List<Account>();
            //if the account having sold products, adding that account to this list so that only the upsell accounts will be processed
            List<Account> upsellAccList = new List<Account>();
            //Map to store the account ids to create renewal opportunity and the account
            Map<ID,Account> renewalAccMap = new Map<ID,Account>();
            //Map to store the account ids to create upsell opportunity and the account
            Map<ID,Account> upsellAccMap = new Map<ID,Account>();
            Set<ID> accIdSet = new Set<ID>();
            
            for(Account accObj : newMap.values()){
                //checking condition that account type is Enrolled
                if(accObj.Type != NULL && ACC_TYPE.equalsIgnoreCase(accObj.Type) && 
                   ((UPDATE_OP.equalsIgnoreCase(operation) && accObj.Type != oldMap.get(accObj.Id).Type) 
                    || (INSERT_OP.equalsIgnoreCase(operation)))){
                        if(accObj.Tech_Sold_Products__c != NULL){
                            String renewalPrds = BLANK,renewalShortFroms = BLANK,upsellPrds = BLANK,upsellShortFroms = BLANK;
                            for(String prdType : shortFormsMap.keySet()){
                                if(accObj.Tech_Sold_Products__c.contains(prdType)){
                                    renewalPrds = String.isBlank(renewalPrds) ? prdType : renewalPrds+COMMA+prdType;
                                    renewalShortFroms = String.isBlank(renewalShortFroms) ? shortFormsMap.get(prdType) : renewalShortFroms+SPACE+shortFormsMap.get(prdType);
                                    renewalAccList.add(accObj);
                                    renewalAccMap.put(accObj.Id,accObj);
                                    accIdSet.add(accObj.Id);
                                }else{
                                    upsellPrds = String.isBlank(upsellPrds) ? prdType : upsellPrds+COMMA+prdType;
                                    upsellShortFroms = String.isBlank(upsellShortFroms) ? shortFormsMap.get(prdType) : upsellShortFroms+SPACE+shortFormsMap.get(prdType);
                                    upsellAccList.add(accObj);
                                    upsellAccMap.put(accObj.Id,accObj);
                                    accIdSet.add(accObj.Id);
                                }
                            }
                            if(String.isNotBlank(renewalPrds)){
                                renewalOppPrdMap.put(accObj.Id,renewalPrds);
                                renewalShortFormMap.put(accObj.Id, renewalShortFroms);
                            }
                            if(String.isNotBlank(upsellPrds)){
                                upsellOppPrdMap.put(accObj.Id,upsellPrds);
                                upsellShortFormMap.put(accObj.Id, upsellShortFroms);
                            }
                        }
                    }
            }
            //Fetching account team member with Role Account Manager for the accounts
            Map<ID,Account> accTeamMap = new Map<ID,Account>([Select ID,(Select ID,UserId from AccountTeamMembers Where TeamMemberRole = :ACCTEAM_AM_ROLE LIMIT 1) 
                                                              FROM Account 
                                                              WHERE ID IN :accIdSet]);
            //creating renewal opportunities
            if(!renewalOppPrdMap.isEmpty()){
                createRenewalOpps(renewalAccMap,renewalOppPrdMap,renewalShortFormMap,accTeamMap);
            }
            //creating Upsell opportunities
            if(!upsellOppPrdMap.isEmpty()){
                createUpsellOpps(upsellAccMap,upsellOppPrdMap,upsellShortFormMap,accTeamMap);
            }
        }Catch(Exception ex){UTIL_LoggingService.logHandledException(ex, SG01_Constants.ORGID, SG01_Constants.APPLICATIONNAME,CLASS_NAME, METHOD_NAME, SG01_Constants.BLANK, Logginglevel.ERROR); }
    }
    /*************************************************************************************
    * Method Name : createRenewalOpps
    * Parameters  : renewalAccMap, renewalPrdMap, renewalShortFormMap and accTeamMap
    * Return Type : void
    * Description : It is used to create the Renewal Opportunity with all Sold Products
    * ***********************************************************************************/
    private void createRenewalOpps(Map<ID,Account> renewalAccMap,Map<ID,String> renewalPrdMap,Map<ID,String> renewalShortFormMap,Map<ID,Account> accTeamMap){
        List<Opportunity> renewalOppList = new List<Opportunity>();
        List<Opportunity_Products__c> renewalOppPrdList = new List<Opportunity_Products__c>();
        for(Account accObj : renewalAccMap.values()){
            //creating new renewal opportunity
            Opportunity renewalOpp = constructOpportunity(accObj,REN_OPP_STAGE,RENEWAL,renewalShortFormMap,accTeamMap);
            renewalOppList.add(renewalOpp);
        }
        //Inserting the opportunities
        if(!renewalOppList.isEmpty()){
            Database.Insert(renewalOppList);
        }
        //Creating opportunity products for the renewal opportunity
        for(Opportunity oppObj : renewalOppList){
            if(renewalPrdMap.get(oppObj.AccountId) != NULL){
                for(String prodType : renewalPrdMap.get(oppObj.AccountId).split(COMMA)){
                    Opportunity_Products__c oppPrd = createOppProds(oppObj,prodType);
                    renewalOppPrdList.add(oppPrd);
                }
            }
        }
        if(!renewalOppPrdList.isEmpty()){
            Database.insert(renewalOppPrdList);
        }
        
    }
    /*************************************************************************************
    * Method Name : createUpsellOpps
    * Parameters  : upsellAccMap, upsellPrdMap, upsellShortFormMap and accTeamMap
    * Return Type : void
    * Description : It is used to create the Renewal Opportunity with all Sold Products
    * ***********************************************************************************/
    private void createUpsellOpps(Map<ID,Account> upsellAccMap,Map<ID,String> upsellPrdMap,Map<ID,String> upsellShortFormMap,Map<ID,Account> accTeamMap){
        List<Opportunity> upsellOppList = new List<Opportunity>();
        List<Opportunity_Products__c> upsellOppPrdList = new List<Opportunity_Products__c>();
        for(Account accObj : upsellAccMap.values()){
            //creating new renewal opportunity
            Opportunity upsellOpp = constructOpportunity(accObj,UPSELL_OPP_STAGE,UPSELL,upsellShortFormMap,accTeamMap);
            upsellOppList.add(upsellOpp);
        }
        //Inserting the opportunities
        if(!upsellOppList.isEmpty()){
            Database.Insert(upsellOppList);
        }
        //Creating opportunity products for the renewal opportunity
        for(Opportunity oppObj : upsellOppList){
            if(upsellPrdMap.get(oppObj.AccountId) != NULL){
                for(String prodType : upsellPrdMap.get(oppObj.AccountId).split(COMMA)){
                    Opportunity_Products__c oppPrd = createOppProds(oppObj,prodType);
                    upsellOppPrdList.add(oppPrd);
                }
            }
        }
        if(!upsellOppPrdList.isEmpty()){
            Database.insert(upsellOppPrdList);
        }
    }
    /*************************************************************************************
    * Method Name : constructOpportunity
    * Parameters  : accObj, stageName, typeValue,renUpsellShortFormMap and accTeamMap
    * Return Type : Opportunity
    * Description : This is util method for constructing renewal and upsell opportunities
    * ***********************************************************************************/
    private Opportunity constructOpportunity(Account accObj,String stageName,String typeValue,
                                            Map<ID,String> renUpsellShortFormMap,Map<ID,Account> accTeamMap){
        Opportunity renUpsellOpp = new Opportunity();
        renUpsellOpp.AccountId = accObj.Id;
        String effectiveDateStr = BLANK;
        //fetching the effective date from Requested_Effective_Date__c
        //if it is blank, populating with 1/1/2999
        if(String.isNotBlank(String.valueOf(accObj.Requested_Effective_Date__c))){
            effectiveDateStr = DateTime.newInstance(accObj.Requested_Effective_Date__c.year(),accObj.Requested_Effective_Date__c.month(),accObj.Requested_Effective_Date__c.day()).format(DATE_FORMAT);
        }else{
            effectiveDateStr = DEFAULT_DATE;
        }
        //constructing opportunity name as per short forms
        renUpsellOpp.Name = accObj.Name+SPACE+effectiveDateStr+OPP_NAME+renUpsellShortFormMap.get(accObj.Id);
        renUpsellOpp.Type = typeValue;
        renUpsellOpp.Effective_Date__c = accObj.Requested_Effective_Date__c;
        renUpsellOpp.StageName = stageName;
        renUpsellOpp.RecordTypeId = oppRecTypeId;
        renUpsellOpp.CloseDate = System.today()+30; 
        renUpsellOpp.Total_Employee_Count__c = accObj.Number_of_Employees__c;
        renUpsellOpp.Annualized_Group_Premium__c= accObj.Tech_Annualized_Group_Premium__c;
        renUpsellOpp.Increase_Release_Renewal__c= accObj.Tech_Increase_Release_Renewal__c;
        renUpsellOpp.Total_Employee_Count__c= accObj.Tech_Total_of_Eligible_Employees__c;
        renUpsellOpp.Enrolled_Employees__c= accObj.Tech_Enrolled_Employees__c;
        renUpsellOpp.On_Exchange__c= accObj.Tech_On_Exchange__c;
        Account acc = accTeamMap.get(accObj.Id);
        List<AccountTeamMember> actMem = acc.AccountTeamMembers;
        if(actMem != NULL && actMem.size() > 0){
            renUpsellOpp.OwnerId = actMem[0].UserId;
        }
        return renUpsellOpp;
    }
    
    /*************************************************************************************************
    * Method Name : createOppProds
    * Parameters  : Opportunity,String
    * Return Type : Opportunity_Products__c
    * Description : This is util method for constructing renewal and upsell Opportunity_Products__c
    * **********************************************************************************************/
    private Opportunity_Products__c createOppProds(Opportunity oppObj,String prodType){
        Opportunity_Products__c oppPrd = new Opportunity_Products__c();
        oppPrd.Product_Type__c = prodType;
        oppPrd.Opportunity__c = oppObj.Id;
        return oppprd;
    }
}