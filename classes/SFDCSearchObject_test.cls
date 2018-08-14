/****************************************************
* Class Name : SFDCSearchObject_test
* Created date : July-27-2015
* Created by : Pointel
* Purpose : To test SFDCSearchObject class
****************************************************/

@isTest(seealldata=true)
public class SFDCSearchObject_test {
    static testMethod void TestSFDCSearchObject(){
        Test.startTest();
        SFDCSearchObject obj=new SFDCSearchObject();
        obj.Search('12345678','','','Account'); 
        obj.Search('1111111111','AND','xxx-xxx-xxxx','Lead'); 
        obj.Search('TestLastname,TestCompany,0121231234','AND','xxx-xxx-xxxx','Lead');   
        obj.Search('1234567890,4343693100','AND','xxx-xxx-xxxx,(xxx) xxx-xxxx-','contact');
        obj.Search('Test1 account','','xxx-xxx-xxx','account');
        obj.Search('Test2 Lead','AND','','contact');
        obj.Search('Test3 Opportunity','','','opportunity');
        obj.Search('Test4','','xxx-xxx-xxx','test21');
        obj.Search('','','','');
        Test.stopTest();
    }
    
}