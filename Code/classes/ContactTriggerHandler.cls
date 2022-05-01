public class ContactTriggerHandler {
	public void beforeInsert(List<Contact> newList) {
        populateIndustry(newList);
    }
	
    public void beforeUpdate(List<Contact> newList) {
        populateIndustry(newList);
    }
	    
    private void populateIndustry(List<Contact> newList){
        Map<Id, List<Contact>> mapAcctIdToContacts = new Map<Id, List<Contact>>(); 
        for(Contact c : newList) {
            // Create a map of accounts and its associated contacts
            if (c.AccountId != null) {
                if (!mapAcctIdToContacts.containsKey(c.AccountId)) {
                    mapAcctIdToContacts.put(c.AccountId, new List<Contact>());
                }
                mapAcctIdToContacts.get(c.AccountId).add(c);
            }
        }
        
        // Query for Industry value of all accounts associated to contact, and update each contact 
        for (Account acc : [SELECT Id, Industry FROM Account WHERE Id IN :mapAcctIdToContacts.keySet()]) {
            for (Contact c : mapAcctIdToContacts.get(acc.Id)) {
                c.Account_Industry__c = acc.Industry;
            }   
        }
    }
}