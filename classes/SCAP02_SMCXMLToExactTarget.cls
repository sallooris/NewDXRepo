/**********************************************************************
Class Name   : SCAP02_SMCXMLToExactTarget 
Date Created : 27-Oct-2015
Created By   : Bhaskar
Description  : Used to extract the SMC XML file from XML Generator object and send it to Exact Target
Referenced/Used in : Used to in batch apex
**********************************************************************/
global with sharing Class SCAP02_SMCXMLToExactTarget implements Schedulable
{
    global void Execute(SchedulableContext SC)
    {
        BAP02_SMCXMLToExactTarget b = new BAP02_SMCXMLToExactTarget();
        Database.ExecuteBatch(b,1);
    }
}