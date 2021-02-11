public with sharing class DatabaseService {
    public List<Database.SaveResult> insertRecordsEnforceFls(List<SObject> records) {
        if (records == null || records.isEmpty()) {
            return new List<Database.SaveResult>();
        }

        // Security.stripInaccessible verifies object-level permissions.
        System.SObjectAccessDecision accessDecision = Security.stripInaccessible(
            System.AccessType.CREATABLE,
            records,
            true
        );

        // Enforce all field-level permissions by checking if any fields were removed in the accessDecision implying the user does not have the proper field-level permission for this operation.
        if (!accessDecision.getRemovedFields().isEmpty()) {
            System.NoAccessException e = new System.NoAccessException();
            e.setMessage(System.Label.DatabaseService_NoInsertFlsException);
            throw e;
        }

        // Database.insert should set IDs on records.
        return Database.insert(records);
    }

    public List<Database.SaveResult> updateRecordsEnforceFls(List<SObject> records) {
        if (records == null || records.isEmpty()) {
            return new List<Database.SaveResult>();
        }

        // Security.stripInaccessible verifies object-level permissions.
        System.SObjectAccessDecision accessDecision = Security.stripInaccessible(
            System.AccessType.UPDATABLE,
            records,
            true
        );

        // Enforce all field-level permissions by checking if any fields were removed in the accessDecision implying the user does not have the proper field-level permission for this operation.
        if (!accessDecision.getRemovedFields().isEmpty()) {
            System.NoAccessException e = new System.NoAccessException();
            e.setMessage(System.Label.DatabaseService_NoUpdateFlsException);
            throw e;
        }

        return Database.update(records);
    }

    public List<Database.DeleteResult> deleteRecords(List<SObject> records) {
        if (records == null || records.isEmpty()) {
            return new List<Database.DeleteResult>();
        }

        // TODO: What do we do if records contains more than one SobjectType?
        final Schema.DescribeSObjectResult describe = records.getSObjectType()
            .getDescribe();

        if (!describe.isDeletable()) {
            System.NoAccessException e = new System.NoAccessException();
            e.setMessage(System.Label.DatabaseService_NoDeleteAccessException);
            throw e;
        }

        return Database.delete(records);
    }

    /**
     * Stubbable "wrapper" of System.Savepoint.  Instances are constructed with a
     * null System.Savepoint, so instances can be safely stubbed in unit tests.
     */
    public with sharing class Savepoint {
        @TestVisible
        private System.Savepoint savepoint;

        /**
         * Private access so production code cannot construct this class.
         * Production code must go through DatabaseService.Savepoint setSavepoint().
         */
        @TestVisible
        private Savepoint() {
        }
    }

    /**
     * This is the only way to get a DatabaseService.Savepoint in production code.
     * @return   A DatabaseService.Savepoint with its System.Savepoint set.
     */
    public DatabaseService.Savepoint setSavepoint() {
        final DatabaseService.Savepoint savepoint = new DatabaseService.Savepoint();
        savepoint.savepoint = System.Database.setSavepoint();
        return savepoint;
    }

    /**
     * Rolls back to the savepoint's System.Savepoint.
     * @param  savepoint Pass in a DatabaseService.Savepoint returned by setSavepoint().
     */
    public void rollback(DatabaseService.Savepoint savepoint) {
        System.Database.rollback(savepoint.savepoint);
    }
}
