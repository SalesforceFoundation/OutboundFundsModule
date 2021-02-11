@isTest
public with sharing class DatabaseService_TEST {
    private static TestUser.MinimalAccessPersona minimalAccessPersona = new TestUser.MinimalAccessPersona();

    private static Account getAccount() {
        return [SELECT Id, AccountNumber FROM Account LIMIT 1][0];
    }

    @TestSetup
    public static void testSetup() {
        TestUser.insertPersonasInTestSetup(
            new List<TestUser.Persona>{ DatabaseService_TEST.minimalAccessPersona }
        );

        DatabaseService_TEST.minimalAccessPersona.load();

        insert new Account(
            Name = 'Pi (approximately)',
            AccountNumber = '3.14159',
            // Owner will grant all sharing access to the record so we can test object-level permissions.
            OwnerId = DatabaseService_TEST.minimalAccessPersona.getUser().Id
        );
    }

    @IsTest
    private static void testInsertRecordsEnforceFls_NoObjectLevelPermission() {
        // Load TestUser.Persona and assert the object-level and field-level are as expected for this test.
        DatabaseService_TEST.minimalAccessPersona.load();

        // Set arguments.
        final List<Account> records = new List<Account>{
            new Account(Name = 'Account 0', AccountNumber = '0'),
            new Account(Name = 'Account 1', AccountNumber = '1')
        };

        Test.startTest();

        Exception actualException;

        System.runAs(DatabaseService_TEST.minimalAccessPersona.getUser()) {
            // Assert permissions are as expected.
            System.assert(
                !Schema.Account.SObjectType.getDescribe().isCreateable(),
                'DatabaseService_TEST.minimalAccessPersona should not be able to create Account.'
            );

            final DatabaseService service = new DatabaseService();

            // Null records.
            final List<Database.SaveResult> actualWhenNullRecords = service.insertRecordsEnforceFls(
                (List<Account>) null
            );
            System.assertNotEquals(
                null,
                actualWhenNullRecords,
                'DatabaseService.insertRecordsEnforceFls should never return null.'
            );
            System.assert(
                actualWhenNullRecords.isEmpty(),
                'DatabaseService.insertRecordsEnforceFls should always return an empty list whenever the records argument is null.  CRUD or FLS is not checked.'
            );

            final List<Database.SaveResult> actualWhenEmptyRecords = service.insertRecordsEnforceFls(
                new List<Account>()
            );
            System.assertNotEquals(
                null,
                actualWhenEmptyRecords,
                'DatabaseService.insertRecordsEnforceFls should never return null.'
            );
            System.assert(
                actualWhenEmptyRecords.isEmpty(),
                'DatabaseService.insertRecordsEnforceFls should always return an empty list whenever the records argument is empty.  CRUD or FLS is not checked.'
            );

            try {
                service.insertRecordsEnforceFls(records);
            } catch (Exception e) {
                actualException = e;
            }
        }

        Test.stopTest();

        System.assert(
            actualException instanceof System.NoAccessException,
            'DatabaseService.insertRecordsEnforceFls should throw a System.NoAccessException since the user does not have Create object-level access on Account.  Actual Exception: ' +
            actualException
        );
    }

    @IsTest
    private static void testInsertRecordsEnforceFls_MissingFieldLevelPermission() {
        // Load TestUser.Persona and assert the object-level and field-level are as expected for this test.
        DatabaseService_TEST.minimalAccessPersona.load();

        TestUser.PermissionSetManager permissionSetManager = DatabaseService_TEST.minimalAccessPersona.getPermissionSetManager();

        TestUser.ObjectPermission objectPermission = permissionSetManager.getObjectPermission(
                Schema.SObjectType.Account
            )
            .setRead(true)
            .setCreate(true);

        TestUser.FieldPermission fieldPermission = objectPermission.getFieldPermission(
                Schema.SObjectType.Account.fields.AccountNumber
            )
            .setRead(false)
            .setEdit(false);

        permissionSetManager.save();

        // Set arguments.
        final List<Account> records = new List<Account>{
            new Account(Name = 'Account 0', AccountNumber = '0'),
            new Account(Name = 'Account 1', AccountNumber = '1')
        };

        Test.startTest();

        Exception actualException;

        System.runAs(DatabaseService_TEST.minimalAccessPersona.getUser()) {
            // Assert permissions are as expected.
            System.assert(
                Schema.Account.SObjectType.getDescribe().isCreateable(),
                'DatabaseService_TEST.minimalAccessPersona should be able to create Account.'
            );

            System.assert(
                !Schema.Account.SObjectType.fields.AccountNumber.getDescribe()
                    .isCreateable(),
                'DatabaseService_TEST.minimalAccessPersona should not be able to create Account.AccountNumber.'
            );

            final DatabaseService service = new DatabaseService();

            // Null records.
            final List<Database.SaveResult> actualWhenNullRecords = service.insertRecordsEnforceFls(
                (List<Account>) null
            );
            System.assertNotEquals(
                null,
                actualWhenNullRecords,
                'DatabaseService.insertRecordsEnforceFls should never return null.'
            );
            System.assert(
                actualWhenNullRecords.isEmpty(),
                'DatabaseService.insertRecordsEnforceFls should always return an empty list whenever the records argument is null.  CRUD or FLS is not checked.'
            );

            final List<Database.SaveResult> actualWhenEmptyRecords = service.insertRecordsEnforceFls(
                new List<Account>()
            );
            System.assertNotEquals(
                null,
                actualWhenEmptyRecords,
                'DatabaseService.insertRecordsEnforceFls should never return null.'
            );
            System.assert(
                actualWhenEmptyRecords.isEmpty(),
                'DatabaseService.insertRecordsEnforceFls should always return an empty list whenever the records argument is empty.  CRUD or FLS is not checked.'
            );

            try {
                service.insertRecordsEnforceFls(records);
            } catch (Exception e) {
                actualException = e;
            }
        }

        Test.stopTest();

        System.assert(
            actualException instanceof System.NoAccessException,
            'DatabaseService.insertRecordsEnforceFls should throw a System.NoAccessException since the user does not have Edit field-level access on Account.AccountNumber.  Actual Exception: ' +
            actualException
        );
        System.assertEquals(
            System.Label.DatabaseService_NoInsertFlsException,
            actualException.getMessage(),
            'DatabaseService.insertRecordsEnforceFls should throw a System.NoAccessException whose message equals System.Label.DatabaseService_NoInsertFlsException ("' +
            System.Label.DatabaseService_NoInsertFlsException +
            '").'
        );
    }

    @IsTest
    private static void testInsertRecordsEnforceFls_WithFieldLevelPermission() {
        // Load TestUser.Persona and assert the object-level and field-level are as expected for this test.
        DatabaseService_TEST.minimalAccessPersona.load();

        TestUser.PermissionSetManager permissionSetManager = DatabaseService_TEST.minimalAccessPersona.getPermissionSetManager();

        TestUser.ObjectPermission objectPermission = permissionSetManager.getObjectPermission(
                Schema.SObjectType.Account
            )
            .setRead(true)
            .setCreate(true);

        TestUser.FieldPermission fieldPermission = objectPermission.getFieldPermission(
                Schema.SObjectType.Account.fields.AccountNumber
            )
            .setRead(true)
            .setEdit(true);

        permissionSetManager.save();

        // Set arguments.
        final List<Account> records = new List<Account>{
            new Account(Name = 'Account 0', AccountNumber = '0'),
            new Account(Name = 'Account 1', AccountNumber = '1')
        };

        Test.startTest();

        List<Database.SaveResult> actual;

        System.runAs(DatabaseService_TEST.minimalAccessPersona.getUser()) {
            // Assert permissions are as expected.
            System.assert(
                Schema.Account.SObjectType.getDescribe().isCreateable(),
                'DatabaseService_TEST.minimalAccessPersona should be able to create Account.'
            );

            System.assert(
                Schema.Account.SObjectType.fields.AccountNumber.getDescribe()
                    .isCreateable(),
                'DatabaseService_TEST.minimalAccessPersona should be able to create Account.AccountNumber.'
            );

            final DatabaseService service = new DatabaseService();

            // Null records.
            final List<Database.SaveResult> actualWhenNullRecords = service.insertRecordsEnforceFls(
                (List<Account>) null
            );
            System.assertNotEquals(
                null,
                actualWhenNullRecords,
                'DatabaseService.insertRecordsEnforceFls should never return null.'
            );
            System.assert(
                actualWhenNullRecords.isEmpty(),
                'DatabaseService.insertRecordsEnforceFls should always return an empty list whenever the records argument is null.  CRUD or FLS is not checked.'
            );

            // Empty records.
            final List<Database.SaveResult> actualWhenEmptyRecords = service.insertRecordsEnforceFls(
                new List<Account>()
            );
            System.assertNotEquals(
                null,
                actualWhenEmptyRecords,
                'DatabaseService.insertRecordsEnforceFls should never return null.'
            );
            System.assert(
                actualWhenEmptyRecords.isEmpty(),
                'DatabaseService.insertRecordsEnforceFls should always return an empty list whenever the records argument is empty.  CRUD or FLS is not checked.'
            );

            // Actual test.
            actual = service.insertRecordsEnforceFls(records);
        }

        Test.stopTest();

        System.assertNotEquals(
            null,
            actual,
            'DatabaseService.insertRecordsEnforceFls should never return null.'
        );

        final Integer recordsSize = records.size();

        System.assertEquals(
            recordsSize,
            actual.size(),
            'DatabaseService.insertRecordsEnforceFls should return a Database.SaveResult for each record in records.'
        );

        for (Integer i = 0; i < recordsSize; i++) {
            System.assert(
                actual[i].isSuccess(),
                'actual[' +
                i +
                '].isSuccess should be true.'
            );
            System.assertNotEquals(
                null,
                actual[i].getId(),
                'actual[' +
                i +
                '].getId should not be null.'
            );
            System.assertEquals(
                records[i].Id,
                actual[i].getId(),
                'records[' +
                i +
                '].Id should equal actual[' +
                i +
                '].getId.'
            );
        }

        System.assertEquals(
            recordsSize,
            [SELECT Id FROM Account WHERE Id IN :records].size(),
            'All records should exist in the Database.'
        );
    }

    @IsTest
    private static void updateRecordsEnforceFls_NoObjectLevelPermission() {
        // Load TestUser.Persona and assert the object-level and field-level are as expected for this test.
        DatabaseService_TEST.minimalAccessPersona.load();

        // Set arguments.
        final Account originalRecord = DatabaseService_TEST.getAccount();
        final List<Account> records = new List<Account>{
            new Account(
                Id = originalRecord.Id,
                Name = 'new Name',
                AccountNumber = 'new Account Number'
            )
        };

        Test.startTest();

        Exception actualException;

        System.runAs(DatabaseService_TEST.minimalAccessPersona.getUser()) {
            // Assert permissions are as expected.
            System.assert(
                !Schema.Account.SObjectType.getDescribe().isUpdateable(),
                'DatabaseService_TEST.minimalAccessPersona should not be able to  update Account.'
            );

            final DatabaseService service = new DatabaseService();

            // Null records.
            final List<Database.SaveResult> actualWhenNullRecords = service.updateRecordsEnforceFls(
                (List<Account>) null
            );
            System.assertNotEquals(
                null,
                actualWhenNullRecords,
                'DatabaseService.updateRecordsEnforceFls should never return null.'
            );
            System.assert(
                actualWhenNullRecords.isEmpty(),
                'DatabaseService.updateRecordsEnforceFls should always return an empty list whenever the records argument is null.  CRUD or FLS is not checked.'
            );

            final List<Database.SaveResult> actualWhenEmptyRecords = service.updateRecordsEnforceFls(
                new List<Account>()
            );
            System.assertNotEquals(
                null,
                actualWhenEmptyRecords,
                'DatabaseService.updateRecordsEnforceFls should never return null.'
            );
            System.assert(
                actualWhenEmptyRecords.isEmpty(),
                'DatabaseService.updateRecordsEnforceFls should always return an empty list whenever the records argument is empty.  CRUD or FLS is not checked.'
            );

            try {
                service.updateRecordsEnforceFls(records);
            } catch (Exception e) {
                actualException = e;
            }
        }

        Test.stopTest();

        System.assert(
            actualException instanceof System.NoAccessException,
            'DatabaseService.updateRecordsEnforceFls should throw a System.NoAccessException since the user does not have Update object-level access on Account.  Actual Exception: ' +
            actualException
        );
    }

    @IsTest
    private static void updateRecordsEnforceFls_MissingFieldLevelPermission() {
        // Load TestUser.Persona and assert the object-level and field-level are as expected for this test.
        DatabaseService_TEST.minimalAccessPersona.load();

        TestUser.PermissionSetManager permissionSetManager = DatabaseService_TEST.minimalAccessPersona.getPermissionSetManager();

        TestUser.ObjectPermission objectPermission = permissionSetManager.getObjectPermission(
                Schema.SObjectType.Account
            )
            .setRead(true)
            .setEdit(true);

        TestUser.FieldPermission fieldPermission = objectPermission.getFieldPermission(
                Schema.SObjectType.Account.fields.AccountNumber
            )
            .setRead(false)
            .setEdit(false);

        permissionSetManager.save();

        // Set arguments.
        final Account originalRecord = DatabaseService_TEST.getAccount();
        final List<Account> records = new List<Account>{
            new Account(
                Id = originalRecord.Id,
                Name = 'new Name',
                AccountNumber = 'new Account Number'
            )
        };

        Test.startTest();

        Exception actualException;

        System.runAs(DatabaseService_TEST.minimalAccessPersona.getUser()) {
            // Assert permissions are as expected.
            System.assert(
                Schema.Account.SObjectType.getDescribe().isUpdateable(),
                'DatabaseService_TEST.minimalAccessPersona should be able to update Account.'
            );

            System.assert(
                !Schema.Account.SObjectType.fields.AccountNumber.getDescribe()
                    .isUpdateable(),
                'DatabaseService_TEST.minimalAccessPersona should not be able to update Account.AccountNumber.'
            );

            final DatabaseService service = new DatabaseService();

            // Null records.
            final List<Database.SaveResult> actualWhenNullRecords = service.updateRecordsEnforceFls(
                (List<Account>) null
            );
            System.assertNotEquals(
                null,
                actualWhenNullRecords,
                'DatabaseService.updateRecordsEnforceFls should never return null.'
            );
            System.assert(
                actualWhenNullRecords.isEmpty(),
                'DatabaseService.updateRecordsEnforceFls should always return an empty list whenever the records argument is null.  CRUD or FLS is not checked.'
            );

            final List<Database.SaveResult> actualWhenEmptyRecords = service.updateRecordsEnforceFls(
                new List<Account>()
            );
            System.assertNotEquals(
                null,
                actualWhenEmptyRecords,
                'DatabaseService.updateRecordsEnforceFls should never return null.'
            );
            System.assert(
                actualWhenEmptyRecords.isEmpty(),
                'DatabaseService.updateRecordsEnforceFls should always return an empty list whenever the records argument is empty.  CRUD or FLS is not checked.'
            );

            try {
                service.updateRecordsEnforceFls(records);
            } catch (Exception e) {
                actualException = e;
            }
        }

        Test.stopTest();

        System.assert(
            actualException instanceof System.NoAccessException,
            'DatabaseService.updateRecordsEnforceFls should throw a System.NoAccessException since the user does not have Edit field-level access on Account.AccountNumber.  Actual Exception: ' +
            actualException
        );
        System.assertEquals(
            System.Label.DatabaseService_NoUpdateFlsException,
            actualException.getMessage(),
            'DatabaseService.updateRecordsEnforceFls should throw a System.NoAccessException whose message equals System.Label.DatabaseService_NoUpdateFlsException ("' +
            System.Label.DatabaseService_NoUpdateFlsException +
            '").'
        );
    }

    @IsTest
    private static void updateRecordsEnforceFls_WithFieldLevelPermission() {
        // Load TestUser.Persona and assert the object-level and field-level are as expected for this test.
        DatabaseService_TEST.minimalAccessPersona.load();

        TestUser.PermissionSetManager permissionSetManager = DatabaseService_TEST.minimalAccessPersona.getPermissionSetManager();

        TestUser.ObjectPermission objectPermission = permissionSetManager.getObjectPermission(
                Schema.SObjectType.Account
            )
            .setRead(true)
            .setEdit(true);

        TestUser.FieldPermission fieldPermission = objectPermission.getFieldPermission(
                Schema.SObjectType.Account.fields.AccountNumber
            )
            .setRead(true)
            .setEdit(true);

        permissionSetManager.save();

        // Set arguments.
        final Account originalRecord = DatabaseService_TEST.getAccount();
        final List<Account> records = new List<Account>{
            new Account(
                Id = originalRecord.Id,
                Name = 'new Name',
                AccountNumber = 'new Account Number'
            )
        };

        Test.startTest();

        List<Database.SaveResult> actual;

        System.runAs(DatabaseService_TEST.minimalAccessPersona.getUser()) {
            // Assert permissions are as expected.
            System.assert(
                Schema.Account.SObjectType.getDescribe().isUpdateable(),
                'DatabaseService_TEST.minimalAccessPersona should be able to update Account.'
            );

            System.assert(
                Schema.Account.SObjectType.fields.AccountNumber.getDescribe()
                    .isUpdateable(),
                'DatabaseService_TEST.minimalAccessPersona should be able to update Account.AccountNumber.'
            );

            final DatabaseService service = new DatabaseService();

            // Null records.
            final List<Database.SaveResult> actualWhenNullRecords = service.updateRecordsEnforceFls(
                (List<Account>) null
            );
            System.assertNotEquals(
                null,
                actualWhenNullRecords,
                'DatabaseService.updateRecordsEnforceFls should never return null.'
            );
            System.assert(
                actualWhenNullRecords.isEmpty(),
                'DatabaseService.updateRecordsEnforceFls should always return an empty list whenever the records argument is null.  CRUD or FLS is not checked.'
            );

            // Empty records.
            final List<Database.SaveResult> actualWhenEmptyRecords = service.updateRecordsEnforceFls(
                new List<Account>()
            );
            System.assertNotEquals(
                null,
                actualWhenEmptyRecords,
                'DatabaseService.updateRecordsEnforceFls should never return null.'
            );
            System.assert(
                actualWhenEmptyRecords.isEmpty(),
                'DatabaseService.updateRecordsEnforceFls should always return an empty list whenever the records argument is empty.  CRUD or FLS is not checked.'
            );

            // Actual test.
            actual = service.updateRecordsEnforceFls(records);
        }

        Test.stopTest();

        System.assertNotEquals(
            null,
            actual,
            'DatabaseService.updateRecordsEnforceFls should never return null.'
        );

        final Integer recordsSize = records.size();

        System.assertEquals(
            recordsSize,
            actual.size(),
            'DatabaseService.updateRecordsEnforceFls should return a Database.SaveResult for each record in records.'
        );

        for (Integer i = 0; i < recordsSize; i++) {
            System.assert(
                actual[i].isSuccess(),
                'actual[' +
                i +
                '].isSuccess should be true.'
            );
            System.assertNotEquals(
                null,
                actual[i].getId(),
                'actual[' +
                i +
                '].getId should not be null.'
            );
            System.assertEquals(
                records[i].Id,
                actual[i].getId(),
                'records[' +
                i +
                '].Id should equal actual[' +
                i +
                '].getId.'
            );
        }

        System.assertEquals(
            recordsSize,
            [
                    SELECT Id
                    FROM Account
                    WHERE
                        Id = :originalRecord.Id
                        AND Name = :records[0].Name
                        AND AccountNumber = :records[0].AccountNumber
                ]
                .size(),
            'All records should have been updated in the Database.'
        );
    }

    @IsTest
    private static void deleteRecords_NoObjectLevelPermission() {
        // Load TestUser.Persona and assert the object-level and field-level are as expected for this test.
        DatabaseService_TEST.minimalAccessPersona.load();

        // Set arguments.
        final List<Account> records = new List<Account>{
            DatabaseService_TEST.getAccount()
        };

        Test.startTest();

        Exception actualException;

        System.runAs(DatabaseService_TEST.minimalAccessPersona.getUser()) {
            // Assert permissions are as expected.
            System.assert(
                !Schema.Account.SObjectType.getDescribe().isDeletable(),
                'DatabaseService_TEST.minimalAccessPersona should not be able to  delete Account.'
            );

            final DatabaseService service = new DatabaseService();

            // Null records.
            final List<Database.DeleteResult> actualWhenNullRecords = service.deleteRecords(
                (List<Account>) null
            );
            System.assertNotEquals(
                null,
                actualWhenNullRecords,
                'DatabaseService.deleteRecords should never return null.'
            );
            System.assert(
                actualWhenNullRecords.isEmpty(),
                'DatabaseService.deleteRecords should always return an empty list whenever the records argument is null.  CRUD or FLS is not checked.'
            );

            final List<Database.DeleteResult> actualWhenEmptyRecords = service.deleteRecords(
                new List<Account>()
            );
            System.assertNotEquals(
                null,
                actualWhenEmptyRecords,
                'DatabaseService.deleteRecords should never return null.'
            );
            System.assert(
                actualWhenEmptyRecords.isEmpty(),
                'DatabaseService.deleteRecords should always return an empty list whenever the records argument is empty.  CRUD or FLS is not checked.'
            );

            try {
                service.deleteRecords(records);
            } catch (Exception e) {
                actualException = e;
            }
        }

        Test.stopTest();

        System.assert(
            actualException instanceof System.NoAccessException,
            'DatabaseService.deleteRecords should throw a System.NoAccessException since the user does not have Delete object-level access on Account.  Actual Exception: ' +
            actualException
        );
        System.assertEquals(
            System.Label.DatabaseService_NoDeleteAccessException,
            actualException.getMessage(),
            'DatabaseService.deleteRecords should throw a System.NoAccessException whose message equals System.Label.DatabaseService_NoDeleteAccessException ("' +
            System.Label.DatabaseService_NoDeleteAccessException +
            '").'
        );
    }

    @IsTest
    private static void deleteRecords_WithObjectLevelPermission() {
        // Load TestUser.Persona and assert the object-level and field-level are as expected for this test.
        DatabaseService_TEST.minimalAccessPersona.load();

        TestUser.PermissionSetManager permissionSetManager = DatabaseService_TEST.minimalAccessPersona.getPermissionSetManager();

        TestUser.ObjectPermission objectPermission = permissionSetManager.getObjectPermission(
                Schema.SObjectType.Account
            )
            .setRead(true)
            .setEdit(true)
            .setDelete(true);

        permissionSetManager.save();

        // Set arguments.
        final List<Account> records = new List<Account>{
            DatabaseService_TEST.getAccount()
        };

        Test.startTest();

        List<Database.DeleteResult> actual;

        System.runAs(DatabaseService_TEST.minimalAccessPersona.getUser()) {
            // Assert permissions are as expected.
            System.assert(
                Schema.Account.SObjectType.getDescribe().isDeletable(),
                'DatabaseService_TEST.minimalAccessPersona should be able to delete Account.'
            );

            final DatabaseService service = new DatabaseService();

            // Null records.
            final List<Database.DeleteResult> actualWhenNullRecords = service.deleteRecords(
                (List<Account>) null
            );
            System.assertNotEquals(
                null,
                actualWhenNullRecords,
                'DatabaseService.deleteRecords should never return null.'
            );
            System.assert(
                actualWhenNullRecords.isEmpty(),
                'DatabaseService.deleteRecords should always return an empty list whenever the records argument is null.  CRUD or FLS is not checked.'
            );

            // Empty records.
            final List<Database.DeleteResult> actualWhenEmptyRecords = service.deleteRecords(
                new List<Account>()
            );
            System.assertNotEquals(
                null,
                actualWhenEmptyRecords,
                'DatabaseService.deleteRecords should never return null.'
            );
            System.assert(
                actualWhenEmptyRecords.isEmpty(),
                'DatabaseService.deleteRecords should always return an empty list whenever the records argument is empty.  CRUD or FLS is not checked.'
            );

            // Actual test.
            actual = service.deleteRecords(records);
        }

        Test.stopTest();

        System.assertNotEquals(
            null,
            actual,
            'DatabaseService.deleteRecords should never return null.'
        );

        final Integer recordsSize = records.size();

        System.assertEquals(
            recordsSize,
            actual.size(),
            'DatabaseService.deleteRecords should return a Database.DeleteResult for each record in records.'
        );

        for (Integer i = 0; i < recordsSize; i++) {
            System.assert(
                actual[i].isSuccess(),
                'actual[' +
                i +
                '].isSuccess should be true.'
            );
            System.assertNotEquals(
                null,
                actual[i].getId(),
                'actual[' +
                i +
                '].getId should not be null.'
            );
            System.assertEquals(
                records[i].Id,
                actual[i].getId(),
                'records[' +
                i +
                '].Id should equal actual[' +
                i +
                '].getId.'
            );
        }

        System.assert(
            [SELECT Id FROM Account WHERE Id IN :records].isEmpty(),
            'All records should have been deleted in the Database.'
        );
    }

    @IsTest
    private static void setSavepointAndRollback() {
        // Load TestUser.Persona and assert the object-level and field-level are as expected for this test.
        DatabaseService_TEST.minimalAccessPersona.load();

        TestUser.PermissionSetManager permissionSetManager = DatabaseService_TEST.minimalAccessPersona.getPermissionSetManager();

        TestUser.ObjectPermission objectPermission = permissionSetManager.getObjectPermission(
                Schema.SObjectType.Account
            )
            .setRead(true)
            .setEdit(true)
            .setDelete(true);

        permissionSetManager.save();

        // Set arguments.
        final List<Account> records = new List<Account>{
            DatabaseService_TEST.getAccount()
        };

        Test.startTest();

        System.runAs(DatabaseService_TEST.minimalAccessPersona.getUser()) {
            final DatabaseService service = new DatabaseService();

            // Create a savepoint.
            final DatabaseService.Savepoint savepoint = service.setSavepoint();

            System.assertNotEquals(
                null,
                savepoint.savepoint,
                'DatabaseService.setSavepoint should set the DatabaseService.Savepoint.savepoint.'
            );

            // Delete records.
            service.deleteRecords(records);

            // Rollback the transaction.
            service.rollback(savepoint);
        }

        Test.stopTest();

        System.assert(
            ![SELECT Id FROM Account WHERE Id IN :records LIMIT 1].isEmpty(),
            'No records should have been deleted because the transaction should have been rolled back.'
        );
    }

    /**
     * Tests that we can mock rolling back because DatabaseService.Savepoint has an @TestVisible empty constructor.
     */
    @IsTest
    private static void mockRollingBack() {
        // Set mock return values.
        final DatabaseService.Savepoint expected = new DatabaseService.Savepoint();

        System.assertEquals(
            null,
            expected.savepoint,
            '@TestVisible private Database.Savepoint() constructor should not set Database.Savepoint.savepoint.  Only DatabaseService.setSavepoint should set Database.Savepoint.savepoint.'
        );

        final UnitTest.Mock databaseServiceMock = new UnitTest.Mock();

        final UnitTest.Mock setSavepoint = databaseServiceMock.getMethod('setSavepoint');
        setSavepoint.returnValue = expected;

        final UnitTest.Mock rollbackMethod = databaseServiceMock.getMethod('rollback');

        Test.startTest();

        final DatabaseService service = (DatabaseService) databaseServiceMock.createStub(
            DatabaseService.class
        );

        final DatabaseService.Savepoint actual = service.setSavepoint();

        service.rollback(actual);

        Test.stopTest();

        System.assertEquals(
            expected,
            actual,
            'setSavepoint should have returned exactly (===) the mocked return value.'
        );

        setSavepoint.assertCalledOnceWith(new List<Object>());

        rollbackMethod.assertCalledOnceWith(new List<Object>{ setSavepoint.returnValue });
    }
}
