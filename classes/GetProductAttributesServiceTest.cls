@isTest(seeAllData = false)
public class GetProductAttributesServiceTest{
    public testmethod static void GetProductAttributesServicTestMethod(){

        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();

        Map<String,Object> CategorySelectionField = new Map<String,Object>();
        String ReqEffDtFormulaMonthly = 'Jan_2017';
        String ReqEffDtFormulaYear = '2017';
        CategorySelectionField.put('ReqEffDtFormula-Monthly', ReqEffDtFormulaMonthly);
        CategorySelectionField.put('ReqEffDtFormula-Year', ReqEffDtFormulaYear);

        inputMap.put('CategorySelection', CategorySelectionField);

        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', HIOS_ID__c='Hos123', MetalLevel__c='Gold', vlocity_ins__EndDate__c=date.parse('12/31/2017'));
        insert prod;

        vlocity_ins__AttributeCategory__c attCategory = new vlocity_ins__AttributeCategory__c();
        attCategory.vlocity_ins__DisplaySequence__c = 1;
        attCategory.Name= 'Tier 1 - Medical Benefits';
        attCategory.vlocity_ins__Code__c = 'code1';
        insert attCategory;

        vlocity_ins__Attribute__c att1 = new vlocity_ins__Attribute__c();
        att1.vlocity_ins__DisplaySequence__c = 1;
        att1.IsKey__c = true;
        att1.vlocity_ins__AttributeCategoryId__c = attCategory.Id;
        insert att1;

        vlocity_ins__Attribute__c att = new vlocity_ins__Attribute__c();
        att.vlocity_ins__DisplaySequence__c = 2;
        att.IsKey__c = true;
        att.vlocity_ins__AttributeCategoryId__c = attCategory.Id;
        insert att;

        vlocity_ins__AttributeAssignment__c attrAssign1 = new vlocity_ins__AttributeAssignment__c();
        attrAssign1.vlocity_ins__ObjectId__c = prod.Id;
        attrAssign1.vlocity_ins__AttributeDisplayNameOverride__c = 'Coinsurance';
        attrAssign1.vlocity_ins__Value__c = '30%';
        attrAssign1.vlocity_ins__ValueDescription__c = 'test';
        attrAssign1.vlocity_ins__ValueDataType__c = 'TEXT';
        attrAssign1.vlocity_ins__AttributeCategoryId__c = attCategory.Id;
        attrAssign1.vlocity_ins__AttributeId__c  = att1.Id;
        insert attrAssign1;

        vlocity_ins__AttributeAssignment__c attrAssign = new vlocity_ins__AttributeAssignment__c();
        attrAssign.vlocity_ins__ObjectId__c = prod.Id;
        attrAssign.vlocity_ins__AttributeDisplayNameOverride__c = 'Coinsurance';
        attrAssign.vlocity_ins__Value__c = '30%';
        attrAssign.vlocity_ins__ValueDescription__c = 'test';
        attrAssign.vlocity_ins__ValueDataType__c = 'TEXT';
        attrAssign.vlocity_ins__AttributeCategoryId__c = attCategory.Id;
        attrAssign.vlocity_ins__AttributeId__c  = att.Id;
        insert attrAssign;

        options.put('productSearchCriteria', 'Id != NULL');

        GetProductAttributesService obj = new GetProductAttributesService();
        obj.invokeMethod('getProducts', inputMap, outMap, options);

        Map<String, Object> calMap = new Map<String, Object>();
        calMap.put('ProductId', prod.Id);
        calMap.put('IndividualRate', '123');
        List<Object> calculationResults = new List<Object>();
        calculationResults.add(calMap);


        vlocity_ins.PricingCalculationService.CalculationProcedureResults results = new vlocity_ins.PricingCalculationService.CalculationProcedureResults(calculationResults, new Map<String, String>());
        results.calculationResults = calculationResults;

        List<Object> listObj = new List<Object>();
        listObj.add(results);
        options.put('outputKey', '');
        outMap.put('output', listObj);
        obj.invokeMethod('calculate', inputMap, outMap, options);

    }
}