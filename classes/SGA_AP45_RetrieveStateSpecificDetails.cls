/***********************************************************************************************
* Class Name   : SGA_AP45_RetrieveStateSpecificDetails
* Created Date : 9/12/2017
* Created By   : IDC Offshore
* Description  : This is used to get the Brand,Product Tag Line,Sales Email ID,Configuration Para
                 from SGA_State_Product_Taglines__c object and pass them to 
                 SGA_C08_StateSpecificDetails component.
************************************************************************************************/
public class SGA_AP45_RetrieveStateSpecificDetails {
    
    public string stateName1{get;set;}
    public string stateName2{get;set;}
    public string stateName3{get;set;}
    public string stateName4{get;set;}
    public string county{get;set;}
    public String quoteId{get;set;} 
    public string appId{get;set;}
    public static final string NY_STATE = 'NY';
    public static final string UNDERSCORE = '_';
    /****************************************************************************************************
    Method Name : getBrand
    Parameters  : NONE
    Return type : String
    Description : Fetches the value for BRAND from SGA_State_Product_Taglines__c.
    ******************************************************************************************************/
    public string getBrand(){
        SGA_State_Product_Taglines__c productTagLineObj = new SGA_State_Product_Taglines__c();
        if(String.isNotBlank(county) && NY_STATE.equalsIgnoreCase(stateName1)){
            stateName1 = stateName1+UNDERSCORE+county;
        }
        List<SGA_State_Product_Taglines__c> productTagLineObjList  = [select Name,Brand_Name__c,Product_Tag_Line__c,Sales_Support_Email__c,Configurable_Paragraph__c From
                                                                SGA_State_Product_Taglines__c Where Name=:stateName1 LIMIT 1];
        if(productTagLineObjList != NULL && !productTagLineObjList.isEmpty()){
            productTagLineObj = productTagLineObjList[0];
        }
            
        return productTagLineObj.Brand_Name__c;
    }
    /****************************************************************************************************
    Method Name : getTagLine
    Parameters  : NONE
    Return type : String
    Description : Fetches the value for TagLine from SGA_State_Product_Taglines__c.
    ******************************************************************************************************/
    public string getTagLine(){
        if(String.isNotBlank(county) && NY_STATE.equalsIgnoreCase(stateName2)){
            stateName2 = stateName2+UNDERSCORE+county;
        }
        SGA_State_Product_Taglines__c productTagLineObj = new SGA_State_Product_Taglines__c();
        List<SGA_State_Product_Taglines__c> productTagLineObjList  = [select Name,Brand_Name__c,Product_Tag_Line__c,Sales_Support_Email__c,Configurable_Paragraph__c From
                                                                SGA_State_Product_Taglines__c Where Name=:stateName2 LIMIT 1];
        if(productTagLineObjList != NULL && !productTagLineObjList.isEmpty()){
            productTagLineObj = productTagLineObjList[0];
        }
            
        return productTagLineObj.Product_Tag_Line__c;
    }
    /****************************************************************************************************
    Method Name : getSalesEmail
    Parameters  : NONE
    Return type : String
    Description : Fetches the value for SalesEmail from SGA_State_Product_Taglines__c.
    ******************************************************************************************************/
    public string getSalesEmail(){
        if(String.isNotBlank(county) && NY_STATE.equalsIgnoreCase(stateName3)){
            stateName3 = stateName3+UNDERSCORE+county;
        }
        SGA_State_Product_Taglines__c productTagLineObj = new SGA_State_Product_Taglines__c();
        List<SGA_State_Product_Taglines__c> productTagLineObjList  = [select Name,Brand_Name__c,Product_Tag_Line__c,Sales_Support_Email__c,Configurable_Paragraph__c From
                                                                SGA_State_Product_Taglines__c Where Name=:stateName3 LIMIT 1];
        if(productTagLineObjList != NULL && !productTagLineObjList.isEmpty()){
            productTagLineObj = productTagLineObjList[0];
        }
            
        return productTagLineObj.Sales_Support_Email__c;
    }
    /****************************************************************************************************
    Method Name : getConfigPara
    Parameters  : NONE
    Return type : String
    Description : Fetches the value for Config Para from SGA_State_Product_Taglines__c.
    ******************************************************************************************************/
    public string getConfigPara(){
        if(String.isNotBlank(county) && NY_STATE.equalsIgnoreCase(stateName4)){
            stateName4 = stateName4+UNDERSCORE+county;
        }
        SGA_State_Product_Taglines__c productTagLineObj = new SGA_State_Product_Taglines__c();
        List<SGA_State_Product_Taglines__c> productTagLineObjList  = [select Name,Brand_Name__c,Product_Tag_Line__c,Sales_Support_Email__c,Configurable_Paragraph__c From
                                                                SGA_State_Product_Taglines__c Where Name=:stateName4 LIMIT 1];
        if(productTagLineObjList != NULL && !productTagLineObjList.isEmpty()){
            productTagLineObj = productTagLineObjList[0];
        }
            
        return productTagLineObj.Configurable_Paragraph__c;
    }
    /****************************************************************************************************
    Method Name : getProductQuoteLineItems
    Parameters  : NONE
    Return type : List<ProductNameCodes>
    Description : Fetches the value for Product Codes and Names for Quote and pass to component
    ******************************************************************************************************/
    public List<ProductNameCodes> getProductQuoteLineItems(){
        List<ProductNameCodes> productNamesCodesList = new List<ProductNameCodes>();
        /*List<QuoteLineItem> qliList = [select Product2.Name,Product2.ProductCode from QuoteLineItem Where QuoteId =:quoteId];
        if(qliList != NULL && !qliList.isEmpty()){
            for(QuoteLineItem qli : qliList){
                productNamesCodesList.add(new ProductNameCodes(qli.Product2.ProductCode,qli.Product2.Name));
            }
        }*/
        List<Application_Product__c> appPrdList = [select Product__r.Name,Product__r.ProductCode from Application_Product__c Where 
                                                Application_Name__c =:appId];
        if(appPrdList != NULL && !appPrdList.isEmpty()){
            for(Application_Product__c appPrd : appPrdList){
                productNamesCodesList.add(new ProductNameCodes(appPrd.Product__r.ProductCode,appPrd.Product__r.Name));
            }
        }
        return productNamesCodesList;
    }
    //Wrapper class to hold the product codes and product names
    public class ProductNameCodes{
        public string productCode{get;set;}
        public string productName{get;set;}
        public ProductNameCodes(String pCode,String pName){
            this.productCode = pCode;
            this.productName = pName;
        }
    }
}