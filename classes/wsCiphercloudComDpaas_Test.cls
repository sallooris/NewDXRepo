@isTest
public with sharing class wsCiphercloudComDpaas_Test {

/**   
    static testmethod void testCover()
   {
        new wsCiphercloudComDpaas.Fault();
        new wsCiphercloudComDpaas.GetEncryptedMailMessageFault();
        new wsCiphercloudComDpaas.ChunkContext();
        new wsCiphercloudComDpaas.GetApplicationDetailsResponse();
        new wsCiphercloudComDpaas.FileResponse();
        new wsCiphercloudComDpaas.Field();
        new wsCiphercloudComDpaas.GetTokenizerRequest();
        new wsCiphercloudComDpaas.TokenizeRequest();
        new wsCiphercloudComDpaas.GetTokenizerFault();
        new wsCiphercloudComDpaas.GetApplicationDetailsRequest();
        new wsCiphercloudComDpaas.GetEncryptedMailMessageRequest();
        new wsCiphercloudComDpaas.DetokenizationResult();
        new wsCiphercloudComDpaas.FileTokenizeDetokenizeRequest();
        new wsCiphercloudComDpaas.TokenizeResponse();
        new wsCiphercloudComDpaas.DetokenizeResponse();
        new wsCiphercloudComDpaas.LoginFault();
        new wsCiphercloudComDpaas.DetokenizeRequest();
        new wsCiphercloudComDpaas.GetTokenizerResponse();
        new wsCiphercloudComDpaas.TokenizeFault();
        new wsCiphercloudComDpaas.ChunkFileResponse();
        new wsCiphercloudComDpaas.FileRequest();
        new wsCiphercloudComDpaas.FileTokenizeDetokenizeResponse();
        new wsCiphercloudComDpaas.ChunkFileRequest();
        new wsCiphercloudComDpaas.HandleChunkFileFault();
        new wsCiphercloudComDpaas.GetEncryptedMailMessageResponse();
        new wsCiphercloudComDpaas.DetokenizeFault();
        new wsCiphercloudComDpaas.FileOptions();
        wsCiphercloudComDpaas.DataProtectionCipherCloudPort cipherComDpass= new wsCiphercloudComDpaas.DataProtectionCipherCloudPort();
        String sessionId = '';
        String serverUrl = '';
        wsCiphercloudComDpaas.FileOptions fileOptions;
        String applicationName = '';
        
        wsCiphercloudComDpaas.FileResponse fileresp = cipherComDpass.handleFile(sessionId, serverUrl, fileOptions, applicationName);
        
        
        
        /*If(!Test.isRunningTest()){
        
        }
        
        
        
        */
 /*   }
    static testmethod void testGetTokenizer()
    {
        String sessionId = '';
        String serverUrl = '';
        String encryptionSchemeName = '';
     wsCiphercloudComDpaas.DataProtectionCipherCloudPort cipherComDpasstoken= new wsCiphercloudComDpaas.DataProtectionCipherCloudPort();
     String tokenresp = cipherComDpasstoken.getTokenizer(encryptionSchemeName,sessionId,serverUrl);
    }
    
    static testmethod void testGetApplicationDetails()
    {
        String applicationKey = '';
        String applicationName = '';
     wsCiphercloudComDpaas.DataProtectionCipherCloudPort cipherComDpassApp= new wsCiphercloudComDpaas.DataProtectionCipherCloudPort();
     wsCiphercloudComDpaas.GetApplicationDetailsResponse appDetailsResp =  cipherComDpassApp.getApplicationDetails(applicationName, applicationKey); 
    }
    
    static testmethod void testGetEncryptedMailMessage()
    {
        String mimeSubject = '';
        String mimeBody = '';
        String mimeAttachment = '';
        String cloudService = '';
     wsCiphercloudComDpaas.DataProtectionCipherCloudPort cipherComDpassEncrypt= new wsCiphercloudComDpaas.DataProtectionCipherCloudPort();
     wsCiphercloudComDpaas.GetEncryptedMailMessageResponse encryptedResp = cipherComDpassEncrypt.getEncryptedMailMessage(mimeSubject,mimeBody,mimeAttachment,cloudService);
    }
    
    static testmethod void testTokenizeMethod()
    {
        String sessionId = '';
        String serverUrl = '';
        wsCiphercloudComDpaas.Field[] field;
     wsCiphercloudComDpaas.DataProtectionCipherCloudPort cipherComDpasstokenize= new wsCiphercloudComDpaas.DataProtectionCipherCloudPort();
     wsCiphercloudComDpaas.Field[] fields = cipherComDpasstokenize.tokenize(sessionId,serverUrl,field);
    }
    
    static testmethod void testHandleChunkMethod()
    {
       String applicationName = '';
       String[] inputByteArray;
       wsCiphercloudComDpaas.ChunkContext chunkContext; 
     wsCiphercloudComDpaas.DataProtectionCipherCloudPort cipherComDpasschuken= new wsCiphercloudComDpaas.DataProtectionCipherCloudPort();
     wsCiphercloudComDpaas.ChunkFileResponse chunk = cipherComDpasschuken.handleChunkFile(applicationName,inputByteArray,chunkContext);
    }
*/
}