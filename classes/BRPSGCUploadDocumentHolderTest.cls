@isTest
public class BRPSGCUploadDocumentHolderTest{
    static testmethod void testBRPSGCUploadDocumentHolder() {
        Test.startTest(); 
        BRPSGCUploadDocumentHolder bRPOAuth2TokenDetailTest = new BRPSGCUploadDocumentHolder();
        bRPOAuth2TokenDetailTest.fileContent= Blob.valueof('TEST BLOB');
        bRPOAuth2TokenDetailTest.required = true;
        bRPOAuth2TokenDetailTest.fname='STR VALUE'; 
        bRPOAuth2TokenDetailTest.appId='STR VALUE'; 
        bRPOAuth2TokenDetailTest.attachId='STR VALUE'; 
        bRPOAuth2TokenDetailTest.fcategory='STR VALUE'; 
        bRPOAuth2TokenDetailTest.fstatus='STR VALUE'; 
        bRPOAuth2TokenDetailTest.contentType='STR VALUE'; 
        bRPOAuth2TokenDetailTest.fileSize=123; 
        bRPOAuth2TokenDetailTest.fileSendStatus='STR VALUE';    
        bRPOAuth2TokenDetailTest.partyId='STR VALUE';    
        bRPOAuth2TokenDetailTest.documentType='STR VALUE';    
        bRPOAuth2TokenDetailTest.formType='STR VALUE';  
        bRPOAuth2TokenDetailTest.uploadType ='STR VALUE';  
        bRPOAuth2TokenDetailTest.userId ='STR VALUE';  
        bRPOAuth2TokenDetailTest.EIN='STR VALUE';  
        bRPOAuth2TokenDetailTest.grpName='STR VALUE';  
        bRPOAuth2TokenDetailTest.state='STR VALUE';  
        bRPOAuth2TokenDetailTest.AppIdForSGC='STR VALUE';          
        bRPOAuth2TokenDetailTest.attachmentSFDCId ='STR VALUE';  
        Test.stopTest();                  
    } 
}