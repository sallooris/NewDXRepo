public class AnthemOppsProfiles {

    public static Profile adminProfile {
        get {
            if (adminProfile==null) {
            	Profiles__c  profileName = [Select id,Profile_Name__c from Profiles__c Where Name='Admin' limit 1  ];
    	        adminProfile =  [Select id, Name from Profile where Name =: profileName.Profile_Name__c limit 1 ];
            }
            return adminProfile ;
        } set ;
    }

    public static Profile brokerProfile {
        get {
            if (brokerProfile==null) {
            	Profiles__c  profileName = [Select id,Profile_Name__c from Profiles__c Where Name='Broker' limit 1  ];
    	        brokerProfile =  [Select id, Name from Profile where Name =: profileName.Profile_Name__c limit 1 ];

            }
            return brokerProfile ;
        } set ;
    }
    
    public static Profile salesAdminProfile {
        get {
            if (salesAdminProfile==null) {
            	Profiles__c  profileName = [Select id,Profile_Name__c from Profiles__c Where Name='Sales Admin' limit 1  ];
    	        salesAdminProfile =  [Select id, Name from Profile where Name =: profileName.Profile_Name__c limit 1 ];

            }
            return salesAdminProfile ;
        } set ;
    }    
    
    public static Profile readOnlyProfile {
        get {
            if (readOnlyProfile==null) {
            	Profiles__c  profileName = [Select id,Profile_Name__c from Profiles__c Where Name='Read Only' limit 1  ];
    	        readOnlyProfile =  [Select id, Name from Profile where Name =: profileName.Profile_Name__c limit 1 ];

            }
            return readOnlyProfile ;
        } set ;
    }    
    
    public static Profile salesManagerProfile {
        get {
            if (salesManagerProfile==null) {
            	Profiles__c  profileName = [Select id,Profile_Name__c from Profiles__c Where Name='Sales Manager' limit 1  ];
    	        salesManagerProfile =  [Select id, Name from Profile where Name =: profileName.Profile_Name__c limit 1 ];

            }
            return salesManagerProfile ;
        } set ;
    }     
    
    public static Profile salesRepProfile {
        get {
            if (salesRepProfile==null) {
            	Profiles__c  profileName = [Select id,Profile_Name__c from Profiles__c Where Name='Sales Rep' limit 1  ];
    	        salesRepProfile =  [Select id, Name from Profile where Name =: profileName.Profile_Name__c limit 1 ];

            }
            return salesRepProfile ;
        } set ;
    }    
    
}