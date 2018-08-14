global with sharing class INS_GetProducts implements vlocity_ins.VlocityOpenInterface{
    
    public Map<Id, Product2> productMap = new Map<Id, Product2>();

    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean success = true;

        try{
            if(methodName == 'getProducts') {
                getProducts(inputMap, outMap, options);
            }
        }catch(Exception e){
            System.debug(' exception '+e);
            success = false;
            throw e;
        }
        
        return success;
    }
    public void getProducts(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
            
            String searchPlanType = (String) inputMap.get('PlanType');
            String searchPlanDescription = (String) inputMap.get('PlanDescription');
            String outputPlanType = (String) inputMap.get('PlanType') + 'Plans'; 
            String targetSource = (String) inputMap.get('targetSource'); 
            
            system.debug(targetSource);
            productMap = new Map<Id, Product2>();
            if(targetSource == 'Renewals'){
                List<vlocity_ins__ContractLineItem__c> ContractLineItemList = [Select Id, vlocity_ins__ProductId__c, vlocity_ins__ProductId__r.Name, vlocity_ins__ProductId__r.vlocity_ins__Type__c, vlocity_ins__ProductId__r.vlocity_ins__EffectiveDate__c, vlocity_ins__ProductId__r.Core_Plan_ID__c, vlocity_ins__ProductId__r.ProductCode from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c =:(String)inputMap.get('ContextId') AND vlocity_ins__ProductId__r.vlocity_ins__Type__c =:searchPlanType ];
                system.debug(ContractLineItemList);
                
                Set<Id> SourceProductIds = new Set<Id>();
                for(vlocity_ins__ContractLineItem__c contract: ContractLineItemList){
                    SourceProductIds.add(contract.vlocity_ins__ProductId__c);
                    
                    Product2 prod = new Product2(Id=contract.vlocity_ins__ProductId__c, Name=contract.vlocity_ins__ProductId__r.Name, vlocity_ins__Type__c=contract.vlocity_ins__ProductId__r.vlocity_ins__Type__c, vlocity_ins__EffectiveDate__c=contract.vlocity_ins__ProductId__r.vlocity_ins__EffectiveDate__c, Core_Plan_ID__c=contract.vlocity_ins__ProductId__r.Core_Plan_ID__c, ProductCode=contract.vlocity_ins__ProductId__r.ProductCode, vlocity_ins__StandardPremium__c=null);
                    productMap.put(contract.vlocity_ins__ProductId__c, prod);

                }
                system.debug(SourceProductIds);
                List<vlocity_ins__ProductRelationship__c> ProductList = [Select vlocity_ins__RelatedProductId__c, vlocity_ins__RelatedProductId__r.ProductCode, vlocity_ins__RelatedProductId__r.Name, vlocity_ins__RelatedProductId__r.vlocity_ins__StandardPremium__c, vlocity_ins__RelatedProductId__r.vlocity_ins__EffectiveDate__c, vlocity_ins__RelatedProductId__r.Core_Plan_ID__c, vlocity_ins__RelatedProductId__r.vlocity_ins__Type__c FROM vlocity_ins__ProductRelationship__c where vlocity_ins__Product2Id__c IN :SourceProductIds];
                system.debug(ProductList);
                
                for(vlocity_ins__ProductRelationship__c p:ProductList){
                    Product2 prod = new Product2(Id=p.vlocity_ins__RelatedProductId__c, Name=p.vlocity_ins__RelatedProductId__r.Name, vlocity_ins__Type__c=p.vlocity_ins__RelatedProductId__r.vlocity_ins__Type__c, Core_Plan_ID__c=p.vlocity_ins__RelatedProductId__r.Core_Plan_ID__c, vlocity_ins__EffectiveDate__c=p.vlocity_ins__RelatedProductId__r.vlocity_ins__EffectiveDate__c, ProductCode=p.vlocity_ins__RelatedProductId__r.ProductCode, vlocity_ins__StandardPremium__c=null);
                    productMap.put(p.vlocity_ins__RelatedProductId__c, prod);
                }
            }
            else if(targetSource == 'Enrollment'){
                List<QuoteLineItem> QuoteLineItemList = [Select Id, Product2.Name, Product2.vlocity_ins__Type__c, Product2.Core_Plan_ID__c, Product2.ProductCode, Product2.vlocity_ins__EffectiveDate__c, Product2Id, UnitPrice from QuoteLineItem where QuoteId =:(String)inputMap.get('ContextId') AND Product2.vlocity_ins__Type__c =:searchPlanType ];
                
                Map<Id, QuoteLineItem> contractMap = new Map<Id, QuoteLineItem>();
                system.debug(QuoteLineItemList);
                for(QuoteLineItem p:QuoteLineItemList){
                    Product2 prod = new Product2(Id=p.Product2Id, Name=p.Product2.Name, vlocity_ins__Type__c=p.Product2.vlocity_ins__Type__c, Core_Plan_ID__c=p.Product2.Core_Plan_ID__c, vlocity_ins__EffectiveDate__c=p.Product2.vlocity_ins__EffectiveDate__c, ProductCode=p.Product2.ProductCode, vlocity_ins__StandardPremium__c=p.UnitPrice);
                    productMap.put(p.Product2Id, prod);
                }
            }
            else{
                
                Map<String, Object> constructEffectiveDate = (Map<String,Object>) inputMap.get('coveragePage');
                String EffectiveDateStr = (String)constructEffectiveDate.get('PlanEffectiveDate');
                Date EffectiveDate = Date.parse(EffectiveDateStr);
                system.debug(EffectiveDate);
                productMap = new Map<Id, Product2>([SELECT Id, ProductCode, Name, vlocity_ins__Type__c, Core_Plan_ID__c, vlocity_ins__EffectiveDate__c, vlocity_ins__StandardPremium__c from Product2 WHERE vlocity_ins__Type__c =:searchPlanType AND Description =:searchPlanDescription AND vlocity_ins__EffectiveDate__c =:EffectiveDate LIMIT 5000]);
            }

            List<ProductAttributes> productAttributeList=new List<ProductAttributes>();
            system.debug(productMap);
            
            if(productMap!=null&&productMap.size()>0)
            {
                System.debug(Logginglevel.ERROR,' product list '  +productMap);
                Map<Id,List<Attribute>> attributeMap=new Map<Id,List<Attribute>>();
                for(vlocity_ins__AttributeAssignment__c attr:[SELECT Id, Name, vlocity_ins__ObjectId__c,vlocity_ins__ValueDescription__c, vlocity_ins__Value__c, 
                    CategoryName__c, AttributeDisplayName__c, vlocity_ins__AttributeCategoryId__r.vlocity_ins__DisplaySequence__c,vlocity_ins__ValueDataType__c,
                    vlocity_ins__AttributeDisplaySequence__c from vlocity_ins__AttributeAssignment__c where 
                    vlocity_ins__ObjectId__c IN :productMap.keySet() Order by vlocity_ins__ObjectId__c, vlocity_ins__AttributeCategoryId__r.vlocity_ins__DisplaySequence__c, 
                    vlocity_ins__AttributeDisplaySequence__c,AttributeDisplayName__c LIMIT 50000]){
                    
                    if(attributeMap.containsKey(attr.vlocity_ins__ObjectId__c))
                        attributeMap.get(attr.vlocity_ins__ObjectId__c).add(new Attribute(attr));
                    else
                        attributeMap.put(attr.vlocity_ins__ObjectId__c,new List<Attribute>{new Attribute(attr)});          
                    
                } 
                
                Integer i = 0;
                for(Id prodId: productMap.keyset()){
                    if(attributeMap.containsKey(prodId))
                        productAttributeList.add(new ProductAttributes(productMap.get(prodId), attributeMap.get(prodId)));
                    else
                        productAttributeList.add(new ProductAttributes(productMap.get(prodId)));
                    
                    i++;
                }
            }
            
        outMap.put(outputPlanType, productAttributeList);
 
    }
    private class ProductAttributes{
        public string Name;
        public string ProductCode;
        public string FundingType;
        public string Type;
        public string PlanType;
        public string PlanId;
        public Decimal Price;
        public Id ProductId;
        public Date EffectiveDate;
        public List<Attribute> Attributes;
        public ProductAttributes(Product2 prod,List<Attribute> attributes){
            this.name=prod.name;
            this.Type=prod.vlocity_ins__Type__c;
            this.PlanId=prod.Core_Plan_ID__c;
            this.productCode=prod.ProductCode;
            this.ProductId=prod.Id;
            this.Price=prod.vlocity_ins__StandardPremium__c;
            this.Attributes=attributes;
            this.EffectiveDate=prod.vlocity_ins__EffectiveDate__c;
            
            if(System.Today().year() < prod.vlocity_ins__EffectiveDate__c.year()){
                this.PlanType = 'Recommended Plan';
            }
            else{
                this.PlanType = 'Current Plan';
            }
        }
        public ProductAttributes(Product2 prod){
            this.name=prod.name;
            this.Type=prod.vlocity_ins__Type__c;
            this.PlanId=prod.Core_Plan_ID__c;
            this.productCode=prod.ProductCode;
            this.ProductId=prod.Id;
            this.Price=prod.vlocity_ins__StandardPremium__c;
        }
        
    }
    private class Attribute{
        public string Id;
        public string Description;
        public string Value;
        public string Category;
        public string Name;
        public Decimal CategoryDisplaySequence;
        public Decimal DisplaySequence;
        public string ValueDataType;
        public Attribute(vlocity_ins__AttributeAssignment__c attr){
            this.Id = attr.Name;
            this.Description = attr.vlocity_ins__ValueDescription__c;
            this.Value = attr.vlocity_ins__Value__c;
            this.Category = attr.CategoryName__c;
            this.Name = attr.AttributeDisplayName__c;
            this.CategoryDisplaySequence = attr.vlocity_ins__AttributeCategoryId__r.vlocity_ins__DisplaySequence__c;
            this.DisplaySequence = (attr.vlocity_ins__AttributeDisplaySequence__c != NULL && attr.vlocity_ins__AttributeDisplaySequence__c != '')? Decimal.ValueOf(attr.vlocity_ins__AttributeDisplaySequence__c): 1.0;
            this.ValueDataType = attr.vlocity_ins__ValueDataType__c;
        }
    }
    
    public class ContractCode{
      public String contractCode;
      public ContractCode(String contractCode) {
        this.contractCode=contractCode;
      }
    }
    
    public class ProductRate{
      public Decimal Price;
      public String ID;
      public ProductRate(Decimal Price, String ID) {
        this.Price=Price;
        this.ID=ID;
      }
    }
    
}