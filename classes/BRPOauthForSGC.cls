public class BRPOauthForSGC{

    public static HttpRequest GetHttpReqForCreateApplication (String oAuthToken, String EIN, String AppId)
    {
    	HttpRequest httpReq = new HttpRequest();
    	
    	try 
    	{
	        BRPSGCIntegration__c mc = BRPSGCIntegration__c.getValues('SGC');
	        String hostName = mc.Host__c;
	        String apikey = mc.Apikey__c;
	        String endPointFromRes = mc.CreateApplication__c;
	        endPointFromRes = endPointFromRes.replace('<EIN>',EIN);
	        endPointFromRes = endPointFromRes.replace('<APPID>',AppId);
	//        endPointFromRes = 'http://posttestserver.com/post.php?dir=arun';
	
	        httpReq.setHeader('Authorization','Bearer '+oAuthToken);
	        httpReq.setEndpoint(endPointFromRes);
	        System.debug('HTTP Header - endPointFromRes: '+endPointFromRes);
	        httpReq.setHeader('apikey',apikey);
	        httpReq.setHeader('Host',hostName);  
	        httpReq.setHeader('meta-transid',genTxnId());
	        httpReq.setHeader('Content-Type', 'application/json');
	        httpReq.setTimeout(120000);
	//        httpReq.setHeader('Content-Encoding','gzip');
	        httpReq.setMethod('POST');    
	        httpReq.setHeader('Accept','application/json');    
	        System.debug('HTTP Header - ContentType: ' + httpReq.getHeader('Content-Type'));
	        System.debug('HTTP Header - apikey: ' + httpReq.getHeader('apikey'));
	        System.debug('HTTP Header - Host: ' + httpReq.getHeader('Host'));
	        System.debug('HTTP Request - ' + httpReq.toString());
    	}
		catch(Exception e){
            System.Debug('Error occured in creating HTTPRequest: '+e.getMessage());
        }         
        
        return httpReq;          
    }
    
    //SGFOA Project start
    public static HttpRequest GetHttpReqForAppMemPayment (String oAuthToken, String EIN, String AppId, String reqType)
    {
    	HttpRequest httpReq = new HttpRequest();
    
    	try 
    	{	    	
	        BRPSGCIntegration__c mc = BRPSGCIntegration__c.getValues('SGC');
	        String hostName = mc.Host__c;
	        String apikey = mc.Apikey__c;        
	        String endPointFromRes = '';
	
	        if (reqType == 'CreateAppCensus')   
	        {
	            endPointFromRes = mc.CreateApplicationCensus__c;
	            httpReq.setMethod('POST');            
	        }
	        else if (reqType == 'UpdateAppCensus')
	             {
	             	 endPointFromRes = mc.UpdateApplicationCensus__c;
	             	 httpReq.setMethod('PUT');
	             }
	             else if (reqType == 'CreatePayment')
	                  {
			              endPointFromRes = mc.CreatePayment__c;
			      	      httpReq.setMethod('POST');	
	                  }
	                  else
	                  {
			              endPointFromRes = mc.CreateApplicationStatus__c;
			      	      httpReq.setMethod('POST');
	                  }
	                  
	        endPointFromRes = endPointFromRes.replace('<EIN>',EIN);
	        endPointFromRes = endPointFromRes.replace('<APPID>',AppId);            	                       
	        httpReq.setEndpoint(endPointFromRes);
	        httpReq.setTimeout(120000); 
	        httpReq.setHeader('Authorization','Bearer ' + oAuthToken);
	        httpReq.setHeader('apikey',apikey);
	        httpReq.setHeader('Host',hostName);  
	        httpReq.setHeader('meta-transid',genTxnId());
	        httpReq.setHeader('Content-Type', 'application/json');
	        httpReq.setHeader('Accept','application/json');
	        
	        System.debug('HTTP Header - Authorization: ' + 'Bearer ' + oAuthToken);          
	        System.debug('HTTP Header - Apikey: ' + httpReq.getHeader('apikey'));
	        System.debug('HTTP Header - Host: ' + httpReq.getHeader('Host'));	        
	        System.debug('HTTP Header - Meta-TransId: ' + httpReq.getHeader('meta-transid'));
	        System.debug('HTTP Header - ContentType: ' + httpReq.getHeader('Content-Type'));
	        System.debug('HTTP Header - Accept: ' + httpReq.getHeader('Accept'));
	        System.debug('HTTP Header - endPointFromRes: ' + endPointFromRes);	        
        }
		catch(Exception e){
            System.Debug('Error occured in creating HTTPRequest: ' + e.getMessage());
        }         
                    
        return httpReq;          
    }
    //End SGFOA Project
    
    public static HttpRequest GetHttpReqForApplicationStatus(String oAuthToken, String EIN, String AppId)
    {
        HttpRequest httpReq = new HttpRequest();    	
    
    	try 
    	{	    	        
	        BRPSGCIntegration__c mc = BRPSGCIntegration__c.getValues('SGC');
	        String hostName = mc.Host__c;
	        String apikey = mc.Apikey__c;
	        String endPointFromRes = mc.Get_Applications_Status__c;
	        
	        endPointFromRes = endPointFromRes.replace('<EIN>',EIN);
	        endPointFromRes = endPointFromRes.replace('<APPID>',AppId);
	        //   endPointFromRes = 'http://posttestserver.com/post.php?dir=arun';
	
	        httpReq.setHeader('Authorization','Bearer '+oAuthToken);
	        httpReq.setEndpoint(endPointFromRes);
	        httpReq.setHeader('apikey',apikey);
	        httpReq.setHeader('Host',hostName);  
	        httpReq.setHeader('meta-transid',genTxnId());
	        httpReq.setHeader('Content-Type', 'application/json');
	 //       httpReq.setHeader('Content-Encoding','gzip');   
	        httpReq.setMethod('GET');    
	        httpReq.setTimeout(120000);
	        httpReq.setHeader('Accept','application/json,text/html,image/gif,image/jpeg,*; q=.2,*/*; q=.2');
	        System.debug('HTTP Header - Authorization: '+httpReq.getHeader('Authorization'));
	        System.debug('HTTP Header - ContentType: '+httpReq.getHeader('Content-Type'));
	        System.debug('HTTP Header - apik1426ey: '+httpReq.getHeader('apikey'));
	        System.debug('HTTP Header - Host: '+httpReq.getHeader('Host'));
	        System.debug('HTTP REquest - '+httpReq.toString());
        }
		catch(Exception e){
            System.Debug('Error occured in creating HTTPRequest: '+e.getMessage());
        }         
        
        return httpReq;    
    }
    
    public static HttpRequest GetHttpReqForApplicationDocumentStatus(String oAuthToken, String EIN, String AppId)
    {
        HttpRequest httpReq = new HttpRequest();    	
    
    	try 
    	{	    	          	        
	        BRPSGCIntegration__c mc = BRPSGCIntegration__c.getValues('SGC');
	        String hostName = mc.Host__c;
	        String apikey = mc.Apikey__c;
	        String endPointFromRes = mc.GetDocumentsList__c;
	        
	        endPointFromRes = endPointFromRes.replace('<EIN>',EIN);
	        endPointFromRes = endPointFromRes.replace('<APPID>',AppId);
	        //   endPointFromRes = 'http://posttestserver.com/post.php?dir=arun';
	        httpReq.setHeader('Authorization','Bearer '+oAuthToken);
	        httpReq.setEndpoint(endPointFromRes);
	        httpReq.setHeader('apikey',apikey);
	        httpReq.setHeader('Host',hostName);  
	        httpReq.setHeader('meta-transid',genTxnId());
	        httpReq.setHeader('Content-Type', 'application/json');
	 //       httpReq.setHeader('Content-Encoding','gzip');   
	        httpReq.setMethod('GET');    
	        httpReq.setHeader('Accept','application/json,text/html,image/gif,image/jpeg,*; q=.2,*/*; q=.2');
	        System.debug('HTTP Header - Authorization: '+httpReq.getHeader('Authorization'));
	        System.debug('HTTP Header - ContentType: '+httpReq.getHeader('Content-Type'));
	        System.debug('HTTP Header - apikey: '+httpReq.getHeader('apikey'));
	        System.debug('HTTP Header - Host: '+httpReq.getHeader('Host'));
	        System.debug('HTTP REquest - '+httpReq.toString());
        }
		catch(Exception e){
            System.Debug('Error occured in creating HTTPRequest: '+e.getMessage());
        }         
        
        return httpReq;    
    }
    public static HttpRequest GetHttpReqForUploadDocument (String oAuthToken, String EIN, String AppId)
    {
        HttpRequest httpReq = new HttpRequest();    	
    
    	try 
    	{	    	          	           	
	        BRPSGCIntegration__c mc = BRPSGCIntegration__c.getValues('SGC');
	        String hostName = mc.Host__c;
	        String apikey = mc.Apikey__c;
	        String endPointFromRes = mc.CreateDocument__c;
	        
	        endPointFromRes = endPointFromRes.replace('<EIN>',EIN);
	        endPointFromRes = endPointFromRes.replace('<APPID>',AppId);
	        //   endPointFromRes = 'http://posttestserver.com/post.php?dir=arun';
	        httpReq.setHeader('Authorization','Bearer '+oAuthToken);
	        httpReq.setEndpoint(endPointFromRes);
	        httpReq.setHeader('apikey',apikey);
	        httpReq.setHeader('Host',hostName);  
	         httpReq.setTimeout(120000);
	       httpReq.setHeader('meta-transid',genTxnId());
	        httpReq.setHeader('Content-Type', 'application/json');
	 //       httpReq.setHeader('Content-Encoding','gzip');   
	        httpReq.setMethod('POST');    
	        httpReq.setHeader('Accept','application/json');
	                System.debug('HTTP Header - Authorization: '+httpReq.getHeader('Authorization'));
	        System.debug('HTTP Header - ContentType: '+httpReq.getHeader('Content-Type'));
	        System.debug('HTTP Header - apikey: '+httpReq.getHeader('apikey'));
	        System.debug('HTTP Header - Host: '+httpReq.getHeader('Host'));
	        System.debug('HTTP REquest - '+httpReq.toString());        
        }
		catch(Exception e){
            System.Debug('Error occured in creating HTTPRequest: '+e.getMessage());
        }         
                
        return httpReq;          
    }
    
    public static String genTxnId(){
        String hashStr = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashStr));
        return EncodingUtil.convertToHex(hash);
    }  
    public static String GetOauthToken (){
        BRPOAuth2TokenDetail oAuthCodeDetails = new BRPOAuth2TokenDetail();
        String oAuthCode = QueryOAuthTable();
        if(oAuthCode == null)
        {
            BRPSGCIntegration__c mc = BRPSGCIntegration__c.getValues('SGC');
            oAuthCodeDetails  = GetOauthTokenFromServer(mc); 
 //           UpdateOAuthTable(oAuthCodeDetails.access_token);
            oAuthCode  = oAuthCodeDetails.access_token;
        } 
        return oAuthCode;          
    }
    public static String QueryOAuthTable(){
        String oAuthCode;
        List<OAuthRESTAPIToken__c> oAuthTablLst = [select SystemModstamp, OAuthToken__c, RefreshTimestamp__c from OAuthRESTAPIToken__c where Name = 'OAuthForSGC' limit 1];
        OAuthRESTAPIToken__c oAuthTabl;
        if(oAuthTablLst.size() > 0){
            oAuthTabl = (OAuthRESTAPIToken__c) oAuthTablLst.get(0); 
            if(oAuthTabl != null){
                Datetime dtTime = oAuthTabl.SystemModstamp;
                DateTime newDateTime = dtTime.addminutes(12);
                Datetime currentDateTime = datetime.now();
                System.debug('System Time - '+newDateTime);
                System.debug('Current Time - '+currentDateTime);
                if(newDateTime > currentDateTime)  oAuthCode = oAuthTabl.OAuthToken__c;            
            }
        } 
        System.debug('***************Returning OAuth From DB - '+oAuthCode);
        return oAuthCode;
    }
   
    public static void UpdateOAuthTable(String oAuth){
        List<OAuthRESTAPIToken__c> oAuthTablLst = [select SystemModstamp, OAuthToken__c, RefreshTimestamp__c from OAuthRESTAPIToken__c where Name = 'OAuthForSGC' limit 1];
        OAuthRESTAPIToken__c oAuthTabl;
        if(oAuthTablLst.size() > 0){
            oAuthTabl = (OAuthRESTAPIToken__c) oAuthTablLst.get(0); 
            if(oAuthTabl != null){
                oAuthTabl.OAuthToken__c = oAuth;
                update oAuthTabl;
            }
        } else{
            oAuthTabl = new OAuthRESTAPIToken__c();
            oAuthTabl.OAuthToken__c = oAuth;
            oAuthTabl.Name = 'OAuthForSGC';
            insert oAuthTabl;
        }
    }
    
    public static BRPOAuth2TokenDetail GetOauthTokenFromServer (BRPSGCIntegration__c mc){
        BRPOAuth2TokenDetail objAuthenticationInfo = null;
        /*  
        String keys = 'e0b901c50c0f44cc8706aad5a8a0cf04:1b93781eac645c9eae3a84198f226d26ecb037392e139a853443be6ef3f52fed';
        String apikey ='iiNOHAYyGNPP2ysLg15Lflf9eoNmgsOj';
        String ContentType='application/x-www-form-urlencoded';
        String endPointURL ='https://api-np.anthem.com/v1/oauth/accesstoken';
        String reqbody = 'scope=public&grant_type=client_credentials';
        */
        String keys = mc.OauthCustomerKeys__c;
        String apikey =mc.Apikey__c;
        String endPointURL =mc.EndPointURL__c;
        String reqbody = mc.ReqBody__c;
        String hostName = mc.Host__c;
        Blob blobAuth = Blob.valueof(keys);    
        String Authorization = 'Basic '+EncodingUtil.base64Encode(blobAuth);
        String ContentType='application/x-www-form-urlencoded';
        
        Http httpClient = new Http();
        HttpRequest httpReq = new HttpRequest();
        //Setting Up Header
        httpReq.setHeader('Authorization',Authorization);
        httpReq.setHeader('Content-Type',ContentType);
        httpReq.setHeader('apikey',apikey);
        httpReq.setHeader('Host',hostName );
        //Setting Up Req Parameters    
        httpReq.setBody(reqbody);
        httpReq.setMethod('POST');
        httpReq.setEndpoint(endPointURL);
        System.debug('HTTP Header - Authorization: '+httpReq.getHeader('Authorization'));
        System.debug('HTTP Header - ContentType: '+httpReq.getHeader('Content-Type'));
        System.debug('HTTP Header - apikey: '+httpReq.getHeader('apikey'));
        System.debug('HTTP Header - Host: '+httpReq.getHeader('Host'));
        System.debug('HTTP Body: '+httpReq.getBody());   
        System.debug('HTTP REquest - '+httpReq.toString());
        
        HttpResponse httpRes = httpClient.send(httpReq);
        System.debug('Status - '+httpRes.toString());
        System.debug('Response'+httpRes.getbody()); 
        objAuthenticationInfo = (BRPOAuth2TokenDetail)JSON.deserialize(httpRes.getbody(), BRPOAuth2TokenDetail.class);
        System.debug('BRPOAuth2TokenDetail - '+objAuthenticationInfo);
        System.debug('***************Returning OAuth From Server - '+objAuthenticationInfo.access_token); 
        return objAuthenticationInfo;
    }
    
}