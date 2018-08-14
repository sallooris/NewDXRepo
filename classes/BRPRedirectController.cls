public with sharing class BRPRedirectController {

    public BRPRedirectController(ApexPages.StandardController controller) {

    }

 public PageReference redirectToPage() {
        String appId = ApexPages.currentPage().getParameters().get('Id');
        return new PageReference('javascript:window.close()');
//            return  new PageReference('/'+appId);          
    }
}