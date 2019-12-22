@isTest
private class disbursementsCreateController_TEST {

    @testSetup
    static void setupTestData() {
        Contact contact1 = new Contact(
            FirstName = 'Test',
            LastName = 'Testers'
        );

        insert contact1;

        Funding_Program__c prog1 = new Funding_Program__c(
            Name = 'Test Program'
        );

        insert prog1;

        Funding_Request__c req1 = new Funding_Request__c(
            Name = 'Test Request',
            FundingProgram__c = prog1.Id,
            Applying_Contact__c = contact1.Id
        );

        insert req1;

    }

    @isTest
    static void testGetFundRequest() {
        Funding_Request__c loadReq = [
            SELECT Id
            FROM Funding_Request__c
            WHERE Name = 'Test Request'
            LIMIT 1
        ];

        test.startTest();
        disbursementsCreateController.Request req  = disbursementsCreateController.getFundRequest(loadReq.Id);
        test.stopTest();

        System.assertEquals(req.recordId, loadReq.Id );
        System.assertEquals(req.contactName, 'Test Testers' );

    }

    @isTest
    static void testSaveDisbursements() {
        Funding_Request__c loadReq = [
            SELECT Id
            FROM Funding_Request__c
            WHERE Name = 'Test Request'
            LIMIT 1
        ];

        List<disbursementsCreateController.Disbursement> disps = new List<disbursementsCreateController.Disbursement>();
        Date today = Date.today();
        for (Integer i = 0; i < 4 ; i++) {
            disbursementsCreateController.Disbursement d = new disbursementsCreateController.Disbursement();
            d.amount = 300;
            d.requestId = loadReq.Id;
            d.scheduleDate = today.addMonths(i);
            d.status = 'scheduled';
            disps.add(d);
        }


        test.startTest();
        disbursementsCreateController.saveDisbursements(JSON.serialize(disps));
        test.stopTest();

        Disbursement__c[] disbursements = [
            SELECT Id, Funding_Request__c
            FROM Disbursement__c
            WHERE Funding_Request__c =: loadReq.Id
        ];

        System.assertEquals(disbursements.size(),disps.size());

    }
}