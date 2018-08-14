public with sharing class ValuePropController {
	public String postalCode {get;set;}
	public Boolean showResults {get;set;}
	public Decimal score {get;set;}
	public String leadFontColor {get;set;}
	public String leadBackColor {get;set;}
    public Decimal pcs {get;set;}
	public String ValuePropMessage {get;set;}
	public String ValuePropNote {get;set;}
    public String valuePropState {get;set;}
    //public String RSSNews {get;set;} //Google News RSS Link URL
    //public String GeoCode {get;set;} //Google Geocoding URL Link - API Key (joseph.henzi@anthem.com) = AIzaSyBe0I4CFaSyhzrYWrFMk-pCcIfyNxtUrUo
    //public String Census {get;set;} //Census.gov URL String
    //public String Zillow {get;set;} //Zillow URL String - API Key (joseph.henzi@anthem.com) = X1-ZWz1e264tt0mx7_5m9vn
    public list<Top_Plans__c> Top_Plans_HIX {get; set;}
	
	{
		postalCode='';
		showResults=false;
		
	}
	
	public pageReference goSearch(){
		showResults=true;
		String valueCode='';
        
		
        
        
		Postal_Code_Score__c[] pcs=[select postal_code__c,score__c,value_prop__c,rating_region__c,value_prop_note__c,State__c from Postal_Code_Score__c
			where Postal_Code__c=:postalCode];
		
      
       
      // Top_Plans_HIX = [select StateCode__C, ON_HIX__C, Sort_Key__C from Top_Plans__c ORDER BY Sort_Key__C];
        
        
		if(pcs.size()>0){
			score=pcs[0].score__c;
			valuePropMessage=pcs[0].Value_Prop__c;
			valuePropNote=pcs[0].value_prop_note__c;
            valuePropState=pcs[0].State__c;
		}
		else{
			score=3;	
			valueCode='Brand';
			valuePropNote='';
		}
		
		assignColors(score);
        
		Top_Plans_HIX = [select StateCode__C, ON_HIX__C, OFF_HIX__C, Sort_Key__C from Top_Plans__c WHERE StateCode__C=:valuePropState ORDER BY Sort_Key__C];
		
        return null;
        
        
    	
        
	}
	
	public pageReference clearSearch(){
		showResults=false;
		postalCode='';
		
		return null;
	}
	
	private void assignColors(Decimal leadScore){
		if(leadScore==1){
			leadFontColor='White';
			leadBackColor='#336600';
		}
		if(leadScore==2){
			leadFontColor='White';
			leadBackColor='#339933';
		}
		if(leadScore==3){
			leadFontColor='White';
			leadBackColor='#33CC66';
		}
		if(leadScore==4){
			leadFontColor='black';
			leadBackColor='#33FF99';
		}
		if(leadScore==5){
			leadFontColor='Black';
			leadBackColor='#33FFCC';
		}
        
    
	}   

}