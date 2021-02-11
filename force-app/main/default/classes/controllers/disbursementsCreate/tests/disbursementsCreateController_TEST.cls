@isTest
private class disbursementsCreateController_TEST {
    @testSetup
    static void setupTestData() {
        Schema.Contact contact1 = new Schema.Contact(
            FirstName = 'Test',
            LastName = 'Testers'
        );

        insert contact1;

        Schema.Funding_Program__c prog1 = new Schema.Funding_Program__c(
            Name = 'Test Program'
        );

        insert prog1;

        Schema.Funding_Request__c req1 = new Schema.Funding_Request__c(
            Name = 'Test Request',
            FundingProgram__c = prog1.Id,
            Applying_Contact__c = contact1.Id
        );

        insert req1;
    }

    @isTest
    static void testSaveDisbursementsWhenSuccessful() {
        final Id fundingRequestId = UnitTest.mockId(
            Schema.SObjectType.Funding_Request__c
        );

        final List<disbursementsCreateController.Disbursement> disbursementWrappers = new List<disbursementsCreateController.Disbursement>();
        final List<Schema.Disbursement__c> expectedDisbursements = new List<Schema.Disbursement__c>();
        final Date today = Date.today();

        for (Integer i = 0; i < 4; i++) {
            // Set argument.
            disbursementsCreateController.Disbursement disbursementWrapper = new disbursementsCreateController.Disbursement();
            disbursementWrapper.amount = Decimal.valueOf(Crypto.getRandomInteger());
            disbursementWrapper.requestId = fundingRequestId;
            disbursementWrapper.scheduleDate = today.addMonths(i);
            disbursementWrapper.status = 'anything; this value is not used';
            disbursementWrappers.add(disbursementWrapper);

            // Set what we expect to be passed into insertRecordsEnforceFls.
            final Schema.Disbursement__c expectedDisbursement = disbursementsCreateController.mapDisbursement(
                disbursementWrapper
            );
            expectedDisbursements.add(expectedDisbursement);
        }

        // Create mocks.
        final UnitTest.Mock databaseServiceMock = new UnitTest.Mock();
        final UnitTest.Mock insertRecordsEnforceFls = databaseServiceMock.getMethod(
            'insertRecordsEnforceFls'
        );

        Test.startTest();

        // Set stubs.
        disbursementsCreateController.databaseService = (DatabaseService) databaseServiceMock.createStub(
            DatabaseService.class
        );

        final Boolean actual = disbursementsCreateController.saveDisbursements(
            JSON.serialize(disbursementWrappers)
        );

        Test.stopTest();

        System.assert(
            actual,
            'saveDisbursements should return true since the insert was successful.'
        );

        insertRecordsEnforceFls.assertCalledOnceWith(
            new List<Object>{ expectedDisbursements }
        );
    }

    @isTest
    static void testSaveDisbursementsWhenExceptionThrown() {
        final Id fundingRequestId = UnitTest.mockId(
            Schema.SObjectType.Funding_Request__c
        );

        final List<disbursementsCreateController.Disbursement> disbursementWrappers = new List<disbursementsCreateController.Disbursement>();
        final List<Schema.Disbursement__c> expectedDisbursements = new List<Schema.Disbursement__c>();
        final Date today = Date.today();

        for (Integer i = 0; i < 4; i++) {
            // Set argument.
            disbursementsCreateController.Disbursement disbursementWrapper = new disbursementsCreateController.Disbursement();
            disbursementWrapper.amount = Decimal.valueOf(Crypto.getRandomInteger());
            disbursementWrapper.requestId = fundingRequestId;
            disbursementWrapper.scheduleDate = today.addMonths(i);
            disbursementWrapper.status = 'anything; this value is not used';
            disbursementWrappers.add(disbursementWrapper);

            // Set what we expect to be passed into insertRecordsEnforceFls.
            final Schema.Disbursement__c expectedDisbursement = disbursementsCreateController.mapDisbursement(
                disbursementWrapper
            );
            expectedDisbursements.add(expectedDisbursement);
        }

        final String dispListString = JSON.serialize(disbursementWrappers);

        // Create mocks.
        final UnitTest.Mock databaseServiceMock = new UnitTest.Mock();
        final UnitTest.Mock insertRecordsEnforceFls = databaseServiceMock.getMethod(
            'insertRecordsEnforceFls'
        );
        insertRecordsEnforceFls.returnValue = new UnitTest.TestException();

        Test.startTest();

        // Set stubs.
        disbursementsCreateController.databaseService = (DatabaseService) databaseServiceMock.createStub(
            DatabaseService.class
        );

        final Boolean actual = disbursementsCreateController.saveDisbursements(
            dispListString
        );

        Test.stopTest();

        System.assertEquals(
            false,
            actual,
            'DisbursementsCreateController.saveDisbursements should return false since insertRecordsEnforceFls threw an exception'
        );

        insertRecordsEnforceFls.assertCalledOnceWith(
            new List<Object>{ expectedDisbursements }
        );
    }

    @isTest
    static void testGetFundRequestNotNull() {
        // Create Argument
        final Id fundingRequestId = UnitTest.mockId(
            Schema.SObjectType.Funding_Request__c
        );

        // Create Expected Values
        final Schema.Funding_request__c fundingRequest = new Schema.Funding_request__c();

        fundingRequest.Id = fundingRequestId;

        //final Schema.Funding_Request__c expectedFundingRequest = new Schema.Funding_Request__c();

        List<Funding_Request__c> fundingRequests = new List<Funding_Request__c>();
        fundingRequests.add(fundingRequest);

        final disbursementsCreateController.Request expected = new disbursementsCreateController.Request(
            fundingRequest
        );

        // Create Mocks
        final UnitTest.Mock fundingRequestSelectorMock = new UnitTest.Mock();
        final UnitTest.Mock getFundingRequestById = fundingRequestSelectorMock.getMethod(
            'getFundingRequestById'
        );
        // Create Mock Return Values
        getFundingRequestById.returnValue = fundingRequests;

        Test.startTest();
        // Set stubs
        disbursementsCreateController.fundingRequestSelector = (FundingRequestSelector) fundingRequestSelectorMock.createStub(
            FundingRequestSelector.class
        );
        // Execute test
        final disbursementsCreateController.Request actual = disbursementsCreateController.getFundRequest(
            fundingRequestId
        );

        Test.stopTest();

        // assert expected values
        System.assertNotEquals(
            null,
            actual,
            'disbursementsCreateController.Request should not be null'
        );
        System.assertEquals(expected.recordId, actual.recordId);

        //System.assertEquals(expected, actual);
        // assert expected method call

        getFundingRequestById.assertCalledOnceWith(new List<Object>{ fundingRequestId });
    }

    @isTest
    static void testGetFundRequestWhenQueryReturnEmpty() {
        // Create Argument
        final Id fundingRequestId = UnitTest.mockId(
            Schema.SObjectType.Funding_Request__c
        );

        // Create Expected Values
        final Schema.Funding_request__c fundingRequest = new Schema.Funding_request__c();

        fundingRequest.Id = fundingRequestId;
        List<Funding_Request__c> fundingRequests = new List<Funding_Request__c>();

        final disbursementsCreateController.Request expected = new disbursementsCreateController.Request(
            new Schema.Funding_Request__c()
        );

        // Create Mocks
        final UnitTest.Mock fundingRequestSelectorMock = new UnitTest.Mock();
        final UnitTest.Mock getFundingRequestById = fundingRequestSelectorMock.getMethod(
            'getFundingRequestById'
        );
        // Create Mock Return Values
        getFundingRequestById.returnValue = fundingRequests;

        Test.startTest();
        // Set stubs
        disbursementsCreateController.fundingRequestSelector = (FundingRequestSelector) fundingRequestSelectorMock.createStub(
            FundingRequestSelector.class
        );
        // Execute test
        final disbursementsCreateController.Request actual = disbursementsCreateController.getFundRequest(
            fundingRequestId
        );

        Test.stopTest();

        // assert expected values
        System.assertEquals(null, actual.requestedAmount, 'Actual should be empty');

        System.assertEquals(null, expected.requestedAmount, 'Expected should be empty');

        System.assertEquals(
            expected.requestedAmount,
            actual.requestedAmount,
            'Actual and Expected should be empty'
        );

        // assert expected method call
        getFundingRequestById.assertCalledOnceWith(new List<Object>{ fundingRequestId });
    }

    @isTest
    static void testGetFundRequestThrowException() {
        // Create Argument
        final Id fundingRequestId = UnitTest.mockId(
            Schema.SObjectType.Funding_Request__c
        );

        // Create Expected Values
        final Schema.Funding_request__c fundingRequest = new Schema.Funding_request__c();

        fundingRequest.Id = fundingRequestId;
        List<Funding_Request__c> fundingRequests = new List<Funding_Request__c>();
        fundingRequests.add(fundingRequest);

        final disbursementsCreateController.Request expected = new disbursementsCreateController.Request(
            fundingRequest
        );

        // Create Mocks
        final UnitTest.Mock fundingRequestSelectorMock = new UnitTest.Mock();
        final UnitTest.Mock getFundingRequestById = fundingRequestSelectorMock.getMethod(
            'getFundingRequestById'
        );
        // Create Mock Return Values
        getFundingRequestById.returnValue = new UnitTest.TestException('Query Exception');

        Exception actualException;
        Test.startTest();
        // Set stubs
        disbursementsCreateController.fundingRequestSelector = (FundingRequestSelector) fundingRequestSelectorMock.createStub(
            FundingRequestSelector.class
        );
        // Execute test
        try {
            disbursementsCreateController.getFundRequest(fundingRequestId);
        } catch (AuraHandledException e) {
            actualException = e;
        }

        Test.stopTest();

        // assert expected values
        System.assertNotEquals(
            null,
            actualException,
            'disbursementsCreateController getFundRequest should throw an exception'
        );

        System.assertEquals(
            'Query Exception',
            actualException.getMessage(),
            'Exception messages should be the same'
        );

        getFundingRequestById.assertCalledOnceWith(new List<Object>{ fundingRequestId });
    }

    @isTest
    static void testMapDisbursements() {
        final Id fundingRequestId = UnitTest.mockId(
            Schema.SObjectType.Funding_Request__c
        );
        final Date today = Date.today();

        // Set argument.
        disbursementsCreateController.Disbursement disbursementWrapper = new disbursementsCreateController.Disbursement();
        disbursementWrapper.amount = Decimal.valueOf(Crypto.getRandomInteger());
        disbursementWrapper.requestId = fundingRequestId;
        disbursementWrapper.scheduleDate = today.addMonths(1);
        disbursementWrapper.status = 'anything; this value is not used';
        //disbursementWrappers.add(disbursementWrapper);

        Test.startTest();
        // Set what we expect to be passed into insertRecordsEnforceFls.
        final Schema.Disbursement__c expectedDisbursement = disbursementsCreateController.mapDisbursement(
            disbursementWrapper
        );

        Test.stopTest();

        System.assertEquals(
            'Scheduled',
            expectedDisbursement.Status__c,
            'Status is hardcoded to SCHEDULED on mapDisbursement method'
        );
        System.assertNotEquals(
            disbursementWrapper.status,
            expectedDisbursement.Status__c,
            'Status is hardcoded to SCHEDULED on mapDisbursment method'
        );
        System.assertEquals(
            disbursementWrapper.amount,
            expectedDisbursement.Amount__c,
            'Amount should be the same'
        );
        System.assertEquals(
            disbursementWrapper.scheduleDate,
            expectedDisbursement.Scheduled_Date__c,
            'Schedule date should be the same'
        );
        System.assertEquals(
            disbursementWrapper.requestId,
            expectedDisbursement.Funding_Request__c,
            'Funding Request Id  should be the same'
        );
    }

    @isTest
    static void testRequestConstructor() {
        final Schema.Funding_Request__c record = [
            SELECT
                Id,
                Applying_Contact__r.Name,
                Requested_Amount__c,
                Awarded_Amount__c,
                Total_Disbursed__c,
                Total_Remaining__c
            FROM Funding_Request__c
            WHERE Name = 'Test Request'
            LIMIT 1
        ];

        final Map<String, String> expectedFundingRequestLabels = new Map<String, String>{
            'Applying_Contact__c' => Schema.SObjectType.Funding_Request__c.fields.Applying_Contact__c.getLabel(),
            'Requested_Amount__c' => Schema.SObjectType.Funding_Request__c.fields.Requested_Amount__c.getLabel(),
            'Awarded_Amount__c' => Schema.SObjectType.Funding_Request__c.fields.Awarded_Amount__c.getLabel(),
            'Total_Disbursed__c' => Schema.SObjectType.Funding_Request__c.fields.Total_Disbursed__c.getLabel(),
            'Total_Remaining__c' => Schema.SObjectType.Funding_Request__c.fields.Total_Remaining__c.getLabel()
        };

        final Map<String, String> expectedDisbursementLabels = new Map<String, String>{
            'Amount__c' => Schema.SObjectType.Disbursement__c.fields.Amount__c.getLabel(),
            'Scheduled_Date__c' => Schema.SObjectType.Disbursement__c.fields.Scheduled_Date__c.getLabel()
        };

        final Map<String, String> expectedUiMessages = new Map<String, String>{
            'Error' => System.Label.Error,
            'NoFundsRemaining' => System.Label.disbursementsCreate_NoFundsRemaining,
            'PaymentsExceedFunds' => System.Label.disbursementsCreate_PaymentsExceedFunds,
            'SavedMessage' => System.Label.disbursementsCreate_SavedMessage,
            'NoAccess' => System.Label.DatabaseService_NoInsertFlsException
        };

        final Map<String, String> expectedIntervalTypes = new Map<String, String>{
            'Week' => System.Label.disbursementsCreate_IntervalType_Week,
            'Month' => System.Label.disbursementsCreate_IntervalType_Month,
            'Year' => System.Label.disbursementsCreate_IntervalType_Year
        };

        Test.startTest();

        final disbursementsCreateController.Request request = new disbursementsCreateController.Request(
            record
        );

        Test.stopTest();

        System.assertEquals(request.recordId, record.Id);
        System.assertEquals(request.contactName, record.Applying_Contact__r.Name);
        System.assertEquals(request.requestedAmount, record.Requested_Amount__c);
        System.assertEquals(request.awardedAmount, record.Awarded_Amount__c);
        System.assertEquals(request.totalDisbursed, record.Total_Disbursed__c);
        System.assertEquals(request.totalRemaining, record.Total_Remaining__c);
        System.assertEquals(request.fundingRequestLabels, expectedFundingRequestLabels);
        System.assertEquals(request.disbursementLabels, expectedDisbursementLabels);
        System.assertEquals(request.uiMessages, expectedUiMessages);
        System.assertEquals(request.intervalTypes, expectedIntervalTypes);
    }
}
