public class BRPSendQuotePDFToSGC  {

public boolean GenerateQuotePDF(String quoteId){


    
    String pdfContent = '<HTML><body>';
    Quote quote = null;
    boolean success = false;
    try
    {
        quote = getQuoteDetails(quoteId);
        if(quote != null)
        {        
            Account accnt = getAccountDetails(quote.AccountId);
            List<QuoteLineItem> quoteLineItemList = getQuoteLineDetails(quoteId);
            
 //           pdfContent = pdfContent + '<H2>Quote Generated For "'+accnt.Name+'"</H2><TABLE><TR><TD></TD></TR><TR><TD></TD></TR></TABLE>';
            if(accnt.SicDesc== null) accnt.SicDesc= '';            
            if(quote.Dental_Rate_Guarantee__c== null) quote.Dental_Rate_Guarantee__c= '';
            if(quote.Vision_Rate_Guarantee__c== null) quote.Vision_Rate_Guarantee__c= '';
            if(quote.Dental_Prior_Comparable_Coverage__c== null) quote.Dental_Prior_Comparable_Coverage__c= ''; else
            if(quote.Dental_Prior_Comparable_Coverage__c!= null && quote.Dental_Prior_Comparable_Coverage__c != '0') quote.Dental_Prior_Comparable_Coverage__c= 'Yes';
                else quote.Dental_Prior_Comparable_Coverage__c= 'No';
            
            if(quote.Total_Eligible_Employees__c == null) quote.Total_Eligible_Employees__c = '';
                                        
            pdfContent = pdfContent + '<font face="verdana" color="white" size="3"><TABLE border="0"><TR bgcolor="#496969"><TD align = "center" width="100%"><b> QUOTE DETAILS FOR BACK OFFICE</b></TD></TR></font><font face="verdana" color="white" size="1"><TR bgcolor="#496969"><TD align = "right" width="100%"> Generated in Salesforce-Vlocity</TD></TR></TABLE>'; 
            pdfContent = pdfContent + '</font><font face="verdana" color="black" size="2"><TABLE border="1"><TR><TD bgcolor="#f0f5f5">Account Name</TD><TD>' + quote.BillingName+ '</TD>';
            pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Employer EIN</TD><TD>' + accnt.Employer_EIN__c+ '</TD></TR>';     
            pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">SIC Code</TD><TD>' + accnt.Sic + '</TD>';
            pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">SIC Code Description</TD><TD>' + getSICName(accnt.Sic)+ '</TD></TR>';          
            pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Quote Number</TD><TD>' + quote.QuoteNumber+ '</TD>';
            pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">SFDC Quote Id</TD><TD>' + quote.Id+ '</TD></TR>';
            pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Quoted Zip code</TD><TD>' + quote.BillingPostalCode+ '</TD>';
            pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Brand</TD><TD>' + quote.Brand__c+ '</TD></TR>';
            String dateInStringString = (quote.vlocity_ins__EffectiveDate__c).format();
            Datetime thisDT = quote.CreatedDate;
            String createdDate = thisDT.format('yyyy-MM-dd HH:mm:ss', 'EST');
            
            pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Effective Date</TD><TD>' + dateInStringString + '</TD>';
            pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Total Eligible Employees</TD><TD>' + quote.Total_Eligible_Employees__c + '</TD></TR>';            
            pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Number of Products Quoted</TD><TD>' + quote.LineItemCount+ '</TD>';
            pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Coverage Options</TD><TD>' + quote.Coverage_Options__c+ '</TD></TR>';
            pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Created Date</TD><TD>' + createdDate+ ' EST</TD>';
            pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Originated By</TD><TD>' + quote.CreatedBy.Name+ '</TD></TR></TABLE>';
 
            if(quoteLineItemList != null){
            boolean medProd = false;
            boolean denProd = false;
            boolean visProd = false;
            for(QuoteLineItem quoteLineItem : quoteLineItemList)
            {   
                if(quoteLineItem.Base_EE_Child__c == null) quoteLineItem.Base_EE_Child__c = 0;
                if(quoteLineItem.Base_EE_Family__c == null) quoteLineItem.Base_EE_Child__c = 0;
                if(quoteLineItem.Base_EE_Spouse__c == null) quoteLineItem.Base_EE_Child__c = 0;
                if(quoteLineItem.Base_EE__c == null) quoteLineItem.Base_EE_Child__c = 0;               
                if(quoteLineItem.C1_Annual_Total_Premium__c == null) quoteLineItem.Base_EE_Child__c = 0;
                if(quoteLineItem.C1_Emp_Contrib_Amt__c == null) quoteLineItem.Base_EE_Child__c = 0;
                if(quoteLineItem.C1_Total_EE_Ch__c == null) quoteLineItem.Base_EE_Child__c = 0;
                if(quoteLineItem.C1_Total_EE_Family__c == null) quoteLineItem.Base_EE_Child__c = 0;
                if(quoteLineItem.C1_Total_EE_Sp__c == null) quoteLineItem.Base_EE_Child__c = 0;
                if(quoteLineItem.C1_Total_EE__c == null) quoteLineItem.Base_EE_Child__c = 0;
                if(quoteLineItem.C2_Annual_Total_Premium__c == null) quoteLineItem.Base_EE_Child__c = 0;
                if(quoteLineItem.C2_Emp_Contrib_Amt__c == null) quoteLineItem.Base_EE_Child__c = 0;
                if(quoteLineItem.C2_Total_EE_Ch__c == null) quoteLineItem.Base_EE_Child__c = 0;
                if(quoteLineItem.Class_1_Number_EE_Child__c == null) quoteLineItem.Class_1_Number_EE_Child__c = 0;
                if(quoteLineItem.Class_1_Number_EE_Family__c == null) quoteLineItem.Class_1_Number_EE_Family__c = 0;
                if(quoteLineItem.Class_1_Number_EE_Spouse__c == null) quoteLineItem.Class_1_Number_EE_Spouse__c = 0;
                if(quoteLineItem.Class_1_Number_EE__c == null) quoteLineItem.Class_1_Number_EE__c = 0;
                if(quoteLineItem.Class_1_Total__c == null) quoteLineItem.Class_1_Total__c = 0;
                if(quoteLineItem.Class_2_Number_EE_Child__c == null) quoteLineItem.Class_2_Number_EE_Child__c = 0;
                if(quoteLineItem.Class_2_Number_EE_Family__c == null) quoteLineItem.Class_2_Number_EE_Family__c = 0;
                if(quoteLineItem.Class_2_Number_EE_Spouse__c == null) quoteLineItem.Class_2_Number_EE_Spouse__c = 0;
                if(quoteLineItem.Class_2_Number_EE__c == null) quoteLineItem.Class_2_Number_EE__c = 0;
                if(quoteLineItem.Class_2_Total__c == null) quoteLineItem.Class_2_Total__c = 0;
                if(quoteLineItem.Class_3_Number_EE_Child__c == null) quoteLineItem.Class_3_Number_EE_Child__c = 0;
                if(quoteLineItem.Class_3_Number_EE_Family__c == null) quoteLineItem.Class_3_Number_EE_Family__c = 0;
                if(quoteLineItem.Class_3_Number_EE_Spouse__c == null) quoteLineItem.Class_3_Number_EE_Spouse__c = 0;
                if(quoteLineItem.Class_3_Number_EE__c == null) quoteLineItem.Class_3_Number_EE__c = 0;
                if(quoteLineItem.Class_3_Total__c == null) quoteLineItem.Class_3_Total__c = 0;
                if(quoteLineItem.Class_Selected__c == null) quoteLineItem.Class_Selected__c = ' ';
                if(quoteLineItem.Discount == null) quoteLineItem.Discount = 0;
                if(quoteLineItem.Employer_Contribution_Percent__c == null) quoteLineItem.Employer_Contribution_Percent__c = 0;
                if(quoteLineItem.Quantity == null) quoteLineItem.Quantity = 0;
                if(quoteLineItem.UnitPrice == null) quoteLineItem.UnitPrice = 0;  
                if(quoteLineItem.Product2.vlocity_ins__Type__c!= null) {
                    if(quoteLineItem.Product2.vlocity_ins__Type__c.equalsignorecase('MEDICAL')) medProd = true;
                    else if(quoteLineItem.Product2.vlocity_ins__Type__c.equalsignorecase('DENTAL')) denProd = true;
                    else if(quoteLineItem.Product2.vlocity_ins__Type__c.equalsignorecase('VISION')) visProd = true;
                 }
            }
            if (medProd) pdfContent = printMedicalProducts(pdfContent,quoteLineItemList,quote);
            if (denProd) pdfContent = printDentalProducts(pdfContent,quoteLineItemList,quote);
            if (visProd) pdfContent = printVisionProducts(pdfContent,quoteLineItemList,quote);
        }
            pdfContent = pdfContent + '</font></body></HTML>';
 //           System.debug('pdfContent - '+pdfContent);
            success = attachPDF(quote,pdfContent);
        }
    }catch(Exception e)
    {
        System.debug(e.getMessage());
        success = false;
    }     
    return success;  
}
public String printMedicalProducts(String pdfContent,List<QuoteLineItem> quoteLineItemList, Quote quote){

            pdfContent = pdfContent + '</font><font face="verdana" color="white" size="2"><TABLE><TR><TD></TD></TR><TR><TD></TD></TR></TABLE><TABLE border="1"><TR bgcolor="#496969"><TD align = "center" width="100%"><b> MEDICAL PLANS</b></TD></TR></TABLE></font><font face="verdana" color="black" size="2">';

            for(QuoteLineItem quoteLineItem : quoteLineItemList)
            {   
                if(quoteLineItem.Product2.vlocity_ins__Type__c.equalsignorecase('MEDICAL')){
                    pdfContent = pdfContent + '<TABLE border="1">';
                    pdfContent = pdfContent + '<TR bgcolor="#b4cbcb"><TD align = "left" width="100%"><b> '+quoteLineItem.Product2.Name +', '+quoteLineItem.Product2.ProductCode+'</b></TD></TR></TABLE>';                             
                    pdfContent = pdfContent + '<TABLE border="1"> <TR><TD bgcolor="#f0f5f5">Sales Price</TD><TD>' + currency(quoteLineItem.UnitPrice+'')+ '</TD>';
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 1 Total</TD><TD>' + currency(quoteLineItem .Class_1_Total__c+'')+ '</TD></TR>';
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 2 Total</TD><TD>' + currency(quoteLineItem.Class_2_Total__c+'')+ '</TD>';
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 3 Total </TD><TD>' + currency(quoteLineItem .Class_3_Total__c+'')+ '</TD></TR>';           
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Classes Selected</TD><TD>' + quoteLineItem .Class_Selected__c+ '</TD>';
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Employer Contribution %</TD><TD>' + quoteLineItem.Employer_Contribution_Percent__c+ '</TD></TR>';            
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Base EE </TD><TD>' + currency(quoteLineItem .Base_EE__c+'')+ '</TD>';
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Base EE + Child(ren)</TD><TD>' + currency(quoteLineItem .Base_EE_Child__c+'')+ '</TD></TR>';           
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Base EE + Spouse</TD><TD>' + currency(quoteLineItem .Base_EE_Spouse__c+'')+ '</TD>';
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Base EE + Family</TD><TD>' + currency(quoteLineItem .Base_EE_Family__c+'')+ '</TD></TR>';
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Number EE  </TD><TD>' + quoteLineItem .Class_1_Number_EE__c+ '</TD>';
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 1 Number EE + Child(ren)</TD><TD>' + quoteLineItem .Class_1_Number_EE_Child__c+ '</TD></TR>';              
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Number EE + Spouse</TD><TD>' + quoteLineItem .Class_1_Number_EE_Spouse__c+ '</TD>';
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 1 Number EE + Family</TD><TD>' + quoteLineItem .Class_1_Number_EE_Family__c+ '</TD></TR>';             
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Total EE </TD><TD>' + currency(quoteLineItem .C1_Total_EE__c+'')+ '</TD>';
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 1 Total EE + Child(ren)</TD><TD>' + currency(quoteLineItem .C1_Total_EE_Ch__c+'')+ '</TD></TR>';              
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Total EE + Spouse</TD><TD>' + currency(quoteLineItem .C1_Total_EE_Sp__c+'')+ '</TD>';    
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 1 Total EE + Family</TD><TD>' + currency(quoteLineItem .C1_Total_EE_Family__c+'')+ '</TD></TR>';               
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Annual Total Premium </TD><TD>' + currency(quoteLineItem .C2_Annual_Total_Premium__c+'')+ '</TD>';
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 1 Emp Contrib Amt</TD><TD>' + quoteLineItem .C2_Emp_Contrib_Amt__c+ '</TD></TR>';            
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 2 Number EE</TD><TD>' + quoteLineItem .Class_2_Number_EE__c+ '</TD>';   
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 2 Number EE + Child(ren)</TD><TD>' + quoteLineItem .Class_2_Number_EE_Child__c+ '</TD></TR>';             
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 2 Number EE + Spouse</TD><TD>' + quoteLineItem .Class_2_Number_EE_Spouse__c+ '</TD>';  
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 2 Number EE + Family</TD><TD>' + quoteLineItem .Class_2_Number_EE_Family__c+ '</TD></TR>';             
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 2 Total EE </TD><TD>' + currency(quoteLineItem .C2_Total_EE__c+'')+ '</TD>';
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 2 Total EE + Child(ren)</TD><TD>' + currency(quoteLineItem .C2_Total_EE_Ch__c+'')+ '</TD></TR>';               
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 2 Total EE + Spouse</TD><TD>' + currency(quoteLineItem .C2_Total_EE_Sp__c+'')+ '</TD>';    
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 2 Total EE + Family</TD><TD>' + currency(quoteLineItem .C2_Total_EE_Family__c+'')+ '</TD></TR>';               
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 2 Annual Total Premium </TD><TD>' + currency(quoteLineItem .C3_Annual_Total_Premium__c+'')+ '</TD>';
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 2 Emp Contrib Amt</TD><TD>' + currency(quoteLineItem .C2_Emp_Contrib_Amt__c+'')+ '</TD></TR>';             
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 3 Number EE</TD><TD>' + quoteLineItem .Class_3_Number_EE__c+ '</TD>';   
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 3 Number EE + Child(ren)</TD><TD>' + quoteLineItem .Class_3_Number_EE_Child__c+ '</TD></TR>';              
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 3 Number EE + Spouse</TD><TD>' + quoteLineItem .Class_3_Number_EE_Spouse__c+ '</TD>';  
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 3 Number EE + Family</TD><TD>' + quoteLineItem .Class_3_Number_EE_Family__c+ '</TD></TR>';             
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 3 Total EE</TD><TD>' + currency(quoteLineItem .C3_Total_EE__c+'')+ '</TD>'; 
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 3 Total EE + Child(ren)</TD><TD>' + currency(quoteLineItem .C3_Total_EE_Ch__c+'')+ '</TD></TR>';               
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 3 Total EE + Sp</TD><TD>' + currency(quoteLineItem .C3_Total_EE_Sp__c+'')+ '</TD>';    
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 3 Total EE + Family</TD><TD>' + currency(quoteLineItem .C3_Total_EE_Family__c+'')+ '</TD></TR>';               
                    pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 3 Annual Total Premium</TD><TD>' + currency(quoteLineItem .C3_Annual_Total_Premium__c+'')+ '</TD>'; 
                    pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 3 Emp Contrib Amt</TD><TD>' + currency(quoteLineItem .C3_Emp_Contrib_Amt__c+'')+ '</TD></TR>';                             
                    pdfContent = pdfContent + '</TABLE>'; 
                    }
        }
        return pdfContent;
}
public String printDentalProducts(String pdfContent,List<QuoteLineItem> quoteLineItemList, Quote quote){
            pdfContent = pdfContent + '</font><font face="verdana" color="white" size="2"><TABLE><TR><TD></TD></TR><TR><TD></TD></TR></TABLE><TABLE border="1"><TR bgcolor="#496969"><TD align = "center" width="100%"><b> DENTAL PLANS</b></TD></TR></TABLE>';

            for(QuoteLineItem quoteLineItem : quoteLineItemList)
            {   
                if(quoteLineItem.Product2.vlocity_ins__Type__c.equalsignorecase('DENTAL')){

                pdfContent = pdfContent + '<TABLE border="1">';
                pdfContent = pdfContent + '</font><font face="verdana" color="black" size="2"><TR bgcolor="#b4cbcb"><TD align = "left" width="100%"><b> '+quoteLineItem.Product2.Name +', '+quoteLineItem.Product2.ProductCode+'</b></TD></TR></TABLE>';                             
                pdfContent = pdfContent + '<TABLE border="1">'; 
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Base EE </TD><TD>' + currency(quoteLineItem .Base_EE__c+'')+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Bundled EE</TD><TD>' + currency(quoteLineItem .Dental_Bundled_Price_EE__c+'')+ '</TD></TR>';           
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Base EE + Spouse</TD><TD>' + currency(quoteLineItem .Base_EE_Spouse__c+'')+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Bundled EE + Spouse</TD><TD>' + currency(quoteLineItem .Dental_Bundled_Price_EE_Sp__c+'')+ '</TD></TR>';
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Base EE + Child(ren) </TD><TD>' + currency(quoteLineItem .Base_EE_Child__c+'')+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Bundled EE + Child(ren)</TD><TD>' + currency(quoteLineItem .Dental_Bundled_Price_EE_Ch__c+'')+ '</TD></TR>';           
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Base EE + Family</TD><TD>' + currency(quoteLineItem .Base_EE_Family__c+'')+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Bundled EE + Family</TD><TD>' + currency(quoteLineItem .Dental_Bundled_Price_EE_Fa__c+'')+ '</TD></TR>';

                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Number EE  </TD><TD>' + quoteLineItem .Class_1_Number_EE__c+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Number EE + Child(ren)</TD><TD>' + quoteLineItem .Class_1_Number_EE_Child__c+ '</TD></TR>';              
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Number EE + Spouse</TD><TD>' + quoteLineItem .Class_1_Number_EE_Spouse__c+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Number EE + Family</TD><TD>' + quoteLineItem .Class_1_Number_EE_Family__c+ '</TD></TR>';             
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Dental Rate Guarantee</TD><TD>' + quote.Dental_Rate_Guarantee__c+ ' Months</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Prior Comparable Coverage (Dental)</TD><TD>' + quote.Dental_Prior_Comparable_Coverage__c+ ' </TD></TR>';           


/*
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Total</TD><TD>' + currency(quoteLineItem .Class_1_Total__c+'')+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 2 Total</TD><TD>' + currency(quoteLineItem.Class_2_Total__c+'')+ '</TD></TR>';                
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Number EE  </TD><TD>' + quoteLineItem.Class_1_Number_EE__c+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 2 Number EE</TD><TD>' + quoteLineItem.Class_2_Number_EE__c+ '</TD></TR>';   
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Number EE + Spouse</TD><TD>' + quoteLineItem.Class_1_Number_EE_Spouse__c+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 2 Number EE + Spouse</TD><TD>' + quoteLineItem.Class_2_Number_EE_Spouse__c+ '</TD></TR>';  
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Number EE + Child</TD><TD>' + quoteLineItem.Class_1_Number_EE_Child__c+ '</TD>';              
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 2 Number EE + Child</TD><TD>' + quoteLineItem.Class_2_Number_EE_Child__c+ '</TD></TR>';             
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Number EE + Family</TD><TD>' + quoteLineItem.Class_1_Number_EE_Family__c+ '</TD>';             
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 2 Number EE + Family</TD><TD>' + quoteLineItem.Class_2_Number_EE_Family__c+ '</TD></TR>';    
                */         
                pdfContent = pdfContent + '</TABLE>'; 
                }
        }
        return pdfContent;
}
public String printVisionProducts(String pdfContent,List<QuoteLineItem> quoteLineItemList, Quote quote){
            pdfContent = pdfContent + '</font><font face="verdana" color="white" size="2"><TABLE><TR><TD></TD></TR><TR><TD></TD></TR></TABLE><TABLE border="1"><TR bgcolor="#496969"><TD align = "center" width="100%"><b> VISION PLANS</b></TD></TR></TABLE></font><font face="verdana" color="black" size="2">';

            for(QuoteLineItem quoteLineItem : quoteLineItemList)
            {   
                if(quoteLineItem.Product2.vlocity_ins__Type__c.equalsignorecase('VISION')){

                pdfContent = pdfContent + '<TABLE border="1">';
                pdfContent = pdfContent + '<TR bgcolor="#b4cbcb"><TD align = "left" width="100%"> <b>'+quoteLineItem.Product2.Name +', '+quoteLineItem.Product2.ProductCode+'</b></TD></TR></TABLE>';                             
                pdfContent = pdfContent + '<TABLE border="1"> <TR><TD bgcolor="#f0f5f5">Sales Price</TD><TD>' + currency(quoteLineItem.UnitPrice+'')+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Vision Rate Guarantee</TD><TD>' + quote.Vision_Rate_Guarantee__c+ '</TD></TR>';
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Total</TD><TD>' + currency(quoteLineItem .Class_1_Total__c+'')+ '</TD>'; 
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 1 Emp Contrib Amt</TD><TD>' + quoteLineItem .C1_Emp_Contrib_Amt__c+ '</TD></TR>';            
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Base EE </TD><TD>' + currency(quoteLineItem .Base_EE__c+'')+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 1 Total EE </TD><TD>' + currency(quoteLineItem .C1_Total_EE__c+'')+ '</TD></TR>';
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Base EE + Spouse</TD><TD>' + currency(quoteLineItem .Base_EE_Spouse__c+'')+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 1 Total EE + Spouse</TD><TD>' + currency(quoteLineItem .C1_Total_EE_Sp__c+'')+ '</TD></TR>';    
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Base EE + Child(ren) </TD><TD>' + currency(quoteLineItem .Base_EE_Child__c+'')+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 1 Total EE + Child(ren)</TD><TD>' + currency(quoteLineItem .C1_Total_EE_Ch__c+'')+ '</TD></TR>';              
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Base EE + Family</TD><TD>' + currency(quoteLineItem .Base_EE_Family__c+'')+ '</TD>';
                pdfContent = pdfContent + '<TD bgcolor="#f0f5f5">Class 1 Total EE + Family</TD><TD>' + currency(quoteLineItem .C1_Total_EE_Family__c+'')+ '</TD></TR>';               
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Number EE  </TD><TD>' + quoteLineItem.Class_1_Number_EE__c+ '</TD></TR>';
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Number EE + Spouse</TD><TD>' + quoteLineItem.Class_1_Number_EE_Spouse__c+ '</TD></TR>';
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Number EE + Child(ren)</TD><TD>' + quoteLineItem.Class_1_Number_EE_Child__c+ '</TD></TR>';              
                pdfContent = pdfContent + '<TR><TD bgcolor="#f0f5f5">Class 1 Number EE + Family</TD><TD>' + quoteLineItem.Class_1_Number_EE_Family__c+ '</TD></TR>';             
                pdfContent = pdfContent + '</TABLE>'; 
                }

        }
        return pdfContent;
}
public String currency(String i) {
    try{
        String s = ( Decimal.valueOf(i==null||i.trim()==''?'0':i).setScale(2) + 0.001 ).format();
        return ('$'+s.substring(0,s.length()-1));
        }catch(Exception e){
        return '$0';
        }
}

public String retNoNull(String str) {
    if(str != null) return str; else return ' ';
}

 
 public Account getAccountDetails(String accountId){
    Account accts = [SELECT Name, Website,Work_Phone__c,Type, Employer_EIN__c, vlocity_ins__SumOfEmployees__c, Sic, SicDesc, PersonHomePhone FROM Account
    where Id = :accountId];
    if(accts  != null) {
        if(accts.Website == null) accts.Website = ' ';
        if(accts.Employer_EIN__c== null) accts.Employer_EIN__c= 'N/A';
        if(accts.Work_Phone__c== null) accts.Work_Phone__c= ' ';
        if(accts.PersonHomePhone == null) accts.PersonHomePhone = ' ';
        if(accts.Sic== null) accts.Sic= ' ';

    }
    return accts;
}
 
 public List<QuoteLineItem> getQuoteLineDetails(String quoteId){
    List<QuoteLineItem> quoteLineItemList = [SELECT Product2.Name,Product2.vlocity_ins__Type__c,Product2.ProductCode, Base_EE_Child__c,Base_EE_Family__c,Base_EE_Spouse__c,Base_EE__c,C1_Annual_Total_Premium__c,
    C1_Emp_Contrib_Amt__c,C1_Total_EE_Ch__c,C1_Total_EE_Family__c,C1_Total_EE_Sp__c,C1_Total_EE__c,C2_Annual_Total_Premium__c,C2_Emp_Contrib_Amt__c,
    C2_Total_EE_Ch__c,C2_Total_EE_Family__c,C2_Total_EE_Sp__c,C2_Total_EE__c,C3_Annual_Total_Premium__c,C3_Emp_Contrib_Amt__c,C3_Total_EE_Ch__c,C3_Total_EE_Family__c,
    C3_Total_EE_Sp__c,C3_Total_EE__c,Class_1_Number_EE_Child__c,Class_1_Number_EE_Family__c,Class_1_Number_EE_Spouse__c,Class_1_Number_EE__c,Class_1_Total__c,
    Class_2_Number_EE_Child__c,Class_2_Number_EE_Family__c,Class_2_Number_EE_Spouse__c,Class_2_Number_EE__c,Class_2_Total__c,Class_3_Number_EE_Child__c,
    Class_3_Number_EE_Family__c,Class_3_Number_EE_Spouse__c,Class_3_Number_EE__c,Class_3_Total__c,Class_Selected__c,Discount,
    Dental_Bundled_Price_EE__c,Dental_Bundled_Price_EE_Ch__c,Dental_Bundled_Price_EE_Fa__c,Dental_Bundled_Price_EE_Sp__c,
    Employer_Contribution_Percent__c,LineNumber,Quantity,ServiceDate, SortOrder,Subtotal,TotalPrice,UnitPrice FROM QuoteLineItem WHERE QuoteId = :quoteId];
    return quoteLineItemList;
}
 
  public String getSICName(String SICCode){
    String SicDesc='';  
    if(SICCode != null)
    {
        List<SmallGroupSIC__c> sicCdLst = [SELECT Name FROM SmallGroupSIC__c WHERE SIC_CODE__c = :SICCode];
        if(sicCdLst.size() >0)  SicDesc = sicCdLst[0].Name;
    }
    return SicDesc;
}

 public Quote getQuoteDetails(String quoteId){
    Quote quoteObj = [select Brand__c, AccountId, CreatedDate, CreatedBy.Name, Email,QuoteNumber,Id,GrandTotal,Discount, vlocity_ins__EffectiveDate__c, 
    BillingName, BillingPostalCode, BillingState, BillingStreet, Coverage_Options__c, LineItemCount, BillingCity,Vision_Rate_Guarantee__c,
    Dental_Prior_Comparable_Coverage__c,Dental_Rate_Guarantee__c,Total_Eligible_Employees__c  
    from Quote where id  = :quoteId];
    if(quoteObj.Brand__c == null) quoteObj.Brand__c = ' ';
    if(quoteObj.Email== null) quoteObj.Email= 'N/A';
    if(quoteObj.BillingStreet== null) quoteObj.BillingStreet= ' ';
    if(quoteObj.BillingState== null) quoteObj .BillingState= ' ';
    if(quoteObj.BillingCity == null) quoteObj.BillingCity = ' ';
    return quoteObj;
}
 
    public  boolean attachPDF(Quote quote, String pdfContent)
    {
        try
        {
            Attachment attachmentPDF = new Attachment();
            attachmentPDF.parentId = quote.Id;
            attachmentPDF.ContentType = 'application/pdf';            
            attachmentPDF.Name = 'Quote For Enrollment - '+quote.Id + '.pdf';
            attachmentPDF.body = Blob.toPDF(pdfContent); //This creates the PDF content
            insert attachmentPDF;
        }catch(Exception e)
        {
           System.debug('Exception - '+e.getMessage());
           return false;
        }
        return true;
    }
}