public class footerController {
    public String footer {get;set;}
    
    public footerController(){
       User currentUser =  [Select id,Regional_Brand__c from User Where id =: Userinfo.getUserId()];
       
       if(currentUser.Regional_Brand__c !=null){
           List<Branding__c> brand =  [Select id, 
                                        Regional_Legal_Disclaimer__c, 
                                        Regional_Legal_Disclaimer_2__c, 
                                        Regional_Legal_Disclaimer_3__c,
                                        Regional_Legal_Disclaimer_4__c,
                                        Regional_Legal_Disclaimer_5__c,
                                        Regional_Legal_Disclaimer_6__c,
                                        Regional_Legal_Disclaimer_7__c,
                                        Regional_Legal_Disclaimer_8__c,
                                        Regional_Legal_Disclaimer_9__c
                                      From  Branding__c
                                      Where Name =: currentUser.Regional_Brand__c];
            if(brand!=null && brand.size()>0){
                if(brand[0].Regional_Legal_Disclaimer__c!=null)
                    footer = brand[0].Regional_Legal_Disclaimer__c +' ';
                if(brand[0].Regional_Legal_Disclaimer_2__c!=null)    
                    footer = footer + brand[0].Regional_Legal_Disclaimer_2__c+' '; 
                if(brand[0].Regional_Legal_Disclaimer_3__c!=null)      
                    footer = footer + brand[0].Regional_Legal_Disclaimer_3__c+' ';
                if(brand[0].Regional_Legal_Disclaimer_4__c!=null)                 
                    footer = footer + brand[0].Regional_Legal_Disclaimer_4__c+' ';
                if(brand[0].Regional_Legal_Disclaimer_5__c!=null)                 
                    footer = footer + brand[0].Regional_Legal_Disclaimer_5__c+' ';
                if(brand[0].Regional_Legal_Disclaimer_6__c!=null)                 
                    footer = footer + brand[0].Regional_Legal_Disclaimer_6__c+' ';
                if(brand[0].Regional_Legal_Disclaimer_7__c!=null)                 
                    footer = footer + brand[0].Regional_Legal_Disclaimer_7__c+' ';
                if(brand[0].Regional_Legal_Disclaimer_8__c!=null)                
                    footer = footer + brand[0].Regional_Legal_Disclaimer_8__c+' ';
                if(brand[0].Regional_Legal_Disclaimer_9__c!=null)                 
                    footer = footer + brand[0].Regional_Legal_Disclaimer_9__c;                
            }                                          
       }
    }

}