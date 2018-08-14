public class ApplicationAndAccountWrapper {
 	public Id applicationId {get; set;}
 	public Id opportunityId {get; set;}
 	public Id generalAgencyId {get; set;}
 	public Id paidAgencyId {get; set;}
 	public Set<Id> agenciesIdSet = new Set<Id>();
 	public Id brokerAccountId {get; set;}


 	public ApplicationAndAccountWrapper(Id applicationId, Id opportunityId, Id generalAgencyId, Id paidAgencyId, Id brokerAccountId) {
 		this.applicationId 		= applicationId;
 		this.opportunityId 		= opportunityId;
 		this.generalAgencyId 	= generalAgencyId;
 		this.paidAgencyId 		= paidAgencyId;
 		this.brokerAccountId 	= brokerAccountId;
 		if(generalAgencyId != null) {
 			this.agenciesIdSet.add(generalAgencyId);
 		}
 		if(paidAgencyId != null) {
 			this.agenciesIdSet.add(paidAgencyId);
			}
			if(brokerAccountId != null) {
				this.agenciesIdSet.add(brokerAccountId);
			}
 	}
}