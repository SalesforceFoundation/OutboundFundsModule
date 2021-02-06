public with sharing class DatabaseService {
    public List<Database.DeleteResult> deleteRecords(List<SObject> records) {
        if (records == null || records.isEmpty()) {
            return new List<Database.DeleteResult>();
        }

        // No OOTB System service to check for object-level access.
        // Forcing the records parameter with type List<Sobject> (hopefully) forces a single SobjectType.
        final Schema.DescribeSObjectResult describe = records.getSObjectType()
            .getDescribe();

        if (!describe.isDeletable()) {
            System.NoAccessException e = new System.NoAccessException();
            e.setMessage(System.Label.DatabaseService_NoDeleteAccessException);
        }

        return Database.delete(records);
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
            e.setMessage(System.Label.DatabaseService_NoEditFlsException);
            throw e;
        }

        return Database.update(records);
    }

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
            e.setMessage(
                'Insert Exception. Remove fields: ' + accessDecision.getRemovedFields()
            );
            throw e;
        }

        return Database.insert(records);
    }
}
