global class AccountResponseResult
{
	// WS error codes & error message
    WebService Integer returnCode;
    WebService String message;
    WebService Integer totalNoOfAccountResponses; 
    WebService AccountResponse[] accountResponses { get; set; }
}