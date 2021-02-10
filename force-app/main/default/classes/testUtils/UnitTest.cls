@IsTest
public with sharing class UnitTest {
    private static Integer MOCK_ID_INDEX = 0;

    /**
     * Generates a mocked Id that is guaranteed to be unique within a transaction.
     * @param  sObjectType In tests, you can pass in a SObjectType with Schema.[SObjectType Name].SObjectType.
     * @return             A single mocked Id of sObjectType guaranteed to be unique within a transaction.
     */
    public static Id mockId(Schema.DescribeSObjectResult describe) {
        return describe.getKeyPrefix() +
            String.valueOf(UnitTest.MOCK_ID_INDEX++).leftPad(12, '0');
    }

    /**
     * Generates a mocked Id that is guaranteed to be unique within a transaction.
     * @param  sObjectType In tests, you can pass in a describe with Schema.SObjectType.[SObjectType Name].
     * @return             A single mocked Id of sObjectType guaranteed to be unique within a transaction.
     */
    public static Id mockId(SObjectType sObjectType) {
        return UnitTest.mockId(sObjectType.getDescribe());
    }

    /**
     * Generates mocked Ids that are guaranteed to be unique within a transaction.
     * @param  describe In tests, you can pass in a describe with Schema.SObjectType.[SObjectType Name].
     * @param  size     Number of Ids to generate for this sObjectType
     * @return          List of mocked Ids of sObjectType guaranteed to be unique within a transaction.
     */
    public static List<Id> mockIds(Schema.DescribeSObjectResult describe, Integer size) {
        final List<Id> mockIds = new List<Id>();
        for (Integer i = 0; i < size; i++) {
            mockIds.add(UnitTest.mockId(describe));
        }
        return mockIds;
    }

    /**
     * Generates mocked Ids that are guaranteed to be unique within a transaction.
     * @param  sObjectType In tests, you can pass in a SObjectType with Schema.[SObjectType Name].SObjectType.
     * @param  size        Number of Ids to generate for this sObjectType
     * @return             List of mocked Ids of sObjectType guaranteed to be unique within a transaction.
     */
    public static List<Id> mockIds(SObjectType sObjectType, Integer size) {
        return UnitTest.mockIds(sObjectType.getDescribe(), size);
    }

    /**
     * An exception that can be used for testing so tests don't have to create their own Exceptions.
     */
    public with sharing class TestException extends Exception {
    }

    /**
     * Tab delimiter when debugging.
     */
    public static String DEBUG_DELIMITER = '    ';

    /**
     * Unit testing magic.
     * TODO: Add documentation.
     */
    public with sharing virtual class Mock implements System.StubProvider {
        public final Map<String, UnitTest.Mock> methods = new Map<String, UnitTest.Mock>();

        // TODO: support asserting calls at a specified index
        @TestVisible
        public final List<List<Object>> calls = new List<List<Object>>();

        public Object returnValue { get; set; }

        /**
         * Returns the `UnitTest.Mock` associated with the `methodName`.  If the
         * `methodName` does not have an associated `UnitTest.Mock`, a new `UnitTest.Mock`
         * is constructed for `methodName` and returned.
         * @param  methodName Name of method to mock.  Cannot be null.
         * @return            UnitTest.Mock for the `methodName`.
         */
        public UnitTest.Mock getMethod(String methodName) {
            System.assertNotEquals(
                null,
                methodName,
                'methodName argument of UnitTest.Mock.getMethod() should not be null.'
            );
            final String lowerMethodName = methodName.toLowerCase();
            UnitTest.Mock method = this.methods.get(lowerMethodName);
            if (method == null) {
                method = new UnitTest.Mock();
                this.methods.put(lowerMethodName, method);
            }
            return method;
        }

        /**
         * Overrides the default UnitTest.Mock associated with `methodName`.  Remember, if `mock` is null, getMethod will create a new UnitTest.Mock associated with methodName.
         * @param  methodName Name of the method to mock.  Cannot be null.
         * @param  mock       Mock for the method.  Remember, if mock is null, getMethod will create a new UnitTest.Mock associated with methodName.
         */
        public void setMethod(String methodName, UnitTest.Mock mock) {
            System.assertNotEquals(
                null,
                methodName,
                'methodName argument of UnitTest.Mock.getMethod() should not be null.'
            );
            System.assertNotEquals(null, mock, 'Cannot set a method\'s mock as null.');
            final String lowerMethodName = methodName.toLowerCase();
            this.methods.put(lowerMethodName, mock);
        }

        /**
         * Virtual method that returns what `handleMethodCall` will return.  If `sideEffect` returns a stub
         * provider, `handleMethodCall` will try return a stub of the stub provider with
         * the `returnType` argument.  Default: returns `returnValue`.
         * @param  instance       `instance` of the `handleMethodCall`
         * @param  methodName     `methodName` of the `handleMethodCall`
         * @param  returnType     `returnType` of the `handleMethodCall`
         * @param  parameterTypes `parameterTypes` of the `handleMethodCall`
         * @param  parameterNames `parameterNames` of the `handleMethodCall`
         * @param  arguments      `arguments` of the `handleMethodCall`
         * @return                What `handleMethodCall` will return.   If an instance of an Exception or an Exception Type is returned, the exception instance or a new instance of the Exception Type is thrown.  If a `System.StubProvider` is returned, a stub of the `System.StubProvider` is returned.  Default: returns `returnValue`.
         */
        public virtual Object sideEffect(
            Object instance,
            String methodName,
            Type returnType,
            List<Type> parameterTypes,
            List<String> parameterNames,
            List<Object> arguments
        ) {
            return this.returnValue;
        }

        /**
         * System.StubProvider implementation.
         * @param  instance       Stubbed instance of the method called. We assert instance
         *                        is an instance of the expected stubbed method.
         * @param  methodName     Name of the called method. We assert the expected stubbed
         *                        method's Method Name equals-ignore-case methodName.
         * @param  returnType     Return type of the called method. We assert the expected
         *                        stubbed method's Return Type equals returnType.
         * @param  parameterTypes List the called method's parameter Types. We assert the
         *                        expected stubbed method's Return Type equals returnType.
         * @param  parameterNames List the called method's parameter names. In Apex, only a
         *                        method's parameter types define the method's signature, so
         *                        we don't assert anything regarding parameter names.
         * @param  arguments      List of the called method's arguments. We assert the
         *                        expected stubbed method's Expected Arguments equal
         *                        arguments.
         * @return                First, we assert the method called matches the signature
         *                        of the expected stubbed method.
         *
         *                        Then we either throw the expected stubbed method's
         *                        Exception Thrown Before Returning Value if set
         *                        to a non-null value, or we return the expected
         *                        stubbed method's Return Value.
         *
         *                        If the expected stubbed method implements ModifyArguments,
         *                        the expected stubbed method's modifyArguments(...)
         *                        is called before returning its Return Value. This is
         *                        useful if you absolutely need to modify a method's
         *                        arguments before moving on in the unit test.
         *                        Generally, this is NOT needed.
         *
         *                        NOTE: Stub.Method's getReturnValue() returns
         *                        void.class by default which simulates a method
         *                        with "void" Return Type.  If you unexpectedly see
         *                        void.class returned, you forgot to override
         *                        the stubbed method's getReturnValue()!
         */
        public Object handleMethodCall(
            final Object instance,
            final String methodName,
            final Type returnType,
            final List<Type> parameterTypes,
            final List<String> parameterNames,
            final List<Object> arguments
        ) {
            final UnitTest.Mock method = this.getMethod(methodName);
            method.calls.add(arguments);

            final Object returnValue = method.sideEffect(
                instance,
                methodName,
                returnType,
                parameterTypes,
                parameterNames,
                arguments
            );
            if (returnValue instanceof System.StubProvider) {
                try {
                    // Work-around to stubbing System-defined classes: Try wrapping in "singleton".
                    // See: FeatureManagement and PermissionValidator
                    return Test.createStub(returnType, (System.StubProvider) returnValue);
                } catch (System.TypeException typeException) {
                    System.assert(
                        false,
                        String.join(
                            new List<String>{
                                '',
                                '',
                                'The return value provided by sideEffect(...) is a System.StubProvider instance,',
                                'so UnitTest.Mock tried to return a Test.createStub using the method call\'s returnType',
                                'and the return value as the stub provider.  However, a System.TypeException was thrown.',
                                '',
                                'Is the returnType a system defined type?  If so, you cannot stub system defined types.',
                                'Try creating an extension of UnitTest.Mock overriding sideEffect(...) to track and return',
                                'values that are not instances of System.StubProvider.',
                                '',
                                debug(typeException),
                                '',
                                debug(
                                    instance,
                                    methodName,
                                    returnType,
                                    parameterTypes,
                                    parameterNames,
                                    arguments
                                ),
                                '',
                                'this:' + this
                            },
                            '\n'
                        )
                    );
                }
            } else if (returnValue instanceof Exception) {
                throw (Exception) returnValue;
            } else if (returnValue instanceof Type) {
                try {
                    Object newInstance = ((Type) returnValue).newInstance();
                    if (newInstance instanceof Exception) {
                        throw (Exception) newInstance;
                    }
                } catch (Exception e) {
                }
            }
            return returnValue;
        }

        /**
         * Shorthand to create a stub with Test.createStub using this as the stub provider.
         * @param  stubType Type of Stub
         * @return          Test.createStub(stubType, this)
         */
        public Object createStub(Type stubType) {
            return Test.createStub(stubType, this);
        }

        /**
         * Used to show which concrete type this UnitTest.Mock instance is when debugging.
         * @return   Concrete type of this UnitTest.Mock instance.
         */
        public virtual Type getType() {
            return UnitTest.class;
        }

        /**
         * Used to debug a UnitTest.Mock in human readable way.
         *
         * NOTE: Scott P has an idea for a debugging framework to generalize this concept.
         */
        private String debug(Integer tabs) {
            if (4 < tabs) {
                return 'DEBUG_DEPTH_REACHED: 4';
            }
            final String delimiter0 = DEBUG_DELIMITER.repeat(tabs);
            final String delimiter1 = DEBUG_DELIMITER.repeat(tabs + 1);
            final String delimiter2 = DEBUG_DELIMITER.repeat(tabs + 2);

            final List<String> debugs = new List<String>{ this.getType().getName() };

            // returnValue
            if (this.returnValue instanceof UnitTest.Mock) {
                debugs.add(
                    delimiter1 +
                    'returnValue: ' +
                    ((UnitTest.Mock) this.returnValue).debug(tabs + 2) +
                    ','
                );
            } else {
                debugs.add(delimiter1 + 'returnValue: ' + this.returnValue + ',');
            }

            // calls
            debugs.add(delimiter1 + 'calls: [');
            for (List<Object> call : this.calls) {
                debugs.add(
                    String.format(
                        delimiter2 + '({0}) [{1}]',
                        new List<String>{
                            String.join(call, ', '),
                            String.valueOf(call.size())
                        }
                    )
                );
            }
            debugs.add(delimiter1 + ']');

            // methods
            debugs.add(delimiter1 + 'methods:');
            for (String methodName : this.methods.keySet()) {
                debugs.add(
                    delimiter2 +
                    methodName +
                    ': ' +
                    this.methods.get(methodName).debug(tabs + 2)
                );
            }
            return String.join(debugs, '\n');
        }

        public override String toString() {
            return this.debug(0);
        }

        /**
         * Assert that the mock was called at least once.
         */
        public void assertCalled() {
            System.assert(!this.calls.isEmpty(), this);
        }

        /**
         * Assert that the mock was called exactly once.
         */
        public void assertCalledOnce() {
            System.assertEquals(1, this.calls.size(), this);
        }

        /**
         * This method is a convenient way of asserting that the last call has been made in a particular way.
         */
        public void assertCalledWith(final List<Object> arguments) {
            this.assertCalled();
            final List<Object> expected = arguments;
            final List<Object> actual = this.calls[this.calls.size() - 1]; // Last call
            UnitTest.assertCallEquals(expected, actual);
        }

        /**
         * Assert that the mock was called exactly once and that that call was with the specified arguments.
         */
        public void assertCalledOnceWith(final List<Object> arguments) {
            this.assertCalledOnce();
            this.assertCalledWith(arguments);
        }

        /**
         * Assert the mock has been called with the specified calls. The mockCalls list is
         * checked for the calls.
         *
         * If anyOrder is false then the calls must be sequential. There can be extra calls
         * before or after the specified calls.
         *
         * If anyOrder is true then the calls can be in any order, but they must all appear
         * in mockCalls.
         *
         * TODO: support Boolean anyCalls argument
         */
        public void assertHasCalls(final List<List<Object>> mockCalls) {
            UnitTest.assertCallsEquals(this.calls, mockCalls);
        }

        /**
         * Assert the mock was never called.
         */
        public void assertNotCalled() {
            System.assert(
                this.calls.isEmpty(),
                'UnitTest.Mock should not have been called: ' + this
            );
        }

        /**
         * Clears calls.   You can also clear calls manually: `mock.class.clear()`
         */
        public void clear() {
            this.calls.clear();
        }
    }

    /**
     * Asserts expectedCalls equals actualCalls with human readable debugging.
     */
    public static void assertCallsEquals(
        List<List<Object>> expectedCalls,
        List<List<Object>> actualCalls
    ) {
        if (expectedCalls == null || actualCalls == null) {
            System.assertEquals(
                expectedCalls,
                actualCalls,
                'assertCallsEquals(List<List<Object>> expectedCalls, List<List<Object>> actualCalls)'
            );
        } else {
            final Integer expectedSize = expectedCalls.size();
            System.assertEquals(
                expectedSize,
                actualCalls.size(),
                'Lists of Calls should have the same size'
            );
            for (Integer callIndex = 0; callIndex < expectedSize; callIndex++) {
                final List<Object> expectedCall = expectedCalls[callIndex];
                final List<Object> actualCall = actualCalls[callIndex];

                if (expectedCall == null || actualCall == null) {
                    System.assertEquals(
                        expectedCall,
                        actualCall,
                        String.format(
                            'Call at index [{0}]',
                            new List<String>{ String.valueOf(callIndex) }
                        )
                    );
                } else {
                    final Integer argumentsSize = expectedCall.size();
                    System.assertEquals(
                        argumentsSize,
                        actualCall.size(),
                        String.format(
                            'Call at index [{0}] should have the same size',
                            new List<String>{ String.valueOf(callIndex) }
                        )
                    );
                    for (
                        Integer argumentIndex = 0;
                        argumentIndex < argumentsSize;
                        argumentIndex++
                    ) {
                        System.assertEquals(
                            expectedCall[argumentIndex],
                            actualCall[argumentIndex],
                            String.format(
                                'Argument at index [{1}] of Call at index [{0}] should equal',
                                new List<String>{
                                    String.valueOf(callIndex),
                                    String.valueOf(argumentIndex)
                                }
                            )
                        );
                    }
                }
            }
        }
    }

    public static void assertCallEquals(
        List<Object> expectedCall,
        List<Object> actualCall
    ) {
        if (expectedCall == null || expectedCall == null) {
            System.assertEquals(
                expectedCall,
                actualCall,
                'assertCallsEquals(List<Object> expectedCall, List<Object> actualCall)'
            );
        } else {
            final Integer argumentsSize = expectedCall.size();
            System.assertEquals(
                argumentsSize,
                actualCall.size(),
                'Call should have the same size'
            );
            for (
                Integer argumentIndex = 0; argumentIndex < argumentsSize; argumentIndex++
            ) {
                System.assertEquals(
                    expectedCall[argumentIndex],
                    actualCall[argumentIndex],
                    String.format(
                        'Argument at index [{0}] of Call should equal',
                        new List<String>{ String.valueOf(argumentIndex) }
                    )
                );
            }
        }
    }

    /**
     * @param  e
     * @return   Human readable message for debugging Exceptions.
     */
    public static String debug(Exception e) {
        if (e == null) {
            return 'null';
        }
        return 'Exception:\n' +
            String.join(
                new List<String>{
                    DEBUG_DELIMITER +
                    'TypeName: ' +
                    e.getTypeName(),
                    DEBUG_DELIMITER +
                    'Message: ' +
                    e.getMessage()
                },
                '\n'
            );
    }

    /**
     * @return   Human readable message for debugging method calls.
     */
    public static String debug(
        final Object instance,
        final String methodName,
        final Type returnType,
        final List<Type> parameterTypes,
        final List<String> parameterNames,
        final List<Object> arguments
    ) {
        return 'Method Call:\n' +
            String.join(
                new List<String>{
                    DEBUG_DELIMITER +
                    'methodName: ' +
                    methodName,
                    DEBUG_DELIMITER +
                    'returnType: ' +
                    returnType,
                    DEBUG_DELIMITER +
                    'parameterTypes: ' +
                    parameterTypes,
                    DEBUG_DELIMITER +
                    'parameterNames: ' +
                    parameterNames,
                    DEBUG_DELIMITER +
                    'arguments: ' +
                    arguments
                },
                '\n'
            );
    }
}
