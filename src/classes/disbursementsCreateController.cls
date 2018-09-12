public with sharing class disbursementsCreateController {

    // Picklist Fields that will be displayed in UI
    private static final Set<String> PICKLIST_FIELDS = new Set<String>{'Disbursement_Method__c', 'Type__c'};

    @AuraEnabled
    public static dispViewModel getViewModel(Id objectId) {
        return buildModel(objectId);
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

    private static Map<String, List<String>> getPicklistOptions(){
        Map<String, List<String>> optMap = new Map<String, List<String>>();

        Map<String,Schema.SObjectField> fieldMap = SObjectType.Disbursement__c.fields.getMap();

        for(Schema.SObjectField field : fieldMap.values() ) {
            DescribeFieldResult dfr = field.getDescribe();

            if(dfr.type == Schema.DisplayType.PICKLIST) {

            }
        }

        return optMap;
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

        // Amount__c
        // Disbursement_Date__c
        // Disbursement_Method__c
        // Funding_Request__c
        // Scheduled_Date__c
        // Status__c
        // Type__c

        public Decimal amount;
        public Date dispDate;
        public String method;
        public Id requestId;
        public Date scheduleDate;
        public String status;
        public String type;

        public Disbursement() {}
    }
}