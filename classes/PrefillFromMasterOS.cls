global with Sharing class PrefillFromMasterOS implements vlocity_ins.VlocityOpenInterface {

   public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean success = true;
        try{
            if(methodName == 'prefill') {             
                 prefill(inputMap, outMap, options);                
            }
            if(methodName == 'prefillmember') {             
                 prefillmember(inputMap, outMap, options);                
            }
          }catch(Exception e){
                    system.debug(e);
                    success=false;
         }

        return success;        
    }
    
    private static void prefill(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        outMap.putAll(inputMap);
        system.debug(outMap);        
    }
    private static void prefillmember(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        
     //   map<string,object> quoteinfomap = (map<string,object>)inputmap.get('QuoteOptionCustomerInfo');
    //    map<string,object> mininfomap = (map<string,object>)quoteinfomap.get('QuoteOptionCustomerInfo');
        outMap.putAll(inputMap);
        
    //    map<string,object> subinfomap = (map<string,object>)inputmap.get('Application');
        
    //    subinfomap.put(); 
        
        
        system.debug(outMap);        
    }
    
  }