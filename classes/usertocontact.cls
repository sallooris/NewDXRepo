global class usertocontact {
    @future
     /* Code for Update a contact using User */
    public static void usertocon(Set<Id> userIds) {
        List<User> user = [select Id, firstname, lastname, email from user where Id IN :userIds];
        List<contact> cons = new List<contact>();
        for (User usr : User) {
            
            contact c = new contact ();
            c.FirstName = usr.FirstName;
            c.LastName = usr.LastName;
            cons.add(c);
        }
        update cons;
        
    } 
    /* Code for create a contact using User
    public static void usertocon() {
        List<Contact> contacts = new List<Contact>();
        List<User> user = [select Id, firstname, lastname, email from user ];
        for (User u: User){
            Contact c = new Contact();
            c.FirstName = u.FirstName;
            c.LastName = u.LastName;
            contacts.add(c);       
        }
        insert contacts;
    } */
}