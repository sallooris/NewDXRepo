public class logoController {

    public String getImageURL() {
        User currentUser =  [Select id,Regional_Brand__c from User Where id =: Userinfo.getUserId()];
        String imageURL='';
        
        if(currentUser.Regional_Brand__c !=null){
            List<Branding__c> brand =  [Select id, Regional_Branding_Logo__c From  Branding__c Where Name =: currentUser.Regional_Brand__c];
            
            if(brand!=null && brand.size()>0){
                imageURL='/servlet/servlet.FileDownload?file=';
                List<document> documentList=[select name from document where DeveloperName =: brand[0].Regional_Branding_Logo__c ];
                if(documentList.size()>0){
                    imageURL=imageURL+documentList[0].id;
                }
            }
        }
        return imageURL;
    }

}