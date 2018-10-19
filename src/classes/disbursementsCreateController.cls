public with sharing class disbursementsCreateController {

    @AuraEnabled
    public static dispViewModel getViewModel(Id objectId) {
        return buildModel(objectId);
    }

    @AuraEnabled
    public static List<Disbursement__c> saveDisbursements(String dispListString) {

        List<Disbursement> dList = (List<Disbursement>)
            JSON.deserialize(dispListString, List<Disbursement>.class);

        List<Disbursement__c> newDispList = new List<Disbursement__c>();

        for (Disbursement d : dList) {
            newDispList.add( mapDisbursement(d) );
        }

        insert newDispList;
        return newDispList;
    }

    private static dispViewModel buildModel(Id reqId) {
        dispViewModel vm = new dispViewModel();
        vm.fundingRequest = getRequest(reqId);
        return vm;
    }

    private static Request getRequest(Id reqId) {
        Funding_Request__c fr = [
            SELECT
                Id,
                Requested_Amount__c,
                Awarded_Amount__c,
                Total_Disbursed__c,
                Total_Remaining__c,
                Applying_Contact__r.Name
            FROM
                Funding_Request__c
            WHERE
                Id =:reqId
        ];

        return new Request(fr);
    }

    private static Disbursement__c mapDisbursement(Disbursement d) {
        System.debug('******** mapDisbursement *******');
        return new Disbursement__c(
            Amount__c = d.amount,
            Funding_Request__c = d.requestId,
            Scheduled_Date__c = d.scheduleDate,
            Status__c = 'Scheduled'
        );
    }

    /*** Models ***/

    public Class dispViewModel {

        @AuraEnabled
        public Id requestId;
        @AuraEnabled
        public Request fundingRequest;

        @AuraEnabled
        public Map<String, List<String>> formOptions;

        public dispViewModel() {}
    }

    public Class Request {

        @AuraEnabled
        public Id recordId;
        @AuraEnabled
        public String contactName;
        @AuraEnabled
        public Decimal requestedAmount;
        @AuraEnabled
        public Decimal awardedAmount;
        @AuraEnabled
        public Decimal totalDisbursed;
        @AuraEnabled
        public Decimal totalRemaining;

        public Request(Funding_Request__c r) {
            this.recordId = r.Id;
            this.contactName = r.Applying_Contact__r.Name;
            this.requestedAmount = r.Requested_Amount__c;
            this.awardedAmount = r.Awarded_Amount__c;
            this.totalDisbursed = r.Total_Disbursed__c;
            this.totalRemaining = r.Total_Remaining__c;
        }
    }

    public Class Disbursement {

        public Decimal amount;
        public Id requestId;
        public Date scheduleDate;
        public String status;

        public Disbursement() {}
    }
}