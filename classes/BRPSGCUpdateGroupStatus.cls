@RestResource(urlMapping='/SGCGroupStatus/*')
global with sharing class BRPSGCUpdateGroupStatus {
             
    global class GroupStatusResponse {
        global String code{get;set;}
        global String message{get;set;}
        global String detail{get;set;}
    }            
     
  @HttpPost
    global static GroupStatusResponse doPost() {
        BRPSGCUpdateGroupStatusSupporting grpSupporting = new BRPSGCUpdateGroupStatusSupporting();              
        BRPSGCUpdateGroupStatusSupporting.GroupStatusRequest request = new BRPSGCUpdateGroupStatusSupporting.GroupStatusRequest();
        
        GroupStatusResponse response = new GroupStatusResponse();          
        
        //Check if Request Body is NULL
        if (null != RestContext.request.requestBody)
        {    
        
            RestRequest req = RestContext.request;
            
            System.debug('Body: ' + (req.requestBody != null ? req.requestBody.toString() : ''));
            
            try
            {
                //Parse JSON Request Body
                JSONParser parser = JSON.createParser(req.requestBody.toString());
    
                //Extract JSON Request Body Elements            
                request = grpSupporting.GetGroupStatusRequest(parser);
    
                //Update Application Group Status
                response = grpSupporting.UpdateGroupStatus(request);
            }
            catch (Exception e) {
                RestContext.response.statusCode = 401;                              
                response.code = '401';
                response.message = 'FAILED';
                response.detail = 'Exception: ' + e.getMessage();
                
                System.Debug('Error occured in SGCGroupStatus Rest API: '+ e.getMessage());                                             
            }            
        }   
        else //Request Body was NULL
        { 
            RestContext.response.statusCode = 400;
            response.code = '400';
            response.message = 'FAILED';
            response.detail = 'Request Body is empty. Please try again.';
        }     

       return response;
    }
}