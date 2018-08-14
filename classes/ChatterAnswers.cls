public class ChatterAnswers {
    public String createAccount(String firstname, String lastname, Id siteAdminId) {
         Account a = new Account(name = firstname + ' ' + lastname, ownerId = siteAdminId);
         a.RecordTypeId=[Select id from RecordType where sObjectType = 'Account' and Name like '%Business%' LIMIT 1].id;
         insert a;
         return a.Id;
    }
}