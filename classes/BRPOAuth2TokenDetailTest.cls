@isTest
public class BRPOAuth2TokenDetailTest{
    static testmethod void testBRPOAuth2TokenDetail() {
        Test.startTest(); 
        BRPOAuth2TokenDetail bRPOAuth2TokenDetail = new BRPOAuth2TokenDetail();   
        bRPOAuth2TokenDetail.issued_at='Some Value';
        bRPOAuth2TokenDetail.application_name='Some Value';
        bRPOAuth2TokenDetail.status='Some Value';
        bRPOAuth2TokenDetail.expires_in='Some Value';
        bRPOAuth2TokenDetail.client_id='Some Value';    
        bRPOAuth2TokenDetail.access_token = 'Some Value';    
        Test.stopTest();                  
    } 
    }