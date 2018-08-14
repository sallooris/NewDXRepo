global with sharing class GetProductAttributesServiceDental implements vlocity_ins.VlocityOpenInterface{
/*
* @CreatedBy: Kumar Kshitiz(Vlocity)
* @Date: 29-08-2016
* This class serves for the evaluation of Dental formula and attributes construction
*/
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean success = true;
        
        try{
            if(methodName == 'calculate') {
                Integer timeStamp = Limits.getCpuTime();
                System.debug(Logginglevel.ERROR, 'Check - Total CPU before post process ' + timeStamp);
                Long actualStartTime = DateTime.now().getTime();
                
                //Evaluate formulas
                evaluateCalcFormulas(inputMap, outMap, options);
                
                //Construct Attributes
                constructProductAttributes(inputMap, outMap, options);
                System.debug(Logginglevel.ERROR, 'Check - Total CPU for post process ' + Limits.getCpuTime());
                System.debug(Logginglevel.ERROR, 'Check - post process CPU time ' + (Limits.getCpuTime() - timeStamp));
                System.debug(Logginglevel.ERROR, 'Check - post process actual time' + (DateTime.now().getTime() - actualStartTime));
            }   
        }catch(Exception e){
            System.debug(' exception '+e);
            success = false;
            throw e;
        } 
        return success;
        
    }

    public void evaluateCalcFormulas(Map<String, object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        System.Debug('In evaluateFormulas, outMap is : ' + outMap);
        
        //formula constants
        final Decimal TI_EE = 1.0;
        final Decimal TI_SP = 2.04;
        final Decimal TI_CH = 0.75; 
        final Decimal TI_FA = 1.14;

        //formulas variables
        Decimal EE_TOTAL;
        Decimal EE_SP_TOTAL;
        Decimal EE_CH_TOTAL;
        Decimal EE_FA_TOTAL;

        Decimal BS_NO_EE;
        Decimal BS_NO_FA;
        Decimal BS_O_EE;
        Decimal BS_O_EE_SP;
        Decimal BS_O_EE_CH;
        Decimal BS_O_FA;
        Decimal PCT_TR;
        Decimal P_S;
        Decimal P_FA;
        Decimal S_S_FA;
        Decimal CL_CL_FA;
        Decimal A_A;
        Decimal C1EE;
        Decimal C1EESp;
        Decimal C1EECh;
        Decimal C1EEFa;
        Decimal C1Total;
        Decimal Temp1;
        Decimal Temp2;

        if(outMap!=null && outMap.size()>0){
            String finalOutPutKey = (String) options.get('outputKey');
            if(finalOutPutKey == null || finalOutPutKey == ''){
                finalOutPutKey = 'output';
            }

            List<Object> outputList = new List<Object> ();
            List<Object> calcList;
            Map<String, Object> calMap; 

            outputList = (List<Object>) outMap.get(finalOutPutKey);
            for(Object keyMap : outputList){
                vlocity_ins.PricingCalculationService.CalculationProcedureResults results = (vlocity_ins.PricingCalculationService.CalculationProcedureResults)keyMap;
                if(results!=null){
                    calcList = results.calculationResults;
                    if(calcList !=null && calcList.size()>0){
                        for(integer i=0; i<calcList.size(); i++){
                            calMap = (Map<String, Object>)calcList[i];

                            EE_TOTAL = 0.0;
                            EE_SP_TOTAL = 0.0;
                            EE_CH_TOTAL = 0.0;
                            EE_FA_TOTAL = 0.0;
                            C1Total = 0.0;

                            //Get the values for calculation and delete the keys
                            if(calMap.containsKey('BS__NO_EE')){
                                BS_NO_EE = Decimal.valueOf(String.valueOf(calMap.remove('BS__NO_EE')));
                            }
                            if(calMap.containsKey('BS__NO_FA')){
                                BS_NO_FA = Decimal.valueOf(String.valueOf(calMap.remove('BS__NO_FA')));
                            }
                            if(calMap.containsKey('BS__O_EE')){
                                BS_O_EE = Decimal.valueOf(String.valueOf(calMap.remove('BS__O_EE')));
                            }
                            if(calMap.containsKey('BS__O_EE_SP')){
                                BS_O_EE_SP = Decimal.valueOf(String.valueOf(calmap.remove('BS__O_EE_SP')));
                            }
                            if(calMap.containskey('BS__O_EE_CH')){
                                BS_O_EE_CH = Decimal.valueOf(String.valueOf(calmap.remove('BS__O_EE_CH')));
                            }
                            if(calMap.containskey('BS__O_FA')){
                                BS_O_FA = Decimal.valueOf(String.valueOf(calmap.remove('BS__O_FA')));
                            }
                            if(calMap.containskey('PCT__TR')){
                                PCT_TR = Decimal.valueOf(String.valueOf(calmap.remove('PCT__TR')));
                            }
                            if(calMap.containskey('P__S')){
                                P_S = Decimal.valueOf(String.valueOf(calMap.remove('P__S')));
                            }
                            if(calMap.containsKey('P__FA')){
                                P_FA = Decimal.valueOf(String.valueOf(calmap.remove('P__FA')));
                            }
                            if(calMap.containsKey('S__S_FA')){
                                S_S_FA = Decimal.valueOf(String.valueOf(calMap.remove('S__S_FA')));
                            }
                            if(calMap.containsKey('CL__CL_FA')){
                                CL_CL_FA = Decimal.valueOf(String.valueOf(calMap.remove('CL__CL_FA')));
                            }
                            if(calMap.containsKey('A__A')){
                                A_A = Decimal.valueOf(String.valueOf(calMap.remove('A__A')));
                            }
                            if(calMap.containsKey('C1EE')){
                                C1EE = Decimal.valueOf(String.valueOf(calMap.remove('C1EE')));
                            }
                            if(calMap.containsKey('C1EESp')){
                                C1EESp = Decimal.valueOf(String.valueOf(calMap.remove('C1EESp')));
                            }
                            if(calMap.containsKey('C1EECh')){
                                C1EECh = Decimal.valueOf(String.valueOf(calMap.remove('C1EECh')));
                            }
                            if(calMap.containsKey('C1EEFa')){
                                C1EEFa = Decimal.valueOf(String.valueOf(calMap.remove('C1EEFa')));
                            }
                            //Evaluate Temp formulas
                            if(BS_NO_EE != null && PCT_TR != null && P_S != null && S_S_FA != null){
                                Temp1 = BS_NO_EE * PCT_TR * P_S * S_S_FA;   
                            }
                            if(BS_NO_FA != null && PCT_TR != null && P_FA != null && S_S_FA != null){
                                Temp2 = BS_NO_FA * PCT_TR * P_FA * S_S_FA;
                            }
                            
                            //Evaluate Formulas
                            if(CL_CL_FA != null && A_A != null && Temp1 != null){
                                if(BS_O_EE != null){
                                    EE_TOTAL = (((Temp1 * TI_EE) + BS_O_EE) * CL_CL_FA) / (1 - A_A);    
                                }
                                if(BS_O_EE_SP != null){
                                    EE_SP_TOTAL = (((Temp1 * TI_SP) + BS_O_EE_SP) * CL_CL_FA) / (1 - A_A);
                                }
                            } 
                            if(CL_CL_FA != null && A_A != null && Temp2 != null){
                                if(BS_O_EE_CH != null){
                                    EE_CH_TOTAL = (((Temp2 * TI_CH) + BS_O_EE_CH) * CL_CL_FA) / (1 - A_A);
                                }
                                if(BS_O_FA != null){
                                    EE_FA_TOTAL = (((Temp2 * TI_FA) + BS_O_FA) * CL_CL_FA) / (1 - A_A);
                                }
                            }
                            if(C1EE != null && C1EESp != null && C1EECh != null && C1EEFa != null){
                                EE_TOTAL = EE_TOTAL.setScale(2);
                                EE_SP_TOTAL = EE_SP_TOTAL.setScale(2);
                                EE_CH_TOTAL = EE_CH_TOTAL.setScale(2);
                                EE_FA_TOTAL = EE_FA_TOTAL.setScale(2);
                                C1Total = EE_TOTAL * C1EE + EE_SP_TOTAL * C1EESp + EE_CH_TOTAL * C1EECh + EE_FA_TOTAL * C1EEFa;
                                C1Total = C1Total.setScale(2);
                            }

                            //Put all the calculated values in calMap
                            calMap.put('EE_TOTAL', EE_TOTAL);
                            calMap.put('EE_SP_TOTAL', EE_SP_TOTAL);
                            calMap.put('EE_CH_TOTAL', EE_CH_TOTAL);
                            calMap.put('EE_FA_TOTAL', EE_FA_TOTAL);
                            calMap.put('C1Total', C1Total);
                        }
                    }
                }
            }
        }
    }
    
    public void constructProductAttributes(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        System.debug(' In postprocess, output map is '+outMap);
        if(outMap !=null && outMap.size()>0){
            String finalOutPutKey = (String) options.get('outputKey');
            if(finalOutPutKey ==null || finalOutPutKey==''){
                finalOutPutKey='output';
            }
            
            List<Object> outputList = new List<Object> ();
            List<Object> calcList;
            Map<String, Object> calMap;
            String productId;
            outputList = (List<Object>) outMap.get(finalOutPutKey);
            List<String> prodIdList = new List<String> ();
            Integer timeStamp1 = Limits.getCpuTime();
            for(Object keyMap : outputList){
                vlocity_ins.PricingCalculationService.CalculationProcedureResults results = (vlocity_ins.PricingCalculationService.CalculationProcedureResults)keyMap;
                System.debug(' calc results is '+results);
                if(results !=null){                                                           
                    calcList = results.calculationResults;
                    if(calcList !=null && calcList.size()>0){
                        for(integer i =0; i<calcList.size(); i++){
                            calMap = (Map<String, Object>) calcList[i];
                            productId = (String) calMap.get('ProductId');
                            if(productId !=null && productId !=''){
                                prodIdList.add(productId);
                            }
                        }
                    }
                }
            }
            System.debug (' product Id list  is '+prodIdList );
            System.debug(Logginglevel.ERROR, 'Check - in post process, after construct ProdIdList ' + (Limits.getCpuTime() - timeStamp1));
            
            if(prodIdList !=null && prodIdList.size()>0){                
                
                Map<Id, Product2> productMap = new Map<Id, Product2>([SELECT Id, Name, vlocity_ins__Type__c, vlocity_ins__Availability__c, vlocity_ins__SubType__c, 
                                                                      ProductCode, vlocity_ins__MarketSegment__c, Link_Id__c, MetalLevel__c, Network__c, ProductID__c,
                                                                      //[BG] 07/05/2016 Added new fields to the query -- Start
                                                                      Top10Plan__c,ProductDesign__c,CoinsuranceType__c,FundingType__c,Brand__c,
                                                                      ValueProduct__c,VoluntaryProduct__c,EnhancedProduct__c,ClassicProduct__c,BestSelling__c,OrthoCoverage__c,vlocity_ins__EndDate__c
                                                                      //[BG] 07/05/2016 Added new fields to the query -- End
                                                                      from Product2 where Id IN :prodIdList LIMIT 50000]);
                
                System.debug(Logginglevel.ERROR,' product list '  +productMap.size());                
                Integer timeStamp3 = Limits.getCpuTime(); 
                Long actualStartTime3 = DateTime.now().getTime();
                List<vlocity_ins__AttributeAssignment__c> assignmentList = [SELECT Id, Name, vlocity_ins__ObjectId__c,vlocity_ins__ValueDescription__c, vlocity_ins__Value__c, CategoryName__c, AttributeDisplayName__c, vlocity_ins__AttributeCategoryId__r.vlocity_ins__DisplaySequence__c,vlocity_ins__ValueDataType__c,vlocity_ins__AttributeId__r.vlocity_ins__DisplaySequence__c, vlocity_ins__AttributeId__r.IsKey__c 
                                                                            from vlocity_ins__AttributeAssignment__c
                                                                            where vlocity_ins__ObjectId__c IN :prodIdList Order by vlocity_ins__ObjectId__c, vlocity_ins__AttributeCategoryId__r.vlocity_ins__DisplaySequence__c, vlocity_ins__AttributeId__r.vlocity_ins__DisplaySequence__c,AttributeDisplayName__c LIMIT 50000];
                
                System.debug(Logginglevel.ERROR,'Check - in post process, after get attributes, cpuTime '+ (Limits.getCpuTime()-timeStamp3));
                System.debug(Logginglevel.ERROR,'Check - in post process, after get attributes, actual time '+ (DateTime.now().getTime() - actualStartTime3));
                
                Integer timeStamp4 = Limits.getCpuTime(); 
                Long actualStartTime4 = DateTime.now().getTime();
                Map<Id, Object> productAttributeAssignmentMap = new Map<Id, Object> ();
                Attributes att;
                vlocity_ins__AttributeAssignment__c assignment;
                List<Attributes> attList;
                if(assignmentList!=null && assignmentList.size()>0 ){          
                    for(SObject assign : assignmentList){
                        assignment = (vlocity_ins__AttributeAssignment__c) assign;
                        att = new Attributes(assignment.CategoryName__c,
                                             assignment.AttributeDisplayName__c,
                                             assignment.vlocity_ins__Value__c,
                                             assignment.vlocity_ins__AttributeCategoryId__r.vlocity_ins__DisplaySequence__c,
                                             assignment.vlocity_ins__AttributeId__r.vlocity_ins__DisplaySequence__c,
                                             assignment.vlocity_ins__ValueDescription__c,
                                             assignment.vlocity_ins__ValueDataType__c,
                                             assignment.vlocity_ins__AttributeId__r.IsKey__c);
                        
                        productId = assignment.vlocity_ins__ObjectId__c;

                        if (productAttributeAssignmentMap.get(productId) == null)
                        {
                            attList= new List<Attributes> ();
                            attList.add(att);
                            productAttributeAssignmentMap.put(productId, attList);
                        }
                        else
                        {
                            attList= (List<Attributes>) productAttributeAssignmentMap.get(productId);
                            attList.add(att);
                        }
                    }   
                    
                    System.debug(Logginglevel.ERROR, 'Check - in post process, after construct attMap, cputime ' + (Limits.getCpuTime() - timeStamp4));  
                    System.debug(Logginglevel.ERROR, 'Check - in post process, after construct attMap, actual time ' + (DateTime.now().getTime() - actualStartTime4));        
                }
                Integer timeStamp5 = Limits.getCpuTime();
                Long actualStartTime5 = DateTime.now().getTime();
                integer i;
                
                for(Object keyMap : outputList){
                    vlocity_ins.PricingCalculationService.CalculationProcedureResults results = (vlocity_ins.PricingCalculationService.CalculationProcedureResults)keyMap;
                    if(results !=null){                                                                 
                        calcList = results.calculationResults;
                        i=0;
                        if(calcList !=null && calcList.size()>0){
                            for(Object calMap1 : calcList){
                                
                                calMap = (Map<String, Object>) calMap1;
                                productId = (String) calMap.get('ProductId');
                                if(productId !=null && productId !=''){
                                    
                                    //rename the rate to InvididualRate
                                    for(String key : calMap.keySet()){
                                        if(key.contains('IndividualRate')){
                                            calMap.put('IndividualRate', calMap.get(key));                                              
                                            calMap.remove(key);
                                        }
                                        
                                        Product2 prod = productMap.get(productId);
                                        attList = (List<Attributes>) productAttributeAssignmentMap.get(productId);
                                        calMap.put('ProductName', prod.Name);
                                        calMap.put('MarketSegment', prod.vlocity_ins__MarketSegment__c);
                                        calMap.put('ProductType', prod.vlocity_ins__Type__c);                                
                                        calMap.put('ProductSubType', prod.vlocity_ins__SubType__c);
                                        calMap.put('LinkId',prod.Link_Id__c);
                                        calMap.put('MetalLevel', prod.MetalLevel__c);
                                        calMap.put('Network', prod.Network__c);
                                        calMap.put('ContractCode', prod.ProductCode);
                                        calMap.put('BestSelling', prod.BestSelling__c);
                                        calMap.put('Endo/Perio/Oral', prod.OrthoCoverage__c);
                                        //[BG] 07/05/2016 Added new fields to the output - Start
                                        if(prod.Top10Plan__c=='Y'){
                                            calMap.put('Top 10 Plans', 'Y');   
                                        }  
                                        if(prod.CoinsuranceType__c == 'Active'){
                                            calMap.put('Active','Y');
                                        }else{
                                            calMap.put('Passive','Y') ;       
                                        }
                                        
                                        if(prod.ValueProduct__c == 'Y'){
                                            calMap.put('Value','Y') ;    
                                        }
                                        
                                        if(prod.VoluntaryProduct__c == 'Y'){
                                            calMap.put('Voluntary','Y') ;    
                                        }
                                        if(prod.EnhancedProduct__c == 'Y'){
                                            calMap.put('Enhanced','Y') ;    
                                        }
                                        if(prod.ClassicProduct__c == 'Y'){
                                            calMap.put('Classic','Y') ;    
                                        }
                                        
                                        calMap.put('ProductDesign', prod.ProductDesign__c);
                                        calMap.put('FundingType', prod.FundingType__c);
                                        calMap.put('Brand', prod.Brand__c);
                                        //[BG] 07/05/2016 -- End
                                        
                                        calMap.put('attributes',attList);
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                System.debug(Logginglevel.ERROR, 'Check - in post process, after add productattributes to result, cputime ' + (Limits.getCpuTime() - timeStamp5));
                System.debug(Logginglevel.ERROR, 'Check - in post process, after add productattributes to result, actual time ' + (DateTime.now().getTime() - actualStartTime5));
            }              
        }
        
    }
    
    global class Attributes {
        public String categoryName;
        public String name;
        public String value;
        public Decimal categoryDisplaySequence;
        public Decimal attributeDisplaySequence;
        public String description;
        public String dataType;
        public Boolean isKey;
        
        public attributes(String category, String attribute, String attrvalue, Decimal catedisplay, Decimal attdisplay, String valueDesc, String type, Boolean key){
            categoryName=category;
            name=attribute;
            value=attrvalue;
            categoryDisplaySequence = catedisplay;
            attributeDisplaySequence = attdisplay;
            description = valueDesc;
            dataType=type;
            isKey=key;
        }
    }   
    
}