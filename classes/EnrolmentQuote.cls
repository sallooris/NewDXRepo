global with sharing class EnrolmentQuote {

    public EnrolmentQuote() { }

    @RemoteAction
    global static wrapperClass getQLI(string QuoteId) {

        system.debug('Entered remote method'+QuoteId);
        Map<string,list<string>> Products = new Map<string,list<string>>();

        List<QuoteLineItem> QLI = [select id,product2.Link_Id__c,product2.name, product2.vlocity_ins__Type__c, C1_Annual_Total_Premium__c, C1_Total_EE__c, C1_Total_EE_Ch__c, C1_Total_EE_Family__c, C1_Total_EE_Sp__c, product2.ProductCode, product2.FundingType__c from quotelineItem where QuoteId=: QuoteId];    
        
        set<id> productIds = new set<id>{};
        for (QuoteLineItem currenctQuote:QLI) {
            productIds.add(currenctQuote.Product2.Id);
        }

        List<vlocity_ins__AttributeAssignment__c> assignmentList = [SELECT vlocity_ins__ObjectId__c , vlocity_ins__AttributeCategoryId__c, vlocity_ins__AttributeCategoryCode__c, vlocity_ins__CategoryName__c, vlocity_ins__DisplaySequence__c, vlocity_ins__AttributeDisplayName__c, vlocity_ins__Value__c, vlocity_ins__ValueDescription__c
                                                                    from vlocity_ins__AttributeAssignment__c
                                                                    where vlocity_ins__ObjectId__c IN :productIds];

        wrapperClass result = new wrapperClass();
        result.quoteLineItem = QLI;
        result.attributeList = assignmentList;
        return result;
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

    global class wrapperClass{
        List<QuoteLineItem> quoteLineItem;
        List<vlocity_ins__AttributeAssignment__c> attributeList;
    }


}