public class aa {

StaticResource static_resource = [SELECT Id, SystemModStamp
                              FROM StaticResource 
                              WHERE Name = 'FullCalendar'
                              LIMIT 1];
                       String myUrl = PageReference.forResource('FullCalendar').getUrl();    
                
 Id devRecordTypeId = Schema.SObjectType.Branch__c.getRecordTypeInfosByName().get('NEWTEST').getRecordTypeId(); 
public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Candidate__c.FieldSets.newcandiddatefieldset.getFields();
    }
public void submitForApproval()
{
 AssignmentRule AR = new AssignmentRule();
AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
/*      // Create an approval request for the Opportunity
    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
    req1.setComments('Submitting request for approval automatically using Trigger');
    req1.setObjectId(opp.id);
  //  req1.setNextApproverIds(new Id[] {opp.Next_Approver__c});

    // Submit the approval request for the Opportunity
    Approval.ProcessResult result = Approval.process(req1); */

}  

       Schema.FieldSet fs1 = Schema.SObjectType.Candidate__c.fieldSets.getMap().get('candifieldset');                     
public static void sendEmail(ID recipient, ID candidate) {
EmailTemplate templateId = [Select id from EmailTemplate where name = ' EmailSample'];

//New instance of a single email message
Messaging.SingleEmailMessage mail = 
        new Messaging.SingleEmailMessage();

// Who you are sending the email to
mail.setTargetObjectId(recipient);

// The email template ID used for the email
mail.setTemplateId('00X0K000001i079');
      mail.setTemplateID(templateId.Id); 

mail.setWhatId(candidate);    
mail.setBccSender(false);
mail.setUseSignature(false);
mail.setReplyTo('recruiting@acme.com');
mail.setSenderDisplayName('HR Recruiting');
mail.setSaveAsActivity(false);  


Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

}  
}