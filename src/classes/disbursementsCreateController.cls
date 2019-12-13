/**
 * Controller for disbursementsCreate Lightning Component.
 * This class is contains some basic Models that Are used to
 * display Data in the UI, as well as handles the requests from the UI.
 */
public with sharing class disbursementsCreateController {

    /**
     * This Method is the entry point for the Lightning Component to receive data about the funding request
     *
     * @param reqId - The Id of the funding request parent of the discbursements that will be created.
     *
     * @return Request - the request model
     */
    @AuraEnabled
    public static Request getFundRequest(Id reqId) {
        return getRequest(reqId);
    }

    /**
     * This method is called to save a list of disbursements to the database
     *
     * @param dispListString - A serialized string which is a list of Disbursements
     */
    @AuraEnabled
    public static void saveDisbursements(String dispListString) {

        List<Disbursement> dList = transformList(dispListString);

        List<Disbursement__c> newDispList = new List<Disbursement__c>();

        for (Disbursement d : dList) {
            newDispList.add( mapDisbursement(d) );
        }

        insert newDispList;
    }

    /**
     * Return a Request from the database. THis method also functions as a mapper to separate the database from the front end.
     *
     * @param reqId - Id of the request we want information about
     *
     * @return - Request model
     */
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

    /**
     * A quick mapper method to convert a Disbursement into a Disbursement__c
     *
     * @param d - Disbursement
     *
     * @return - Disbursement__c
     */
    private static Disbursement__c mapDisbursement(Disbursement d) {

        return new Disbursement__c(
            Amount__c = d.amount,
            Funding_Request__c = d.requestId,
            Scheduled_Date__c = d.scheduleDate,
            Status__c = 'Scheduled'
        );
    }

    /**
    * Deserialization wrapper to include other needed adjustments
    *
    * @param dispListString - json string of Disbursement
    *
    * @return - List<Disbursement__c>
    */
    private static List<Disbursement> transformList(String dispListString) {
      List<Disbursement> dList = (List<Disbursement>)
            JSON.deserialize(dispListString, List<Disbursement>.class);

      for (Disbursement d : dlist) {
        d.scheduleDate = d.scheduleDate.addDays(1);
      }

      return dList;
    }

    /*** Models ***/

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
