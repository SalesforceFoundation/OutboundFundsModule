/**
 * Controller for disbursementsCreate Lightning Component.
 * This class is contains some basic Models that Are used to
 * display Data in the UI, as well as handles the requests from the UI.
 */
public with sharing class disbursementsCreateController {
    @TestVisible
    private static DatabaseService databaseService = new DatabaseService();

    @TestVisible
    private static FundingRequestSelector fundingRequestSelector = new FundingRequestSelector();

    /**
     * This Method is the entry point for the Lightning Component to receive data about the funding request
     *
     * @param reqId - The Id of the funding request parent of the discbursements that will be created.
     *
     * @return Request - the request model
     */
    @AuraEnabled
    public static disbursementsCreateController.Request getFundRequest(Id reqId) {
        try {
            Schema.Funding_Request__c fundingRequest = new Schema.Funding_Request__c();

            for (
                Schema.Funding_Request__c fundingRequestFromSelector : fundingRequestSelector.getFundingRequestById(
                    reqId
                )
            ) {
                fundingRequest = fundingRequestFromSelector;
            }

            return new disbursementsCreateController.Request(fundingRequest);
        } catch (Exception e) {
            System.AuraHandledException auraHandledExpection = new System.AuraHandledException(
                e.getMessage()
            );
            auraHandledExpection.setMessage(e.getMessage());
            throw auraHandledExpection;
        }
    }

    /**
     * This method is called to save a list of disbursements to the database
     *
     * @param dispListString - A serialized string which is a list of Disbursements
     */
    @AuraEnabled
    public static boolean saveDisbursements(String dispListString) {
        try {
            List<disbursementsCreateController.Disbursement> dList = (List<disbursementsCreateController.Disbursement>) JSON.deserialize(
                dispListString,
                List<disbursementsCreateController.Disbursement>.class
            );

            List<Schema.Disbursement__c> newDispList = new List<Schema.Disbursement__c>();

            for (disbursementsCreateController.Disbursement d : dList) {
                newDispList.add(mapDisbursement(d));
            }

            disbursementsCreateController.databaseService.insertRecordsEnforceFls(
                newDispList
            );
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * A quick mapper method to convert a Disbursement into a Disbursement__c
     *
     * @param d - Disbursement
     *
     * @return - Disbursement__c
     */
    @TestVisible
    private static Schema.Disbursement__c mapDisbursement(
        disbursementsCreateController.Disbursement d
    ) {
        return new Schema.Disbursement__c(
            Amount__c = d.amount,
            Funding_Request__c = d.requestId,
            Scheduled_Date__c = d.scheduleDate,
            Status__c = 'Scheduled'
        );
    }

    /*** Models ***/

    public with sharing class Request {
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

        @AuraEnabled
        public Map<String, String> fundingRequestLabels,
            disbursementLabels,
            uiMessages,
            intervalTypes;

        public Request(Schema.Funding_Request__c r) {
            this.recordId = r.Id;
            this.contactName = r.Applying_Contact__r.Name;
            this.requestedAmount = r.Requested_Amount__c;
            this.awardedAmount = r.Awarded_Amount__c;
            this.totalDisbursed = r.Total_Disbursed__c;
            this.totalRemaining = r.Total_Remaining__c;

            // Send Field labels and labels needed in the helper.
            this.fundingRequestLabels = new Map<String, String>{
                'Applying_Contact__c' => Schema.SObjectType.Funding_Request__c.fields.Applying_Contact__c.getLabel(),
                'Requested_Amount__c' => Schema.SObjectType.Funding_Request__c.fields.Requested_Amount__c.getLabel(),
                'Awarded_Amount__c' => Schema.SObjectType.Funding_Request__c.fields.Awarded_Amount__c.getLabel(),
                'Total_Disbursed__c' => Schema.SObjectType.Funding_Request__c.fields.Total_Disbursed__c.getLabel(),
                'Total_Remaining__c' => Schema.SObjectType.Funding_Request__c.fields.Total_Remaining__c.getLabel()
            };

            this.disbursementLabels = new Map<String, String>{
                'Amount__c' => Schema.SObjectType.Disbursement__c.fields.Amount__c.getLabel(),
                'Scheduled_Date__c' => Schema.SObjectType.Disbursement__c.fields.Scheduled_Date__c.getLabel()
            };

            this.uiMessages = new Map<String, String>{
                'Error' => System.Label.Error,
                'NoFundsRemaining' => System.Label.disbursementsCreate_NoFundsRemaining,
                'PaymentsExceedFunds' => System.Label.disbursementsCreate_PaymentsExceedFunds,
                'SavedMessage' => System.Label.disbursementsCreate_SavedMessage,
                'NoAccess' => System.Label.DatabaseService_NoInsertFlsException
            };

            this.intervalTypes = new Map<String, String>{
                'Week' => System.Label.disbursementsCreate_IntervalType_Week,
                'Month' => System.Label.disbursementsCreate_IntervalType_Month,
                'Year' => System.Label.disbursementsCreate_IntervalType_Year
            };
        }
    }

    public class Disbursement {
        public Decimal amount;
        public Id requestId;
        public Date scheduleDate;
        public String status;

        public Disbursement() {
        }
    }
}
