global with Sharing class QueryUser implements vlocity_ins.VlocityOpenInterface
{
    public Static Final String stateVal = 'NY';
    public Static Final String dateFormat = 'MMM d yyyy';
    public Static Final String name_constant = 'name';
    public Static Final String value_constant = 'value';
    public Static Final String options_constant = 'options';
    global QueryUser(){}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) 
    {
        Boolean result = true;
        try
        {
            if (methodName.equalsIgnoreCase('GetStaffMember')) 
            {
                GetStaffMember(inputMap,outMap);
            }
            else if(methodName.equalsIgnoreCase('GetRequestCoverageBrokerDates')){
                GetRequestCoverageBrokerDates(outMap);
            }
            else if(methodName.equalsIgnoreCase('GetRequestCoverageNonBrokerDates')){
                GetRequestCoverageNonBrokerDates(outMap);
            }
        } 
        catch(Exception e)
        {
            System.debug('QueryUser:invokeMethod -> exception: '+e);
            result = false;
        }        
        return result;
    }
     
    void GetStaffMember(Map<String, Object> inputMap, Map<String, Object> outMap)
    {
      String sUserName = (String)inputMap.get('userName');
     
      List<User> Con =[select FederationIdentifier from User where Username = :sUserName limit 1];

      if(Con != null && Con.size() > 0)
      {
           Map<String, Object> stepNode = new Map<String, Object>();
           stepNode.put('TypeAheadBroker', Con[0].FederationIdentifier);
           outMap.put('TypeAheadBroker-Block', stepNode);
           outMap.put('MinInfo', stepNode);
           System.debug('This is the Staff Member Name: ' + Con[0].name);
      } 
      else
      {
        outMap.put('BrokerError', 'NOT FOUND');
      }
    }
    
    void GetRequestCoverageBrokerDates(Map<String, object> outMap)
    {
        date mydate;
        mydate = system.today();
        integer x = 1;
		Broker_Date_Settings__c bds = Broker_Date_Settings__c.getValues(stateVal);

        List<Map<String, String>> RequestCoverageEffectiveDates = new List<Map<String,String>>();   
        for(Integer i=Integer.valueOf(bds.Broker_Skip_Days__c); i<Integer.valueOf(bds.Broker_Date_Span__c); i++){
            Datetime newDateTime = mydate.addDays(i);
            if(newDateTime.yearGmt() < Integer.valueOf(bds.EffectiveDate_Start_Year__c)){
                continue;
            }
            Map<String, String> tempMap = new Map<String, String>();
            String formatted = newDateTime.formatGMT(dateFormat);
            Integer reqDate = newDateTime.dayGmt();
            if(reqDate ==1 || reqDate ==15){
                tempMap.put(name_constant, formatted );
                tempMap.put(value_constant, formatted );
                RequestCoverageEffectiveDates.add(tempMap);
            }
        }  
        outMap.put(options_constant, RequestCoverageEffectiveDates);
    }
    
    
    void GetRequestCoverageNonBrokerDates(Map<String, Object> outMap)
    {
        date mydate;
        mydate = System.today();
        integer x = 1;
		Broker_Date_Settings__c bds = Broker_Date_Settings__c.getValues(stateVal);
		List<Map<String, String>> RequestCoverageEffectiveDates = new List<Map<String,String>>(); 
        
        for(Integer i=Integer.valueOf(bds.Internal_Users_Past_Days_Span__c);i<Integer.valueOf(bds.Internal_users_days_span__c);i++){
            Datetime newDateTime = mydate.addDays(i);
            if(newDateTime.yearGmt() < Integer.valueOf(bds.EffectiveDate_Start_Year__c)){
                continue;
            }
            Map<String, String> tempMap = new Map<String, String>();
            String formatted = newDateTime.formatGMT(dateFormat);
            Integer reqDate = newDateTime.dayGmt();
            if(reqDate ==1 || reqDate ==15){
                tempMap.put(name_constant, formatted );
                tempMap.put(value_constant, formatted ); 
                RequestCoverageEffectiveDates.add(tempMap); 
            }
        }
        outMap.put(options_constant, RequestCoverageEffectiveDates);
    }
    
}