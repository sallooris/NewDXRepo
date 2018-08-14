global with sharing class CMN_GetRenewalProducts implements vlocity_ins.VlocityOpenInterface{
    string name;
    public static final String ALTERNATE_PLAN ='Recommended Plans';
    public static final String CURRENT_PLAN ='Current Plan';
    public static final String RENEWAL_PLAN ='Available Plans';
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
        Map<String,Object> contractCodeMap = (Map<String,Object>) inputMap.get('contractCodeList');

        List<Object> CurrentRenewalsList = (List<Object>)contractCodeMap.get('CurrentRenewals');
        List<Object> AllRenewalsObjList = (List<Object>)contractCodeMap.get('AllRenewals');
        
        system.debug(AllRenewalsObjList);
        system.debug(CurrentRenewalsList);
        Map<String,List<String>> queryMap = new  Map<String,List<String>>();
        queryMap.put(RENEWAL_PLAN, new List<String>());

         queryMap.put(CURRENT_PLAN, new List<String>());
         for(Object a: CurrentRenewalsList){
             Map<String,Object> aa=(Map<String,Object>)a;
            queryMap.get(CURRENT_PLAN).add((String)(aa.get('contractCode')));
         }  
        
        List<String> AlternateRenewals = new List<String>();
        queryMap.put(ALTERNATE_PLAN, new List<String>());
        for(vlocity_ins__ProductRelationship__c a: [Select vlocity_ins__RelatedProductId__r.ProductCode from vlocity_ins__ProductRelationship__c where vlocity_ins__Product2Id__r.ProductCode IN: queryMap.get(CURRENT_PLAN)]){
            queryMap.get(ALTERNATE_PLAN).add(a.vlocity_ins__RelatedProductId__r.ProductCode);
        }

       List<String> AllRenewals = new List<String>();
       for(Object a: AllRenewalsObjList){
          Map<String,Object> aa=(Map<String,Object>)a;
          queryMap.get(RENEWAL_PLAN).add((String)(aa.get('contractCode')));
       }
        
        String searchSpec = (String) options.get('productSearchCriteria');
      
        Map<Integer,String> productSortMap=new Map<Integer,String>{1=>ALTERNATE_PLAN,2=>CURRENT_PLAN,3=>RENEWAL_PLAN};
        List<ProductAttributes> productAttributeList=new List<ProductAttributes>();
        
        for(Integer i:productSortMap.keyset()){
            string queryset=productSortMap.get(i);
            productMap = new Map<Id, Product2>();
            productMap = new Map<Id, Product2>([SELECT Id, ProductCode, Name, vlocity_ins__Type__c, vlocity_ins__StandardPremium__c from Product2 WHERE ProductCode IN :queryMap.get(queryset) LIMIT 5000]);
            system.debug(productMap);
            
            if(productMap!=null&&productMap.size()>0)
            {
                System.debug(Logginglevel.ERROR,' product list '  +productMap);
                Map<Id,List<Attribute>> attributeMap=new Map<Id,List<Attribute>>();
                for(vlocity_ins__AttributeAssignment__c attr:[SELECT Id, Name, vlocity_ins__ObjectId__c,vlocity_ins__ValueDescription__c, vlocity_ins__Value__c, 
                    vlocity_ins__CategoryName__c
                    , vlocity_ins__AttributeDisplayName__c, vlocity_ins__AttributeCategoryId__r.vlocity_ins__DisplaySequence__c,vlocity_ins__ValueDataType__c,
                    vlocity_ins__AttributeDisplaySequence__c from vlocity_ins__AttributeAssignment__c where 
                    vlocity_ins__ObjectId__c IN :productMap.keySet() Order by vlocity_ins__ObjectId__c, vlocity_ins__AttributeCategoryId__r.vlocity_ins__DisplaySequence__c, 
                    vlocity_ins__AttributeDisplaySequence__c,vlocity_ins__AttributeDisplayName__c LIMIT 50000]){
                    
                    if(attributeMap.containsKey(attr.vlocity_ins__ObjectId__c))
                        attributeMap.get(attr.vlocity_ins__ObjectId__c).add(new Attribute(attr));
                    else
                        attributeMap.put(attr.vlocity_ins__ObjectId__c,new List<Attribute>{new Attribute(attr)});          
                    
                }    
                for(Id prodId: productMap.keyset()){
                    if(attributeMap.containsKey(prodId))
                        productAttributeList.add(new ProductAttributes(productMap.get(prodId), attributeMap.get(prodId), queryset));
                    else
                        productAttributeList.add(new ProductAttributes(productMap.get(prodId), queryset));
                }
            }
        }
        outMap.put('MedicalPlans', productAttributeList);
 
    }
    private class ProductAttributes{
        public string Name;
        public string ProductCode;
        public string FundingType;
        public string Type;
        public string RenewalType;
        public Decimal Price;
        public Id ProductId;
        public List<Attribute> Attributes;
        public ProductAttributes(Product2 prod,List<Attribute> attributes, string RenewalType){
            this.name=prod.name;
            this.Type=prod.vlocity_ins__Type__c;
            this.productCode=prod.ProductCode;
            this.ProductId=prod.Id;
            this.RenewalType=RenewalType;
            this.Price=prod.vlocity_ins__StandardPremium__c;
            this.Attributes=attributes;
        }
        public ProductAttributes(Product2 prod, string RenewalType){
            this.name=prod.name;
            this.productCode=prod.ProductCode;
            this.ProductId=prod.Id;
            this.Price=prod.vlocity_ins__StandardPremium__c;
            this.RenewalType=RenewalType;
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
            this.Category = attr.vlocity_ins__CategoryName__c;
            this.Name = attr.vlocity_ins__AttributeDisplayName__c;
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
}