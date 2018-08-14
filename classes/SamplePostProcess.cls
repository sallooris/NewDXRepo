global with Sharing class SamplePostProcess implements vlocity_ins.VlocityOpenInterface {

   public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean success = true;
        try{
            if(methodName == 'calculate') {             
                 calculation(inputMap, outMap, options);                
            }
          }catch(Exception e){
                    system.debug(e);
                    success=false;
         }

        return success;        
    }
    
    private static void calculation(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
         system.debug(outMap);
         for(String key : outMap.keySet()){
           if(key == 'output'){
              List<Object> outputData = (List<Object>) outMap.get(key);
              vlocity_ins.PricingCalculationService.CalculationProcedureResults results = (vlocity_ins.PricingCalculationService.CalculationProcedureResults )outputData[0];
              List<Object> calResults = results.calculationResults;
              for(Object res : calResults){
                Map<String, Object> objMap = (Map<String, Object>) res;
                for(String key1: objMap.keySet()){
                    if(key1=='FinalTotalCost'){
                        objMap.put(key1, Integer.valueOf(objMap.get(key1)) -5);
                    }
                }
              }
            }
         }
    }
    
  }