/**
* Contorller for page OpportunityView
*
* @Date:       02.13.2016
* @Author:     Usman Ali (Magnet360)
* @Updates:    
* @Purpose:    
*/

public without sharing class OpportunityViewController 
{
    public String message { get; set; } 
    public Boolean isNeedToDisplayMsg {get; set;}

    // Constructor of class
    public OpportunityViewController( ApexPages.StandardController sc ){
    }

    public PageReference redirect()
    {

        isNeedToDisplayMsg = false ;
        PageReference pr;
        System.debug('UAC ' + ApexPages.currentPage().getParameters());
        ApexPages.currentPage().getParameters().put('nooverride', '0');
        String oppid = ApexPages.currentPage().getParameters().get('Id');
        
        // Get current Opportunity RecordTypeId
        Opportunity opp = [SELECT Id, RecordTypeId FROM Opportunity WHERE Id = :oppid];
        System.debug('UAC: opps ' + opp);

        // Check for current Opp and Current User Access 
        UserRecordAccess ura = [ SELECT RecordId, HasReadAccess, HasTransferAccess, MaxAccessLevel
                                 FROM UserRecordAccess
                                 WHERE UserId = :UserInfo.getUserId() AND RecordId = :oppid ];

        System.debug('UAC: ura ' + ura );

        // Get custom settings 
        Anthem_Opps_No_Access__c setting = Anthem_Opps_No_Access__c.getInstance();

        // When user doesn't has access and recordType match with Custom Setting record type 
        if( !ura.HasReadAccess && opp.RecordTypeId == setting.Record_Type_Id__c ){
            isNeedToDisplayMsg = true;
            message = setting.Message__c ;
            return null ;
        } 
        
        return pr ;
    }
}