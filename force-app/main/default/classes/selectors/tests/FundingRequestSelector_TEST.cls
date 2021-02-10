@isTest
public with sharing class FundingRequestSelector_TEST {
    @TestSetup
    public static void testSetup() {
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;

        Contact contact = new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Applicant';
        contact.AccountId = account.Id;
        insert contact;

        Funding_Program__c fundingProgram = new Funding_Program__c();
        fundingProgram.Name = 'Test Funding Program';
        insert fundingProgram;

        Funding_Request__c fundingRequest = new Funding_Request__c();
        fundingRequest.Name = 'Test funding Request';
        fundingRequest.FundingProgram__c = fundingProgram.Id;
        fundingRequest.Applying_Contact__c = contact.Id;
        fundingRequest.Applying_Organization__c = account.Id;
        insert fundingRequest;
    }

    @isTest
    public static void getFundingRequestById() {
        String fundingRequestId = [SELECT Id FROM Funding_Request__c LIMIT 1].Id;

        test.startTest();

        FundingRequestSelector fundingRequestSelector = new FundingRequestSelector();
        List<Funding_Request__c> fundingRequests = fundingRequestSelector.getFundingRequestById(
            fundingRequestId
        );

        test.stopTest();

        system.assertNotEquals(
            null,
            fundingRequests,
            'fundingRequests should have at least one funding request record'
        );
    }

    @isTest
    public static void callFundingRequestWithNoId() {
        test.startTest();

        FundingRequestSelector fundingRequestSelector = new FundingRequestSelector();
        List<Funding_Request__c> fundingRequests = fundingRequestSelector.getFundingRequestById(
            null
        );

        test.stopTest();

        system.assertEquals(
            new List<Funding_Request__c>(),
            fundingRequests,
            'fundingRequests should return an empty list'
        );
    }
}
