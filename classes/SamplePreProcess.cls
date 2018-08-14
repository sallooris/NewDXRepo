global with Sharing class SamplePreProcess implements vlocity_ins.VlocityOpenInterface {

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
         system.debug('in preprocess input map is '+inputMap);
         for(String key : inputMap.keySet()){
           if(key == 'ABCD1234'){
             Object realData = inputMap.get(key);
             Map<String, Object> real = (Map<String, Object>) realData;
             for(String key1 : real.keySet()){
               if(key1=='Number Of Members'){
                 if(Integer.valueOf(real.get(key1)) > 10)
                     real.put('Number Of Members', 10);
               }
             }
           }
         }
    }
    
  }