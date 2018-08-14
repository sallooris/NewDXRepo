@isTest
public with sharing class ValuePropControllerTest {
	public static testMethod void ValuePropControllerTest(){
		/**********************************************************
		* Purpose:	Test class for ValuePropController
		* Created:	11/13/2014
		* Author:	Tony Angle
		***********************************************************/
		
        Postal_Code_Score__c pcs=new Postal_Code_Score__c();
        pcs.Postal_Code__c='24091';
        pcs.Rating_Region__c='R1';
        pcs.Score__c=1;
        pcs.Value_Prop__c='Price';
        pcs.Value_Prop_Note__c='Test Note';
		insert pcs;
		
		pcs=new Postal_Code_Score__c();
        pcs.Postal_Code__c='24092';
        pcs.Rating_Region__c='R1';
        pcs.Score__c=2;
        pcs.Value_Prop__c='Price';
        pcs.Value_Prop_Note__c='Test Note';
		insert pcs;
		
		pcs=new Postal_Code_Score__c();
        pcs.Postal_Code__c='24093';
        pcs.Rating_Region__c='R1';
        pcs.Score__c=3;
        pcs.Value_Prop__c='Price';
        pcs.Value_Prop_Note__c='Test Note';
		insert pcs;
		
		pcs=new Postal_Code_Score__c();
        pcs.Postal_Code__c='24094';
        pcs.Rating_Region__c='R1';
        pcs.Score__c=4;
        pcs.Value_Prop__c='Price';
        pcs.Value_Prop_Note__c='Test Note';
		insert pcs;
		
		pcs=new Postal_Code_Score__c();
        pcs.Postal_Code__c='24095';
        pcs.Rating_Region__c='R1';
        pcs.Score__c=5;
        pcs.Value_Prop__c='Price';
        pcs.Value_Prop_Note__c='Test Note';
		insert pcs;
		
		ValuePropController vpc=new ValuePropController();
		
		vpc.postalCode='24091';
		vpc.goSearch();
		vpc.clearSearch();

		vpc.postalCode='24092';
		vpc.goSearch();
		vpc.clearSearch();

		vpc.postalCode='24093';
		vpc.goSearch();
		vpc.clearSearch();
		
		vpc.postalCode='24094';
		vpc.goSearch();
		vpc.clearSearch();

		vpc.postalCode='24095';
		vpc.goSearch();
		vpc.clearSearch();
		
		vpc.postalCode='24151';
		vpc.goSearch();
	}
}