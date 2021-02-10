@IsTest
public with sharing class TestUser {
    public with sharing virtual class MinimalAccessPersona extends TestUser.Persona {
        public MinimalAccessPersona() {
            super();
        }

        public virtual override Type getType() {
            return TestUser.MinimalAccessPersona.class;
        }

        public virtual override String getUsername() {
            return 'TestUser.MinimalAccessPersona@sfdo.example.com';
        }

        public override String getProfileName() {
            return 'Minimum Access - Salesforce';
        }

        public virtual override List<String> getPermissionSetsToAssign() {
            return new List<String>{};
        }

        public virtual override List<String> getPermissionSetLicensesToAssign() {
            return new List<String>();
        }
    }

    public static Schema.UserRole insertNewUserRole() {
        Integer tries = 0;
        final Integer maxTries = 10;
        while (tries < maxTries) {
            final String developerName = (TestUser.class.getName().replace('.', '_') +
                Math.abs(Crypto.getRandomInteger()))
                .left(Schema.SObjectType.UserRole.fields.DeveloperName.getLength());

            final Schema.UserRole userRole = new Schema.UserRole(
                DeveloperName = developerName,
                Name = developerName
            );
            try {
                insert userRole;
                return userRole;
            } catch (Exception e) {
                tries++;
            }
        }
        System.assert(
            false,
            String.format(
                'A new, random UserRole could not be created in {0} tries.',
                new List<String>{ String.valueOf(maxTries) }
            )
        );
        return null;
    }

    private static void setUserDefaultValue(
        final Schema.User user,
        final Schema.DescribeFieldResult fieldDescribe,
        final String defaultValue
    ) {
        if (String.isBlank((String) user.get(fieldDescribe.getName()))) {
            user.put(
                fieldDescribe.getName(),
                defaultValue == null ? null : defaultValue.left(fieldDescribe.getLength())
            );
        }
    }

    public static List<String> emptyIfNull(final List<String> value) {
        return value == null ? new List<String>() : value;
    }

    public static void insertPersonasInTestSetup(List<TestUser.Persona> personas) {
        // System.runAs the running to avoid mixed DML and license restrictions.
        final Schema.User runningUser = [
            SELECT Id, UserRoleId
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ][0];

        // To create community users, make sure the running User has a UserRole.
        if (runningUser.UserRoleId == null) {
            // System.runAs the runningUser avoid mixed DML later.
            System.runAs(runningUser) {
                runningUser.UserRoleId = TestUser.insertNewUserRole().Id;
                update runningUser;
            }
        }

        Map<String, TestUser.Persona> personasByUsername = new Map<String, TestUser.Persona>();
        final Integer size = personas.size();
        for (Integer i = 0; i < size; i++) {
            final TestUser.Persona persona = personas[i];
            System.assertNotEquals(
                null,
                persona,
                String.format(
                    'personas[{0}] should not be null.',
                    new List<String>{ String.valueof(i) }
                )
            );

            final String username = persona.getUsername();
            System.assert(
                !String.isBlank(username),
                String.format(
                    'personas[{0}].getUsername() should not return a blank string.',
                    new List<String>{ String.valueof(i) }
                )
            );

            System.assertEquals(
                null,
                personasByUsername.get(username),
                String.format(
                    'personas[{0}].getUsername() should be unique, but a TestUser.Persona already has been added with username  "{1}".',
                    new List<String>{ String.valueOf(i), username }
                )
            );

            // Last Persona with username wins.
            personasByUsername.put(username, persona);
        }

        // Collect information to create users and set user required fields.
        final Map<String, Schema.User> usersByUsername = new Map<String, Schema.User>();
        final Set<String> profileNames = new Set<String>();
        final Set<String> permissionSetLicenseDeveloperNames = new Set<String>();
        // TODO: collect Permission Set Groups to assign.
        final Set<String> permissionSetNames = new Set<String>();

        // System.runAs the runningUser to execute doBeforeInsertingUser() and avoid mixed DML later.
        System.runAs(runningUser) {
            for (String username : personasByUsername.keySet()) {
                final TestUser.Persona persona = personasByUsername.get(username);

                // Collect Profile Name.
                final String profileName = persona.getProfileName();
                System.assert(
                    String.isNotBlank(profileName),
                    String.format(
                        'getProfileName() should not be blank for TestUser.Persona with Username "{0}".',
                        new List<String>{ username }
                    )
                );
                profileNames.add(profileName);

                // Create User and set defaults for required fields with missing values.
                persona.doBeforeInsertingUser();

                final Schema.User user = persona.getUserForInsert();
                System.assertNotEquals(
                    null,
                    user,
                    String.format(
                        'getUserForInsert() should not return null for TestUser.Persona with Username "{0}".',
                        new List<String>{ username }
                    )
                );
                usersByUsername.put(username, user);

                user.Username = username;
                user.IsActive = true;

                TestUser.setUserDefaultValue(
                    user,
                    Schema.SObjectType.User.fields.LastName,
                    username
                );

                TestUser.setUserDefaultValue(
                    user,
                    Schema.SObjectType.User.fields.Alias,
                    username
                );

                TestUser.setUserDefaultValue(
                    user,
                    Schema.SObjectType.User.fields.Email,
                    UserInfo.getUserEmail()
                );

                TestUser.setUserDefaultValue(
                    user,
                    Schema.SObjectType.User.fields.EmailEncodingKey,
                    'UTF-8'
                );

                TestUser.setUserDefaultValue(
                    user,
                    Schema.SObjectType.User.fields.LanguageLocaleKey,
                    'en_US'
                );

                TestUser.setUserDefaultValue(
                    user,
                    Schema.SObjectType.User.fields.LocaleSidKey,
                    'en_US'
                );

                TestUser.setUserDefaultValue(
                    user,
                    Schema.SObjectType.User.fields.TimeZoneSidKey,
                    'America/Los_Angeles'
                );

                // Collect Permission Set Licenses to assign.
                permissionSetLicenseDeveloperNames.addAll(
                    TestUser.emptyIfNull(persona.getPermissionSetLicensesToAssign())
                );

                // Collect Permission Sets to assign.
                permissionSetNames.add(persona.getPermissionSetName());
                permissionSetNames.addAll(
                    TestUser.emptyIfNull(persona.getPermissionSetsToAssign())
                );
            }
        }

        // Get Profiles, Permission Set Licenses to assign, and Permission Sets to assign.
        final Map<String, Id> profileIdsByName = new Map<String, Id>();
        for (Schema.Profile profile : [
            SELECT Id, Name
            FROM Profile
            WHERE Name IN :profileNames
        ]) {
            profileIdsByName.put(profile.Name, profile.Id);
        }

        final Map<String, Id> permissionSetLicenseIdsByDeveloperName = new Map<String, Id>();
        for (Schema.PermissionSetLicense permissionSetLicense : [
            SELECT Id, DeveloperName
            FROM PermissionSetLicense
            WHERE DeveloperName IN :permissionSetLicenseDeveloperNames
        ]) {
            permissionSetLicenseIdsByDeveloperName.put(
                permissionSetLicense.DeveloperName,
                permissionSetLicense.Id
            );
        }

        // TODO: collect Permission Set Groups to assign.

        final Map<String, Id> permissionSetsIdsByName = new Map<String, Id>();
        {
            final Set<String> permissionSetNamesToInsert = new Set<String>(
                permissionSetNames
            );
            for (Schema.PermissionSet permissionSet : [
                SELECT Id, Name
                FROM PermissionSet
                WHERE Name IN :permissionSetNames
            ]) {
                permissionSetsIdsByName.put(permissionSet.Name, permissionSet.Id);
                permissionSetNamesToInsert.remove(permissionSet.Name);
            }

            // Create Permission Sets that don't exist.
            final List<Schema.PermissionSet> permissionSetsToInsert = new List<Schema.PermissionSet>();
            for (String permissionSetName : permissionSetNamesToInsert) {
                permissionSetsToInsert.add(
                    new PermissionSet(Name = permissionSetName, Label = permissionSetName)
                );
            }
            // System.runAs the runningUser to insert permssions and assignments to avoid mixed DML later.
            System.runAs(runningUser) {
                insert permissionSetsToInsert;
            }
            for (Schema.PermissionSet permissionSet : permissionSetsToInsert) {
                permissionSetsIdsByName.put(permissionSet.Name, permissionSet.Id);
            }
        }

        // Assign User Profile IDs and collect Useres.
        final List<Schema.User> users = new List<Schema.User>();

        for (String username : usersByUsername.keySet()) {
            final Schema.User user = usersByUsername.get(username);
            final TestUser.Persona persona = personasByUsername.get(username);

            final String profileName = persona.getProfileName();
            final Id profileId = profileIdsByName.get(profileName);

            System.assertNotEquals(
                null,
                profileId,
                String.format(
                    'No Profile found for Profile Name "{0}" for TestUser.Persona with Username "{1}".',
                    new List<String>{ profileName, username }
                )
            );
            user.ProfileId = profileId;

            users.add(user);
        }

        // Insert Users and assign PSLs and Permission Sets.
        // System.runAs ignores user license limits.
        System.runAs(runningUser) {
            insert users;

            final List<Schema.PermissionSetLicenseAssign> permissionSetLicenseAssigns = new List<Schema.PermissionSetLicenseAssign>();
            final Map<String, Map<String, PermissionSetLicenseAssign>> permissionSetLicenseAssignsByNameByUsername = new Map<String, Map<String, PermissionSetLicenseAssign>>();

            final List<Schema.PermissionSetAssignment> permissionSetAssignments = new List<Schema.PermissionSetAssignment>();
            final Map<String, Map<String, PermissionSetAssignment>> permissionSetAssignmentsByNameByUsername = new Map<String, Map<String, PermissionSetAssignment>>();

            for (String username : personasByUsername.keySet()) {
                final Schema.User user = usersByUsername.get(username);
                final TestUser.Persona persona = personasByUsername.get(username);

                // Track existing assignments so we don't try to insert duplicate assignments.
                Map<String, PermissionSetLicenseAssign> permissionSetLicenseAssignsByName = permissionSetLicenseAssignsByNameByUsername.get(
                    username
                );
                if (permissionSetLicenseAssignsByName == null) {
                    permissionSetLicenseAssignsByName = new Map<String, PermissionSetLicenseAssign>();
                    permissionSetLicenseAssignsByNameByUsername.put(
                        username,
                        permissionSetLicenseAssignsByName
                    );
                }

                Map<String, PermissionSetAssignment> permissionSetAssignmentsByName = permissionSetAssignmentsByNameByUsername.get(
                    username
                );
                if (permissionSetAssignmentsByName == null) {
                    permissionSetAssignmentsByName = new Map<String, PermissionSetAssignment>();
                    permissionSetAssignmentsByNameByUsername.put(
                        username,
                        permissionSetAssignmentsByName
                    );
                }

                // Assign Permission Set Licenses.
                for (
                    String developerName : TestUser.emptyIfNull(
                        persona.getPermissionSetLicensesToAssign()
                    )
                ) {
                    final Id permissionSetLicenseId = permissionSetLicenseIdsByDeveloperName.get(
                        developerName
                    );
                    System.assertNotEquals(
                        null,
                        permissionSetLicenseId,
                        String.format(
                            'No Permission Set License found with DeveloperName "{0}" for TestUser.Persona with Username "{1}".',
                            new List<String>{ developerName, username }
                        )
                    );

                    if (permissionSetLicenseAssignsByName.get(developerName) == null) {
                        final Schema.PermissionSetLicenseAssign assign = new Schema.PermissionSetLicenseAssign(
                            AssigneeId = user.Id,
                            PermissionSetLicenseId = permissionSetLicenseId
                        );

                        permissionSetLicenseAssigns.add(assign);
                        permissionSetLicenseAssignsByName.put(developerName, assign);
                    }
                }

                // Assign Permission Sets.
                final List<String> permissionSetsToAssign = new List<String>{
                    persona.getPermissionSetName()
                };
                permissionSetsToAssign.addAll(
                    TestUser.emptyIfNull(persona.getPermissionSetsToAssign())
                );
                for (String name : permissionSetsToAssign) {
                    final Id permissionSetId = permissionSetsIdsByName.get(name);
                    System.assertNotEquals(
                        null,
                        permissionSetId,
                        String.format(
                            'No Permission Set found with Name "{0}" for TestUser.Persona with Username "{1}".',
                            new List<String>{ name, username }
                        )
                    );

                    if (permissionSetAssignmentsByName.get(name) == null) {
                        final Schema.PermissionSetAssignment assignment = new Schema.PermissionSetAssignment(
                            AssigneeId = user.Id,
                            PermissionSetId = permissionSetId
                        );
                        permissionSetAssignments.add(assignment);
                        permissionSetAssignmentsByName.put(name, assignment);
                    }
                }
            }

            insert permissionSetLicenseAssigns;
            // TODO: insert Permission Set Group Assignments.
            insert permissionSetAssignments;
        }
    }

    public with sharing abstract class Persona {
        protected Schema.User user;
        protected Map<Id, TestUser.PermissionSetManager> permissionSetManagersById;
        protected PermissionSetManager permissionSetManager;

        /**
         * Persona description
         * @return   return description
         */
        public Persona() {
        }

        /**
         * Queries User and sets PermissionSetManagers.
         */
        public void load() {
            final String username = this.getUsername();
            List<Schema.User> users = [
                SELECT
                    Id,
                    Name,
                    ProfileId,
                    Profile.Name,
                    Username,
                    IsActive,
                    FirstName,
                    LastName,
                    Alias,
                    Email,
                    EmailEncodingKey,
                    LanguageLocaleKey,
                    LocaleSidKey,
                    TimeZoneSidKey,
                    ContactId,
                    Contact.AccountId,
                    (
                        SELECT
                            Id,
                            PermissionSetId,
                            PermissionSet.Name,
                            PermissionSet.PermissionSetGroupId,
                            PermissionSet.ProfileId
                        FROM PermissionSetAssignments
                    )
                FROM User
                WHERE Username = :username
                LIMIT 1
            ];
            System.assert(
                !users.isEmpty(),
                String.format(
                    'No User found with Username "{0}".  Is TestUser.insertPersonasInTestSetup(List<TestUser.Persona> personas) called in @TestSetup?',
                    new List<String>{ username }
                )
            );
            this.user = users[0];

            System.assertEquals(
                this.getProfileName(),
                this.user.Profile.Name,
                'User.Profile.Name should equal getProfileName().'
            );

            final Set<Id> permissionSetIds = new Set<Id>();
            Id permissionSetId;
            for (
                Schema.PermissionSetAssignment assignment : this.user.PermissionSetAssignments
            ) {
                permissionSetIds.add(assignment.PermissionSetId);

                if (assignment.PermissionSet.Name == this.getPermissionSetName()) {
                    permissionSetId = assignment.PermissionSetId;
                }
            }

            this.permissionSetManagersById = TestUser.getPermissionSetManagersById(
                permissionSetIds
            );

            this.permissionSetManager = this.permissionSetManagersById.get(
                permissionSetId
            );

            if (this.permissionSetManager == null) {
                System.assert(
                    false,
                    String.format(
                        'The default Permission Set "{0}" was not assigned to this User with Username "{1}" for TestUser.Persona "{2}"',
                        new List<String>{
                            this.getPermissionSetName(),
                            this.getUsername(),
                            this.getType().getName()
                        }
                    )
                );
            }
        }

        /**
         * @return   Username of the User generated for this Persona.  Should be unique within a test.
         */
        public abstract String getUsername();

        /**
         * @return   Name of the Profile for the User generated by this Persona.
         */
        public abstract String getProfileName();

        /**
         * @return   Type of the implementation.  Used to generate a unique Permission Set for the implementation.
         */
        public abstract Type getType();

        /**
         * @return   Name of the empty Permission Set created specifically for this implementation.
         */
        public String getPermissionSetName() {
            return this.getType().getName().replace('.', '_');
        }

        /**
         * Optional method to be executed in the TestUser.insertPersonasInTestSetup method before Users are inserted.
         */
        public virtual void doBeforeInsertingUser() {
        }

        /**
         * Override to set optional User fields, e.g. ContactId.
         * @return   The User to generated for insert.  Username and ProfileId are overridden, and other required User fields are set to a default if not provided.
         */
        public virtual User getUserForInsert() {
            return new User();
        }

        /**
         * @return   DeveloperNames of Permission Set Licenses to assign to the Persona's User.
         */
        public virtual List<String> getPermissionSetLicensesToAssign() {
            return new List<String>();
        }

        /**
         * @return   Names of Permission Sets to assign to the Persona's User.
         */
        public virtual List<String> getPermissionSetsToAssign() {
            return new List<String>();
        }

        protected virtual void assertLoaded() {
            if (this.user == null) {
                System.assert(
                    false,
                    String.format(
                        'load() should have been called before using this TestUser.Persona "{0}".',
                        new List<String>{ this.getType().getName() }
                    )
                );
            }
        }

        public User getUser() {
            this.assertLoaded();
            return this.user;
        }

        public TestUser.PermissionSetManager getPermissionSetManager() {
            this.assertLoaded();
            return this.permissionSetManager;
        }

        public List<TestUser.PermissionSetManager> getPermissionSetManagers() {
            this.assertLoaded();
            return this.permissionSetManagersById.values();
        }

        public TestUser.PermissionSetManager getPermissionSetManager(Id permissionSetId) {
            this.assertLoaded();
            return this.permissionSetManagersById.get(permissionSetId);
        }
    }

    public static Map<Id, TestUser.PermissionSetManager> getPermissionSetManagersById(
        Set<Id> permissionSetIds
    ) {
        final Map<Id, Schema.PermissionSet> permissionSetsById = new Map<Id, Schema.PermissionSet>(
            [
                SELECT
                    Id,
                    Name,
                    ProfileId,
                    (
                        SELECT
                            Id,
                            ParentId,
                            SobjectType,
                            PermissionsRead,
                            PermissionsCreate,
                            PermissionsEdit,
                            PermissionsDelete,
                            PermissionsViewAllRecords,
                            PermissionsModifyAllRecords
                        FROM ObjectPerms // API Name: ObjectPermissions
                        ORDER BY SobjectType
                    ),
                    (
                        SELECT
                            Id,
                            ParentId,
                            SobjectType,
                            Field,
                            PermissionsRead,
                            PermissionsEdit
                        FROM FieldPerms // API Name: FieldPermissions
                        ORDER BY Field
                    )
                FROM PermissionSet
                WHERE Id IN :permissionSetIds
            ]
        );

        final Map<Id, TestUser.PermissionSetManager> permissionSetManagersById = new Map<Id, TestUser.PermissionSetManager>();
        for (Id permissionSetId : permissionSetIds) {
            final Schema.PermissionSet permissionSet = permissionSetsById.get(
                permissionSetId
            );
            System.assertNotEquals(
                null,
                permissionSet,
                String.format(
                    'No Permission Set found with Id "{0}".',
                    new List<String>{ permissionSetId }
                )
            );

            // Don't include Permission Sets associated with Profiles.
            // Modifying Permission Sets associated with Profiles throws Exceptions when trying to save().
            if (permissionSet.ProfileId == null) {
                permissionSetManagersById.put(
                    permissionSetId,
                    new TestUser.PermissionSetManager(permissionSet)
                );
            }
        }

        return permissionSetManagersById;
    }

    public with sharing class PermissionSetManager {
        private final Schema.PermissionSet permissionSet;
        private final Map<String, Schema.ObjectPermissions> objectPermissionRecordsBySObjectType;
        private final Map<String, Map<String, Schema.FieldPermissions>> fieldPermissionRecordsBySObjectTypeByName;
        private final Map<String, TestUser.ObjectPermission> objectPermissionsBySObjectType;

        private PermissionSetManager(final PermissionSet permissionSet) {
            System.assertNotEquals(
                null,
                permissionSet,
                'PermissionSet should not be null for TestUser.'
            );
            this.permissionSet = permissionSet;

            this.objectPermissionsBySObjectType = new Map<String, TestUser.ObjectPermission>();

            // Collect ObjectPerms and FieldPerms so they can be loaded on demand.
            this.objectPermissionRecordsBySObjectType = new Map<String, Schema.ObjectPermissions>();
            for (Schema.ObjectPermissions permission : permissionSet.ObjectPerms) {
                this.objectPermissionRecordsBySObjectType.put(
                    permission.SobjectType,
                    permission
                );
            }

            this.fieldPermissionRecordsBySObjectTypeByName = new Map<String, Map<String, Schema.FieldPermissions>>();
            for (Schema.FieldPermissions permission : permissionSet.FieldPerms) {
                final String sObjectType = permission.SobjectType;
                final String name = permission.Field.substringAfter('.');

                Map<String, Schema.FieldPermissions> objectPermissions = fieldPermissionRecordsBySObjectTypeByName.get(
                    sObjectType
                );
                if (objectPermissions == null) {
                    objectPermissions = new Map<String, Schema.FieldPermissions>();
                    fieldPermissionRecordsBySObjectTypeByName.put(
                        sObjectType,
                        objectPermissions
                    );
                }
                objectPermissions.put(name, permission);
            }
        }

        public String getPermissionSetName() {
            return this.permissionSet.Name;
        }

        public Id getPermissionSetId() {
            return this.permissionSet.Id;
        }

        public TestUser.ObjectPermission getObjectPermission(
            Schema.DescribeSObjectResult objectDescribe
        ) {
            System.assertNotEquals(
                null,
                objectDescribe,
                'objectDescribe should not be null'
            );
            if (
                this.objectPermissionsBySObjectType.get(objectDescribe.getName()) == null
            ) {
                // Load existing ObjectPerms and FieldPerms.
                final Map<String, Schema.FieldPermissions> fieldPermissionRecordByName = this.fieldPermissionRecordsBySObjectTypeByName.get(
                    objectDescribe.getName()
                );
                final List<TestUser.FieldPermission> fieldPermissions = new List<TestUser.FieldPermission>();

                if (fieldPermissionRecordByName != null) {
                    Map<String, Schema.SObjectField> sObjectFieldsByName = objectDescribe.fields.getMap();

                    for (String fieldName : fieldPermissionRecordByName.keySet()) {
                        final Schema.FieldPermissions permission = fieldPermissionRecordByName.get(
                            fieldName
                        );
                        final Schema.SObjectField sObjectField = sObjectFieldsByName.get(
                            fieldName
                        );

                        // Not every FieldPermissions's Field has a describe??  Must be some deep, standard object not normally used by ISVs.
                        if (sObjectField != null) {
                            final TestUser.FieldPermission fieldPermission = new TestUser.FieldPermission(
                                sObjectField.getDescribe(),
                                permission
                            );
                            fieldPermissions.add(fieldPermission);
                        }
                    }
                }

                TestUser.ObjectPermission objectPermission;

                final Schema.ObjectPermissions objectPermissionRecord = this.objectPermissionRecordsBySObjectType.get(
                    objectDescribe.getName()
                );
                if (objectPermissionRecord != null) {
                    // There is an existing ObjectPermission record to load values from.
                    objectPermission = new TestUser.ObjectPermission(
                        objectDescribe,
                        objectPermissionRecord,
                        fieldPermissions
                    );
                } else {
                    // The PermissionSet does not have any existing permissions to objectDescribe.
                    objectPermission = new TestUser.ObjectPermission(
                        objectDescribe,
                        new ObjectPermissions(
                            ParentId = this.getPermissionSetId(),
                            SobjectType = objectDescribe.getName()
                        ),
                        fieldPermissions
                    );
                }

                this.objectPermissionsBySObjectType.put(
                    objectDescribe.getName(),
                    objectPermission
                );
            }
            return this.objectPermissionsBySObjectType.get(objectDescribe.getName());
        }

        public TestUser.PermissionSetManager save() {
            List<TestUser.Permission> allPermissions = new List<TestUser.Permission>();
            for (
                TestUser.ObjectPermission objectPermission : this.objectPermissionsBySObjectType.values()
            ) {
                allPermissions.addAll(objectPermission.allPermissions);
            }
            TestUser.save(allPermissions);
            return this;
        }
    }

    public abstract class Permission {
        private final SObject permission;
        protected Boolean isChanged = false;

        protected Permission() {
            // Empty, protected constructor to prevent extensions outside of PermissionsTest
        }

        /**
         * @return   If any permission is true
         */
        protected abstract Boolean isAnyPermission();

        public Id getId() {
            return (Id) this.permission.get('Id');
        }

        protected Boolean getPermission(Schema.DescribeFieldResult fieldDescribe) {
            return (Boolean) this.permission.get(fieldDescribe.getName());
        }

        protected void setPermission(
            Schema.DescribeFieldResult fieldDescribe,
            Boolean value
        ) {
            final Boolean oldValue = this.getPermission(fieldDescribe);
            final Boolean newValue = value == true;
            //final Boolean oldValue = (Boolean) this.permission.put(fieldDescribe.getName(), newValue);
            this.permission.put(fieldDescribe.getName(), newValue);
            this.isChanged = this.isChanged || newValue != oldValue;
        }

        public Boolean getIsChanged() {
            return this.isChanged;
        }

        private Object getSaveRequest() {
            if (this.getIsChanged()) {
                // If at least one permission is true, update permission.
                // Else if Nno permissions are true, we can't update a Permission SObject with no permissions.
                // Rather, we need to delete the permission.  Return the ID to delete, and clear out permission's Id.
                //return this.isAnyPermission() ? this.permission : this.permission.put('Id', null); // Calling put returns the old value
                if (this.isAnyPermission()) {
                    return this.permission;
                } else {
                    Object permissionIdToDelete = this.permission.get('Id');
                    this.permission.put('Id', null);
                    return permissionIdToDelete;
                }
            }
            return null;
        }
    }

    public with sharing class FieldPermission extends TestUser.Permission {
        final String field;
        final Schema.DescribeFieldResult fieldDescribe;

        private FieldPermission(
            final Schema.DescribeFieldResult fieldDescribe,
            final Schema.FieldPermissions fieldPermissions
        ) {
            super();
            System.assertNotEquals(
                null,
                fieldDescribe,
                'fieldDescribe should not be null'
            );
            System.assertNotEquals(
                null,
                fieldPermissions,
                'fieldPermissions should not be null'
            );
            System.assertNotEquals(
                null,
                fieldPermissions.ParentId,
                'fieldPermissions.ParentId should not be null'
            );
            System.assertNotEquals(
                null,
                fieldPermissions.SobjectType,
                'fieldPermissions.SobjectType should not be null'
            );
            System.assertNotEquals(
                null,
                fieldPermissions.Field,
                'fieldPermissions.Field should not be null'
            );
            this.fieldDescribe = fieldDescribe;
            this.permission = fieldPermissions.clone(true, true, false, false);
            this.field = fieldPermissions.Field.substringAfter('.');

            // Initialize permissions so values are not null.
            this.setRead(fieldPermissions.PermissionsRead);
            this.setEdit(fieldPermissions.PermissionsEdit);

            this.isChanged = false;
        }

        public Schema.DescribeFieldResult getFieldDescribe() {
            return this.fieldDescribe;
        }

        private Schema.FieldPermissions getFieldPermissions() {
            return (Schema.FieldPermissions) this.permission;
        }

        public Id getPermissionSetId() {
            return this.getFieldPermissions().ParentId;
        }

        public String getSObjectType() {
            return this.getFieldPermissions().SobjectType;
        }

        /**
         * @return   Part of FieldPermissions.Field corresponding to Field's API Name.
         */
        public String getField() {
            return this.field;
        }

        public Boolean getRead() {
            // FieldPermissions.PermissionsRead may null, i.e. not set.
            return this.getPermission(
                    Schema.SObjectType.FieldPermissions.fields.PermissionsRead
                ) == true;
        }

        public Boolean getEdit() {
            // FieldPermissions.PermissionsEdit may null, i.e. not set.
            return this.getPermission(
                    Schema.SObjectType.FieldPermissions.fields.PermissionsEdit
                ) == true;
        }

        public override Boolean isAnyPermission() {
            return this.getRead() || this.getEdit();
        }

        /**
         * Sets FieldPermissions.PermissionsRead as permissionsRead if getFieldDescribe() is permissionable.
         * @param  permissionsRead Value to set on FieldPermissions.PermissionsRead
         * @return                 this
         */
        public TestUser.FieldPermission setRead(Boolean permissionsRead) {
            if (!this.getFieldDescribe().isPermissionable()) {
                throw new TestUser.FieldNotPermissionableException(
                    String.format(
                        'Cannot call setRead on Field "{0}" since it is not permissionable for the running User.',
                        new List<String>{ this.getFieldDescribe().getName() }
                    )
                );
            }
            this.setPermission(
                Schema.SObjectType.FieldPermissions.fields.PermissionsRead,
                permissionsRead
            );
            return this;
        }

        /**
         * Sets FieldPermissions.PermissionsEdit as permissionsEdit if getFieldDescribe() is permissionable and NOT calculated.
         * If FieldPermissions.PermissionsEdit is set and is true, calls setRead(true)
         * @param  permissionsEdit Value to set on FieldPermissions.PermissionsEdit
         * @return                 this
         */
        public TestUser.FieldPermission setEdit(Boolean permissionsEdit) {
            if (!this.getFieldDescribe().isPermissionable()) {
                throw new TestUser.FieldNotPermissionableException(
                    String.format(
                        'Cannot call setEdit on Field "{0}" since it is not permissionable for the running User.',
                        new List<String>{ this.getFieldDescribe().getName() }
                    )
                );
            }
            if (this.getFieldDescribe().isCalculated()) {
                throw new TestUser.FieldNotPermissionableException(
                    String.format(
                        'Cannot call setEdit on Field "{0}" since it is calculated for the running User.',
                        new List<String>{ this.getFieldDescribe().getName() }
                    )
                );
            }

            final Boolean permission = permissionsEdit == true;

            this.setPermission(
                Schema.SObjectType.FieldPermissions.fields.PermissionsEdit,
                permission
            );

            // Edit requires Read
            if (permission) {
                this.setRead(true);
            }

            return this;
        }

        public void save() {
            TestUser.save(new List<TestUser.Permission>{ this });
        }
    }

    public with sharing class FieldNotPermissionableException extends Exception {
    }

    public with sharing class ObjectPermission extends TestUser.Permission {
        private final Schema.DescribeSObjectResult objectDescribe;
        private final Map<String, TestUser.FieldPermission> fieldPermissionsByField;
        private final List<TestUser.Permission> allPermissions;

        private ObjectPermission(
            final Schema.DescribeSObjectResult objectDescribe,
            final Schema.ObjectPermissions permission
        ) {
            super();
            System.assertNotEquals(
                null,
                permission,
                'DescribeSObjectResult should not be null'
            );
            System.assertNotEquals(
                null,
                permission,
                'ObjectPermissions should not be null'
            );
            System.assertNotEquals(
                null,
                permission.ParentId,
                'ObjectPermissions.ParentId should not be null'
            );
            System.assertNotEquals(
                null,
                permission.SobjectType,
                'ObjectPermissions.SobjectType should not be null'
            );
            this.objectDescribe = objectDescribe;
            this.permission = permission;

            // Initialize permissions so values are not null.
            this.setRead(permission.PermissionsRead);
            this.setCreate(permission.PermissionsCreate);
            this.setEdit(permission.PermissionsEdit);
            this.setDelete(permission.PermissionsDelete);
            this.setViewAllRecords(permission.PermissionsViewAllRecords);
            this.setModifyAllRecords(permission.PermissionsModifyAllRecords);

            this.isChanged = false;

            this.allPermissions = new List<TestUser.Permission>{ this };
            this.fieldPermissionsByField = new Map<String, TestUser.FieldPermission>();
        }

        private ObjectPermission(
            final Schema.DescribeSObjectResult objectDescribe,
            final Schema.ObjectPermissions permission,
            final List<TestUser.FieldPermission> fieldPermissions
        ) {
            this(objectDescribe, permission);

            if (fieldPermissions != null) {
                for (TestUser.FieldPermission fieldPermission : fieldPermissions) {
                    System.assertEquals(
                        this.getPermissionSetId(),
                        fieldPermission.getPermissionSetId(),
                        'fieldPermission.getPermissionSetId() should equal getPermissionSetId()'
                    );
                    System.assertEquals(
                        this.getSObjectType(),
                        fieldPermission.getSObjectType(),
                        'fieldPermission.getSObjectType() should equal getSObjectType()'
                    );
                    this.fieldPermissionsByField.put(
                        fieldPermission.getField(),
                        fieldPermission
                    );
                    this.allPermissions.add(fieldPermission);
                }
            }
        }

        public Schema.DescribeSObjectResult getObjectDescribe() {
            return this.objectDescribe;
        }

        private Schema.ObjectPermissions getObjectPermissions() {
            return (Schema.ObjectPermissions) this.permission;
        }

        public Id getPermissionSetId() {
            return this.getObjectPermissions().ParentId;
        }

        public String getSObjectType() {
            return this.getObjectPermissions().SobjectType;
        }

        public Boolean getRead() {
            return this.getPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsRead
            );
        }

        public Boolean getCreate() {
            return this.getPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsCreate
            );
        }

        public Boolean getEdit() {
            return this.getPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsEdit
            );
        }

        public Boolean getDelete() {
            return this.getPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsDelete
            );
        }

        public Boolean getViewAllRecords() {
            return this.getPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsViewAllRecords
            );
        }

        public Boolean getModifyAllRecords() {
            return this.getPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsModifyAllRecords
            );
        }

        public override Boolean isAnyPermission() {
            return this.getRead() ||
                this.getCreate() ||
                this.getEdit() ||
                this.getDelete() ||
                this.getViewAllRecords() ||
                this.getModifyAllRecords();
        }

        public TestUser.ObjectPermission setRead(Boolean permissionsRead) {
            this.setPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsRead,
                permissionsRead
            );
            if (!this.getRead()) {
                this.setCreate(false);
                this.setEdit(false);
                this.setDelete(false);
                this.setViewAllRecords(false);
                this.setModifyAllRecords(false);
            }
            return this;
        }

        public TestUser.ObjectPermission setCreate(Boolean permissionsCreate) {
            this.setPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsCreate,
                permissionsCreate
            );
            if (this.getCreate()) {
                this.setRead(true);
            }
            return this;
        }

        public TestUser.ObjectPermission setEdit(Boolean permissionsEdit) {
            this.setPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsEdit,
                permissionsEdit
            );
            // Edit requires Read
            if (this.getEdit()) {
                this.setRead(true);
            } else {
                this.setDelete(false);
                this.setModifyAllRecords(false);
            }
            return this;
        }

        public TestUser.ObjectPermission setDelete(Boolean permissionsDelete) {
            this.setPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsDelete,
                permissionsDelete
            );
            if (this.getDelete()) {
                this.setEdit(true);
                this.setRead(true);
            } else {
                this.setModifyAllRecords(false);
            }
            return this;
        }

        public TestUser.ObjectPermission setViewAllRecords(
            Boolean permissionsViewAllRecords
        ) {
            this.setPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsViewAllRecords,
                permissionsViewAllRecords
            );
            // View All requires Read
            if (this.getViewAllRecords()) {
                this.setRead(true);
            } else {
                this.setModifyAllRecords(false);
            }
            return this;
        }

        public TestUser.ObjectPermission setModifyAllRecords(
            Boolean permissionsModifyAllRecords
        ) {
            this.setPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsModifyAllRecords,
                permissionsModifyAllRecords
            );
            // Modify All requires Read, Edit, Delete, View All
            if (this.getModifyAllRecords()) {
                this.setRead(true);
                this.setEdit(true);
                this.setDelete(true);
                this.setViewAllRecords(true);
            }
            return this;
        }

        public TestUser.ObjectPermission save() {
            TestUser.save(this.allPermissions);
            return this;
        }

        public TestUser.FieldPermission getFieldPermission(
            DescribeFieldResult fieldDescribe
        ) {
            System.assertNotEquals(null, 'fieldDescribe should not be null');
            if (this.fieldPermissionsByField.get(fieldDescribe.getName()) == null) {
                final TestUser.FieldPermission fieldPermission = new TestUser.FieldPermission(
                    fieldDescribe,
                    new FieldPermissions(
                        ParentId = this.getPermissionSetId(),
                        SobjectType = this.getSObjectType(),
                        Field = this.getSObjectType() + '.' + fieldDescribe.getName()
                    )
                );
                this.fieldPermissionsByField.put(
                    fieldPermission.getField(),
                    fieldPermission
                );
                this.allPermissions.add(fieldPermission);
            }
            return this.fieldPermissionsByField.get(fieldDescribe.getName());
        }

        public TestUser.ObjectPermission deleteAllFieldPermissions() {
            for (
                TestUser.FieldPermission fieldPermission : this.fieldPermissionsByField.values()
            ) {
                fieldPermission.setRead(false);
                fieldPermission.setEdit(false);
                fieldPermission.permission.put('Id', null);
                fieldPermission.isChanged = false;
            }
            Database.delete(
                [
                    SELECT Id
                    FROM FieldPermissions
                    WHERE
                        ParentId = :this.getPermissionSetId()
                        AND SobjectType = :this.getSObjectType()
                ]
            );
            return this;
        }
    }

    public static void save(List<TestUser.Permission> permissions) {
        final Set<Id> idsToDelete = new Set<Id>();
        final Map<Schema.SObjectType, List<SObject>> permissionsToInsertBySObjectType = new Map<Schema.SObjectType, List<SObject>>();
        final Map<Schema.SObjectType, List<SObject>> permissionsToUpdateBySObjectType = new Map<Schema.SObjectType, List<SObject>>();

        for (TestUser.Permission permission : permissions) {
            final Object saveRequest = permission.getSaveRequest();
            if (saveRequest instanceof Id) {
                idsToDelete.add((Id) saveRequest);
            } else if (saveRequest instanceof SObject) {
                final SObject record = (SObject) saveRequest;

                Map<SObjectType, List<SObject>> permissionsMap = record.get('Id') == null
                    ? permissionsToInsertBySObjectType
                    : permissionsToUpdateBySObjectType;

                if (permissionsMap.get(record.getSObjectType()) == null) {
                    permissionsMap.put(record.getSObjectType(), new List<SObject>());
                }
                permissionsMap.get(record.getSObjectType()).add(record);
            }
        }

        Database.delete(new List<Id>(idsToDelete));
        for (
            List<SObject> permissionsToInsert : permissionsToInsertBySObjectType.values()
        ) {
            Database.insert(permissionsToInsert);
        }
        for (
            List<SObject> permissionsToUpdate : permissionsToUpdateBySObjectType.values()
        ) {
            Database.update(permissionsToUpdate);
        }
    }

    public static Boolean isRelationship(Schema.DescribeFieldResult fieldDescribe) {
        return fieldDescribe != null && fieldDescribe.getType() == DisplayType.REFERENCE;
    }

    public static Boolean isMasterDetail(Schema.DescribeFieldResult fieldDescribe) {
        return TestUser.isRelationship(fieldDescribe) &&
            fieldDescribe.getRelationshipOrder() != null;
    }

    public static Boolean isLookup(Schema.DescribeFieldResult fieldDescribe) {
        return TestUser.isRelationship(fieldDescribe) &&
            !TestUser.isMasterDetail(fieldDescribe);
    }
}
