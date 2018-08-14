global with sharing class GetProductAttributesService implements vlocity_ins.VlocityOpenInterface{
/*
* @modifiedBy: Balaji C Garpati(Salesforce Consultant)
* @modifedDate: 07-05-2016
* @modification: Added few columns to the product query, so that they can be filtered from the Small Group Template
*
*/
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean success = true;

        try{
            if(methodName == 'getProducts') {
                Integer timeStamp = Limits.getCpuTime();
                getProducts(inputMap, outMap, options);
                System.debug(Logginglevel.ERROR, 'Check - get products ' + (Limits.getCpuTime() - timeStamp));
                System.debug(Logginglevel.ERROR, 'Check - Total CPU till getProducts end ' + Limits.getCpuTime());
            }
        }catch(Exception e){
            System.debug(' exception '+e);
            success = false;
            throw e;
        }

        try{
            if(methodName == 'calculate') {
                Integer timeStamp = Limits.getCpuTime();
                System.debug(Logginglevel.ERROR, 'Check - Total CPU before post process ' + timeStamp);
                Long actualStartTime = DateTime.now().getTime();
                constructProductAttributes(inputMap, outMap, options);
                System.debug(Logginglevel.ERROR, 'Check - Total CPU for post process ' + Limits.getCpuTime() );
                System.debug(Logginglevel.ERROR, 'Check - post process CPU time ' + (Limits.getCpuTime() - timeStamp));
                System.debug(Logginglevel.ERROR, 'Check - post process actual time' + (DateTime.now().getTime() - actualStartTime));
                System.debug(' output map is '+outMap);
            }
        }catch(Exception e){
            System.debug(' exception '+e);
            success = false;
            throw e;
        }
        return success;

    }

    public void constructProductAttributes(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        System.debug(' In postprocess, output map is '+outMap);
        if(outMap !=null && outMap.size()>0){
            String finalOutPutKey = (String) options.get('outputKey');
            if(finalOutPutKey ==null || finalOutPutKey==''){
                finalOutPutKey='output';
            }
            //System.debug(' output key is '+finalOutPutKey);

            List<Object> outputList = new List<Object> ();
            List<Object> calcList;
            Map<String, Object> calMap;
            String productId;
            outputList = (List<Object>) outMap.get(finalOutPutKey);
            System.debug(' output list is '+outputList);
            List<String> prodIdList = new List<String> ();
            Integer timeStamp1 = Limits.getCpuTime();
            for(Object keyMap : outputList){
                vlocity_ins.PricingCalculationService.CalculationProcedureResults results = (vlocity_ins.PricingCalculationService.CalculationProcedureResults)keyMap;
                System.debug(' calc results is '+results);
                if(results !=null){
                    calcList = results.calculationResults;
                    System.debug('calc List size : '+ calcList.size());
                    if(calcList !=null && calcList.size()>0){
                        for(integer i =0; i<calcList.size(); i++){
                            calMap = (Map<String, Object>) calcList[i];
                            //System.debug('calc map is '+ calMap);
                            productId = (String) calMap.get('ProductId');
                            //System.debug(' produt id is '+productId);
                            if(productId !=null && productId !=''){
                                prodIdList.add(productId);
                            }
                        }
                    }
                }
            }
            //System.debug (' product Id list  is '+prodIdList );
            System.debug(Logginglevel.ERROR, 'Check - in post process, after construct ProdIdList ' + (Limits.getCpuTime() - timeStamp1));
            Integer timeStamp2 = Limits.getCpuTime();
            Long actualStartTime2 = DateTime.now().getTime();
            if(prodIdList !=null && prodIdList.size()>0){

                Map<Id, Product2> productMap = new Map<Id, Product2>([SELECT Id, Name, vlocity_ins__Type__c, vlocity_ins__Availability__c, vlocity_ins__SubType__c,
                                                                      ProductCode, vlocity_ins__MarketSegment__c, Link_Id__c, Link__c, MetalLevel__c, Network__c, ProductID__c,
                                                                      //[BG] 07/05/2016 Added new fields to the query -- Start
                                                                      Top10Plan__c,ProductDesign__c,CoinsuranceType__c,FundingType__c,Brand__c,
                                                                      ValueProduct__c,VoluntaryProduct__c,EnhancedProduct__c,ClassicProduct__c,BestSelling__c,vlocity_ins__EndDate__c
                                                                      //[BG] 07/05/2016 Added new fields to the query -- End
                                                                      from Product2 where Id IN :prodIdList LIMIT 50000]);

                System.debug(Logginglevel.ERROR,'Check - in post process, after get products, cpuTime '+ (Limits.getCpuTime()-timeStamp2));
                System.debug(Logginglevel.ERROR,'Check - in post process, after get products, actual time '+ (DateTime.now().getTime() - actualStartTime2));

                //System.debug(Logginglevel.ERROR,' product list '  +productMap.size());
                Integer timeStamp3 = Limits.getCpuTime();
                Long actualStartTime3 = DateTime.now().getTime();
                List<vlocity_ins__AttributeAssignment__c> assignmentList = [SELECT Id, Name, vlocity_ins__ObjectId__c,vlocity_ins__ValueDescription__c, vlocity_ins__Value__c, CategoryName__c, AttributeDisplayName__c, vlocity_ins__AttributeCategoryId__r.vlocity_ins__DisplaySequence__c,vlocity_ins__ValueDataType__c,vlocity_ins__AttributeId__r.vlocity_ins__DisplaySequence__c, vlocity_ins__AttributeId__r.IsKey__c
                                                                            from vlocity_ins__AttributeAssignment__c
                                                                            where vlocity_ins__ObjectId__c IN :prodIdList Order by vlocity_ins__ObjectId__c, vlocity_ins__AttributeCategoryId__r.vlocity_ins__DisplaySequence__c, vlocity_ins__AttributeId__r.vlocity_ins__DisplaySequence__c,AttributeDisplayName__c LIMIT 50000];

                System.debug(Logginglevel.ERROR,'Check - in post process, after get attributes, cpuTime '+ (Limits.getCpuTime()-timeStamp3));
                System.debug(Logginglevel.ERROR,'Check - in post process, after get attributes, actual time '+ (DateTime.now().getTime() - actualStartTime3));

                //System.debug(Logginglevel.ERROR,' assignment  list '  +assignmentList.size());
                //System.debug(Logginglevel.ERROR, 'Check - in post process, after query prod and attrs ' + (Limits.getCpuTime() - timeStamp2));
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
                        //System.debug(' ProductId is '+productId);
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

                    //System.debug(' attribute  map size '  +productAttributeAssignmentMap.size());
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
                                            //System.debug('map after remove is '+calMap);
                                        }

                                        //}
                                        //if(i==0){

                                        Product2 prod = productMap.get(productId);
                                        attList = (List<Attributes>) productAttributeAssignmentMap.get(productId);
                                        calMap.put('ProductName', prod.Name);
                                        calMap.put('MarketSegment', prod.vlocity_ins__MarketSegment__c);
                                        calMap.put('ProductType', prod.vlocity_ins__Type__c);
                                        calMap.put('ProductSubType', prod.vlocity_ins__SubType__c);
                                        calMap.put('LinkId',prod.Link_Id__c);
                                        calMap.put('Link',prod.Link__c);
                                        calMap.put('MetalLevel', prod.MetalLevel__c);
                                        calMap.put('Network', prod.Network__c);
                                        calMap.put('ContractCode', prod.ProductCode);
                                        calMap.put('BestSelling', prod.BestSelling__c);
                                        calMap.put('EndDate', prod.vlocity_ins__EndDate__c);
                                        //[BG] 07/05/2016 Added new fields to the output - Start
                                        if(prod.Top10Plan__c=='Y'){
                                            calMap.put('Top 10 Plan', 'Y');
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



                                        //  calMap.put('CoinsuranceType', prod.CoinsuranceType__c);
                                        calMap.put('ProductDesign', prod.ProductDesign__c);
                                        calMap.put('FundingType', prod.FundingType__c);
                                        calMap.put('Brand', prod.Brand__c);
                                        //[BG] 07/05/2016 -- End

                                        calMap.put('attributes',attList);
                                        //system.debug('*******');
                                        //system.debug('calMap '+calMap);
                                    }
                                    //i++;


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

    public void getProducts(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        String searchSpec = (String) options.get('productSearchCriteria');
        String prodquery = 'SELECT Id, ProductCode';
        prodquery +=' from Product2';
        if(searchSpec !=null && searchSpec!=''){
            if(!searchSpec.contains('vlocity_ins__EndDate__c')){
                Map<String,Object> CategorySelectionField = (Map<String,Object>) inputMap.get('CategorySelection');
                String MONTHYEARField = (String)CategorySelectionField.get('ReqEffDtFormula-Monthly');
                String YEARField = (String)CategorySelectionField.get('ReqEffDtFormula-Year');

                System.debug('The YEARField is' + YEARField);
                if(YEARField == null){
                    System.debug('The YEARField is null');
                    CategorySelectionField.put('ReqEffDtFormula-Year', MONTHYEARField.split('_')[1]);
                    outMap.put('CategorySelection', CategorySelectionField);
                }
                else{
                    System.debug('The YEARField is not null');
                    CategorySelectionField.put('ReqEffDtFormula-Year', MONTHYEARField.split('_')[1]);
                }

                prodquery +=' where '+ searchSpec + '  AND vlocity_ins__EndDate__c='+MONTHYEARField.split('_')[1]+'-12-31';
                System.debug('The inputMap is' + inputMap);
            }
            else{
                prodquery +=' where '+searchSpec;
            }

            System.debug('The searchSpec is' + searchSpec);
            System.debug('The prodquery is' + prodquery);
        }

        prodquery +=' LIMIT 50000';

        //System.debug(' prod query is '+prodquery);
        SObject [] productList;

        try{
            productList = database.query(prodquery);
        }catch(Exception e){
            System.debug(Logginglevel.ERROR, +e);
            throw e;
        }

        System.debug(Logginglevel.ERROR,' product list '  +productList.size());

        if(productList !=null && productList.size()>0){
            List<PlanInfo> planList = new List<PlanInfo> ();
            for(SObject prod : productList){
                Product2 product = (Product2) prod;
                PlanInfo plan = new PlanInfo (product.ProductCode, product.Id);
                planList.add(plan);
            }
            //System.debug(' plan list '  +planList);
            outMap.put('plan', planList);

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

    global class PlanInfo {
        String PlanID;
        String ProductId;

        public PlanInfo (String code, String prodId)
        {
            ProductId = prodId;
            PlanID=code;
        }
    }

}