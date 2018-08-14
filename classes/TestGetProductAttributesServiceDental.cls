@isTest(seeAllData=false)
public class TestGetProductAttributesServiceDental{

	static testMethod void testMethodOne(){

		Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, Object> outMapBad = new Map<String, Object>();
		Map<String, Object> options = new Map<String, Object>();
		String methodname = 'calculate';
	
		String resultString = prepareData();

		Map<String, Object> resultMap = (Map<String,Object>)JSON.deserializeUntyped(resultString);
		List<Object> resultList = (List<Object>)resultMap.get('calculationResults');
		Map<String,Object> aggResults = new Map<String,Object>();
		
		List<vlocity_ins.PricingCalculationService.CalculationProcedureResults> cPRList = new List<vlocity_ins.PricingCalculationService.CalculationProcedureResults>();
		vlocity_ins.PricingCalculationService.CalculationProcedureResults cPR = new vlocity_ins.PricingCalculationService.CalculationProcedureResults(resultList, aggResults);
		cPRList.add(cPR);

		outMap.put('error','OK');
		outMap.put('output',cPRList);

		outMapBad.put('error','OK');
		outMapBad.put('output',cPR);
		
		System.debug(outMap);
		Test.startTest();
			GetProductAttributesServiceDental gPA = new GetProductAttributesServiceDental();
			Boolean success1 = gPA.invokeMethod(methodname, inputMap, outMap, options);
			try{
				Boolean success2 = gPA.invokeMethod(methodname, inputMap, outMapBad, options);
			}
			catch(Exception e){
				//Do nothing
			}
		Test.stopTest();
	}

	static string prepareData(){
		//Define lists
		List<Product2> prodList = new List<Product2>();
		List<vlocity_ins__AttributeCategory__c> attCatList = new List<vlocity_ins__AttributeCategory__c>();
		List<vlocity_ins__Attribute__c> attList = new List<vlocity_ins__Attribute__c>();
		List<vlocity_ins__AttributeAssignment__c> attAssgnmtList = new List<vlocity_ins__AttributeAssignment__c>();

		//Create products
		Product2 p1 = new Product2(Name = 'Value Complete NY-1E voluntary', vlocity_ins__Type__c = 'Dental', vlocity_ins__Availability__c = 'NY', vlocity_ins__SubType__c = 'TBD', ProductCode='2727',
			vlocity_ins__MarketSegment__c = 'Small Group', Link_Id__c = '015550000000l3m', MetalLevel__c = '', Network__c = 'Dental Complete', ProductID__c='', Top10Plan__c = 'Y', ProductDesign__c = '', 
			CoinsuranceType__c = 'Active', FundingType__c = '', Brand__c = 'EBCBS', BestSelling__c = 'N');

		Product2 p2 = new Product2(Name = 'Value Complete NY-1E enhanced', vlocity_ins__Type__c = 'Dental', vlocity_ins__Availability__c = 'NY', vlocity_ins__SubType__c = 'TBD', ProductCode='273X',
			vlocity_ins__MarketSegment__c = 'Small Group', Link_Id__c = '015550000000l3D', MetalLevel__c = '', Network__c = 'Dental Complete', ProductID__c='', Top10Plan__c = 'Y', ProductDesign__c = '', 
			CoinsuranceType__c = 'Passive', FundingType__c = '', Brand__c = 'EBC', BestSelling__c = 'N');

		Product2 p3 = new Product2(Name = 'Value Complete NY-1E classic', vlocity_ins__Type__c = 'Dental', vlocity_ins__Availability__c = 'NY', vlocity_ins__SubType__c = 'TBD', ProductCode='273Y',
			vlocity_ins__MarketSegment__c = 'Small Group', Link_Id__c = '015550000000l3n', MetalLevel__c = '', Network__c = 'Dental Complete', ProductID__c='', Top10Plan__c = 'Y', ProductDesign__c = '', 
			CoinsuranceType__c = 'Active', FundingType__c = '', Brand__c = 'EBC', BestSelling__c = 'N');
		
		prodList.add(p1);
		prodList.add(p2);
		prodList.add(p3);
		insert prodList;	

		//Create Attribute Categories
		vlocity_ins__AttributeCategory__c vAC1 = new vlocity_ins__AttributeCategory__c(Name = 'Dental Deductible', vlocity_ins__ApplicableTypes__c = 'Product2', vlocity_ins__ApplicableSubType__c = 'Product Attribute', vlocity_ins__Code__c = 'DENTALDED', 
			vlocity_ins__DisplaySequence__c = 1004.0, vlocity_ins__IsActive__c = true, vlocity_ins__UIControlType__c = 'On-Off');

		vlocity_ins__AttributeCategory__c vAC2 = new vlocity_ins__AttributeCategory__c(Name = 'Dental Plan', vlocity_ins__ApplicableTypes__c = 'Product2', vlocity_ins__ApplicableSubType__c = 'Product Attribute', vlocity_ins__Code__c = 'DENTALPLAN', 
			vlocity_ins__DisplaySequence__c = 1006.0, vlocity_ins__IsActive__c = true, vlocity_ins__UIControlType__c = 'On-Off');

		attCatList.add(vAC1);
		attCatList.add(vAC2);
		insert attCatList;

		//Create Attributes
		vlocity_ins__Attribute__c vA1 = new vlocity_ins__Attribute__c(Name = 'Deductible', IsKey__c = false, vlocity_ins__ActiveFlg__c= true, vlocity_ins__AttributeCategoryId__c = vAC1.Id, vlocity_ins__Code__c = 'DNTL-DEDuctible', vlocity_ins__DisplaySequence__c = 1.0);
		vlocity_ins__Attribute__c vA2 = new vlocity_ins__Attribute__c(Name = 'Annual Maximum', IsKey__c = false, vlocity_ins__ActiveFlg__c= true, vlocity_ins__AttributeCategoryId__c = vAC2.Id, vlocity_ins__Code__c = 'ATTRIBUTE-157', vlocity_ins__DisplaySequence__c = 1.0);
		vlocity_ins__Attribute__c vA3 = new vlocity_ins__Attribute__c(Name = 'Ortho Lifetime Maximum', IsKey__c = false, vlocity_ins__ActiveFlg__c= true, vlocity_ins__AttributeCategoryId__c = vAC2.Id, vlocity_ins__Code__c = 'ATTRIBUTE-158', vlocity_ins__DisplaySequence__c = 1.0);
		vlocity_ins__Attribute__c vA4 = new vlocity_ins__Attribute__c(Name = 'OON Reimbursement', IsKey__c = false, vlocity_ins__ActiveFlg__c= true, vlocity_ins__AttributeCategoryId__c = vAC2.Id, vlocity_ins__Code__c = 'ATTRIBUTE-160', vlocity_ins__DisplaySequence__c = 1.0);
		attList.add(vA1);
		attList.add(vA2);
		attList.add(vA3);
		attList.add(vA4);
		insert attList;

		//Create Attributes Assignment
		vlocity_ins__AttributeAssignment__c vAA1 = new vlocity_ins__AttributeAssignment__c(Name = 'a1t55000000UQrI', vlocity_ins__ObjectId__c = p1.Id, vlocity_ins__ValueDescription__c = 'Both', vlocity_ins__Value__c = '$50 per Individual or $150 per Family',
			vlocity_ins__ValueDataType__c = 'Text', vlocity_ins__AttributeId__c = vA1.Id, vlocity_ins__AttributeCategoryId__c = vAC1.Id);
		vlocity_ins__AttributeAssignment__c vAA2 = new vlocity_ins__AttributeAssignment__c(Name = 'a1t55000000UQrJ', vlocity_ins__ObjectId__c = p3.Id, vlocity_ins__ValueDescription__c = 'Both', vlocity_ins__Value__c = '$1,500',
			vlocity_ins__ValueDataType__c = 'Text', vlocity_ins__AttributeId__c = vA2.Id, vlocity_ins__AttributeCategoryId__c = vAC2.Id);
		vlocity_ins__AttributeAssignment__c vAA3 = new vlocity_ins__AttributeAssignment__c(Name = 'a1t55000000UQrJ', vlocity_ins__ObjectId__c = p2.Id, vlocity_ins__ValueDescription__c = 'Both', vlocity_ins__Value__c = 'No',
			vlocity_ins__ValueDataType__c = 'Text', vlocity_ins__AttributeId__c = vA3.Id, vlocity_ins__AttributeCategoryId__c = vAC2.Id);
		vlocity_ins__AttributeAssignment__c vAA4 = new vlocity_ins__AttributeAssignment__c(Name = 'a1t55000000UQrJ', vlocity_ins__ObjectId__c = p1.Id, vlocity_ins__ValueDescription__c = 'Both', vlocity_ins__Value__c = 'Maximum Allowable Charge',
			vlocity_ins__ValueDataType__c = 'Text', vlocity_ins__AttributeId__c = vA4.Id, vlocity_ins__AttributeCategoryId__c = vAC2.Id);
		attAssgnmtList.add(vAA1);
		attAssgnmtList.add(vAA2);
		attAssgnmtList.add(vAA3);
		attAssgnmtList.add(vAA4);
		insert attAssgnmtList;

		//Generate resultString
		String resultString = '{"calculationResults":[{"A__A":"0.0368","BS__NO_EE":"22.00939068","BS__NO_FA":"63.21841387","BS__O_EE":0,"BS__O_EE_CH":0,"BS__O_EE_SP":0,"BS__O_FA":0,"C1EE":"6","C1EESp":"7","C1EECh":"1","C1EEFa":"1","PCT__TR":"1.068768771","P__S":"1.034","P__FA":"1.085","S__S_FA":"1.0","CL__CL_FA":"1.0","PlanID":"2727","ProductId":"' + p1.Id + '","QTR":"Q2_2016","MAP_CODE":"101","SIC_MIN":"7373","LIVES":"TenToTwentyFive","PR_COVs":0,"CL":"12","IndividualRate":"213"},{"A__A":"0.0368","BS__NO_EE":"22.00939068","BS__NO_FA":"63.21841387","BS__O_EE":0,"BS__O_EE_CH":0,"BS__O_EE_SP":0,"BS__O_FA":0,"C1EE":"6","C1EESp":"7","C1EECh":"1","C1EEFa":"1","PCT__TR":"1.068768771","P__S":"1.034","P__FA":"1.085","S__S_FA":"1.0","CL__CL_FA":"1.0","PlanID":"273X","ProductId":"' + p2.Id + '","QTR":"Q2_2016","MAP_CODE":"101","SIC_MIN":"7373","LIVES":"TenToTwentyFive","PR_COVs":0,"CL":"12", "IndividualRate":"1223"},{"A__A":"0.0368","BS__NO_EE":"22.00939068","BS__NO_FA":"63.21841387","BS__O_EE":0,"BS__O_EE_CH":0,"BS__O_EE_SP":0,"BS__O_FA":0,"C1EE":"6","C1EESp":"7","C1EECh":"1","C1EEFa":"1","PCT__TR":"1.068768771","P__S":"1.034","P__FA":"1.085","S__S_FA":"1.0","CL__CL_FA":"1.0","PlanID":"2727","ProductId":"' + p1.Id + '","QTR":"Q2_2016","MAP_CODE":"101","SIC_MIN":"7373","LIVES":"TenToTwentyFive","PR_COVs":0,"CL":"12","IndividualRate":"213"},{"A__A":"0.0368","BS__NO_EE":"22.00939068","BS__NO_FA":"63.21841387","BS__O_EE":0,"BS__O_EE_CH":0,"BS__O_EE_SP":0,"BS__O_FA":0,"C1EE":"6","C1EESp":"7","C1EECh":"1","C1EEFa":"1","PCT__TR":"1.068768771","P__S":"1.034","P__FA":"1.085","S__S_FA":"1.0","CL__CL_FA":"1.0","PlanID":"273Y","ProductId":"' + p3.Id + '","QTR":"Q2_2016","MAP_CODE":"101","SIC_MIN":"7373","LIVES":"TenToTwentyFive","PR_COVs":0,"CL":"12","IndividualRate":"2139"}]}';
		
		return resultString;

	}

}