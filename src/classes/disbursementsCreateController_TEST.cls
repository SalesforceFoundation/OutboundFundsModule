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
    static void testGetFundRequest() {
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
            'SavedMessage' => System.Label.disbursementsCreate_SavedMessage
        };

        final Map<String, String> expectedIntervalTypes = new Map<String, String>{
            'Week' => System.Label.disbursementsCreate_IntervalType_Week,
            'Month' => System.Label.disbursementsCreate_IntervalType_Month,
            'Year' => System.Label.disbursementsCreate_IntervalType_Year
        };

        Test.startTest();

        final disbursementsCreateController.Request request = disbursementsCreateController.getFundRequest(
            record.Id
        );

        Test.stopTest();

        System.assertNotEquals(
            null,
            request,
            'record exist so getFundRequest() should not return null.'
        );

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

    @isTest
    static void testSaveDisbursements() {
        final Schema.Funding_Request__c loadReq = [
            SELECT Id
            FROM Funding_Request__c
            WHERE Name = 'Test Request'
            LIMIT 1
        ];

        List<disbursementsCreateController.Disbursement> disps = new List<disbursementsCreateController.Disbursement>();
        Date today = Date.today();
        for (Integer i = 0; i < 4; i++) {
            disbursementsCreateController.Disbursement d = new disbursementsCreateController.Disbursement();
            d.amount = 300;
            d.requestId = loadReq.Id;
            d.scheduleDate = today.addMonths(i);
            d.status = 'scheduled';
            disps.add(d);
        }

        Test.startTest();

        disbursementsCreateController.saveDisbursements(JSON.serialize(disps));

        Test.stopTest();

        List<Schema.Disbursement__c> disbursements = [
            SELECT Id, Funding_Request__c
            FROM Disbursement__c
            WHERE Funding_Request__c = :loadReq.Id
        ];

        System.assertEquals(disbursements.size(), disps.size());
    }
}
