@isTest
public with sharing class FundingRequestSelector_TEST {
    private static TestUser.MinimalAccessPersona minimalAccessPersona = new TestUser.MinimalAccessPersona();

    @TestSetup
    public static void testSetup() {
        TestUser.insertPersonasInTestSetup(
            new List<TestUser.Persona>{ FundingRequestSelector_TEST.minimalAccessPersona }
        );

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
        fundingRequest.Requested_Amount__c = 2000;
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

    @isTest
    private static void callFundingRequest_MissingCrud() {
        // Configure permissions.
        FundingRequestSelector_TEST.minimalAccessPersona.load();
        Test.startTest();

        System.QueryException actualException;

        System.runAs(FundingRequestSelector_TEST.minimalAccessPersona.getUser()) {
            System.assertEquals(
                false,
                Schema.Funding_Request__c.SObjectType.getDescribe().isAccessible()
            );

            System.assertEquals(
                false,
                Schema.Contact.SObjectType.getDescribe().isAccessible()
            );

            System.assertEquals(
                false,
                Schema.Funding_Request__c.SObjectType.fields.Requested_Amount__c.getDescribe()
                    .isAccessible()
            );

            System.assertEquals(
                false,
                Schema.Funding_Request__c.SObjectType.fields.Awarded_Amount__c.getDescribe()
                    .isAccessible()
            );

            System.assertEquals(
                false,
                Schema.Funding_Request__c.SObjectType.fields.Total_Disbursed__c.getDescribe()
                    .isAccessible()
            );

            System.assertEquals(
                false,
                Schema.Funding_Request__c.SObjectType.fields.Total_Remaining__c.getDescribe()
                    .isAccessible()
            );

            System.assertEquals(
                false,
                Schema.Funding_Request__c.SObjectType.fields.Total_Remaining__c.getDescribe()
                    .isAccessible()
            );
            // Question regarding lookups

            // Run the test
            String fundingRequestId = [SELECT Id FROM Funding_Request__c LIMIT 1].Id;

            final FundingRequestSelector fundingRequestSelector = new FundingRequestSelector();

            try {
                List<Funding_Request__c> fundingRequests = fundingRequestSelector.getFundingRequestById(
                    fundingRequestId
                );
            } catch (System.QueryException e) {
                actualException = e;
            }
        }

        Test.stopTest();

        System.assertNotEquals(
            null,
            actualException,
            'A System.QueryException should have been thrown because the user cannot read Funding_Request__c.'
        );
    }

    @isTest
    private static void callFundingRequest_WithCrudAccess() {
        Test.startTest();

        System.assert(Schema.Funding_Request__c.SObjectType.getDescribe().isAccessible());

        System.assert(Schema.Contact.SObjectType.getDescribe().isAccessible());

        System.assert(
            Schema.Funding_Request__c.SObjectType.fields.Requested_Amount__c.getDescribe()
                .isAccessible()
        );

        System.assert(
            Schema.Funding_Request__c.SObjectType.fields.Awarded_Amount__c.getDescribe()
                .isAccessible()
        );

        System.assert(
            Schema.Funding_Request__c.SObjectType.fields.Total_Disbursed__c.getDescribe()
                .isAccessible()
        );

        System.assert(
            Schema.Funding_Request__c.SObjectType.fields.Total_Remaining__c.getDescribe()
                .isAccessible()
        );

        System.assert(
            Schema.Funding_Request__c.SObjectType.fields.Total_Remaining__c.getDescribe()
                .isAccessible()
        );

        // Run the test
        String fundingRequestId = [SELECT Id FROM Funding_Request__c LIMIT 1].Id;

        final FundingRequestSelector fundingRequestSelector = new FundingRequestSelector();

        List<Funding_Request__c> fundingRequests = fundingRequestSelector.getFundingRequestById(
            fundingRequestId
        );

        Test.stopTest();

        System.assertNotEquals(
            null,
            fundingRequests.isEmpty(),
            'Funding Request should not be empty'
        );

        System.assertEquals(
            1,
            fundingRequests.size(),
            'Funding Request list should bring one record'
        );

        System.assertEquals(fundingRequestId, fundingRequests[0].Id);
        System.assertEquals(2000, fundingRequests[0].Requested_Amount__c);
    }
}
