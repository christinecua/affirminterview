@isTest
public class ContactTriggerHandlerTest {
    @TestSetup
    static void setupData(){
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.Industry = 'Apparel';
        testAcct.BillingStreet = '27071 Aliso Creek Rd';
        testAcct.BillingCity = 'Aliso Viejo';
        testAcct.BillingState = 'California';
        testAcct.BillingPostalCode  = '92686';
        testAcct.BillingCountry = 'United States';           
        insert testAcct;
    }
    
    @isTest
    static void testPopulateIndustryInsert(){
        Account acc = [SELECT Id, Name, Industry FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Test.startTest();
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.FirstName = 'First Test';
        con.LastName = 'Last Test';
        insert con;
        Test.stopTest();
        
        Contact insertedContact = [SELECT Id, Account_Industry__c, Email FROM Contact WHERE Id = :con.Id];
        system.assertEquals(acc.Industry, insertedContact.Account_Industry__c);
        
    }
    
    @isTest
    static void testPopulateIndustryUpdate(){
        Account acc = [SELECT Id, Name, Industry FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Test.startTest();
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.FirstName = 'First Test';
        con.LastName = 'Last Test';
        insert con;
        
        acc.Industry = 'Agriculture';
        update acc;
        
        con.Email = 'firstlast@mailinator.com';
        update con;
        Test.stopTest();
        
        Contact updatedContact = [SELECT Id, Account_Industry__c, Email FROM Contact WHERE Id = :con.Id];
        system.assertEquals(acc.Industry, updatedContact.Account_Industry__c);
        
    }
}