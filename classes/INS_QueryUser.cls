global with Sharing class INS_QueryUser implements vlocity_ins.VlocityOpenInterface
{
    public Static Final String dateFormat = 'MMM d yyyy';
    public Static Final String name_constant = 'name';
    public Static Final String value_constant = 'value';
    public Static Final String options_constant = 'options';
    

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) 
    {
        Boolean result = true;
        String state= 'DateSettings';
        try
        {
           if(methodName.equalsIgnoreCase('GetRequestCoverageDates')){
                GetRequestCoverageDates(outMap,state);
           }
        } 
        catch(Exception e)
        {
            System.debug('QueryUser:invokeMethod -> exception: '+e);
            result = false;
        }        
        return result;
    }
     
    public void GetRequestCoverageDates(Map<String, object> outMap,String state)
    {
        date mydate;
        mydate = system.today();
        integer x = 1;
        integer u = 0; 

        Ins_Date_Settings__c eds = Ins_Date_Settings__c.getValues(state);
        
        List<Map<String, String>> RequestCoverageEffectiveDates = new List<Map<String,String>>();   
        for(Integer i=Integer.valueOf(eds.SkipDays__c); i<Integer.valueOf(eds.DateSpan__c); i++){
            System.debug('i :'+i);
            Datetime newDateTime = mydate.addDays(i);
            if(newDateTime.yearGmt() < Integer.valueOf(eds.EffectiveDateStartYear__c)){
                continue;
            }
            Map<String, String> tempMap = new Map<String, String>();
            String formatted = newDateTime.formatGMT(dateFormat);
            Integer reqDate = newDateTime.dayGmt();
            Integer reqmonth = mydate.month();
            Integer reqmon = newDateTime.monthgmt();
            if(reqDate ==1){
                if(reqmonth != reqmon ){
                     if(u==6){
                        break;
                     }
                     tempMap.put(name_constant, formatted );
                     tempMap.put(value_constant, formatted );
                     RequestCoverageEffectiveDates.add(tempMap);
                     System.debug('RequestCoverageEffectiveDates :'+RequestCoverageEffectiveDates);
                     U++;
                                
                }

            }
        }  
        
        outMap.put(options_constant, RequestCoverageEffectiveDates);
    }
}