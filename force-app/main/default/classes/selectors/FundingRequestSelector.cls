public with sharing class FundingRequestSelector {
    public List<Funding_Request__c> getFundingRequestById(String reqId) {
        return [
            SELECT
                Id,
                Requested_Amount__c,
                Awarded_Amount__c,
                Total_Disbursed__c,
                Total_Remaining__c,
                Applying_Contact__r.Name
            FROM Funding_Request__c
            WHERE Id = :reqId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }
}
