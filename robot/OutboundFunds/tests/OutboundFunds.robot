*** Settings ***

Resource       cumulusci/robotframework/Salesforce.robot

*** Keywords ***

API Create Account
    [Arguments]      &{fields}
    ${name} =        Generate Random String
    ${account_id} =  Salesforce Insert  Account
    ...                  Name=${name}
    ...                  &{fields}
    &{account} =     Salesforce Get  Account  ${account_id}
    [return]         &{account}

API Create Contact
    [Arguments]      &{fields}
    ${first_name} =  Generate Random String
    ${last_name} =   Generate Random String
    ${contact_id} =  Salesforce Insert  Contact
    ...                  FirstName=${first_name}
    ...                  LastName=${last_name}
    ...                  &{fields}
    &{contact} =     Salesforce Get  Contact  ${contact_id}
    [return]         &{contact}

API Create Funding Program
    [Arguments]      &{fields}
    ${name} =        Generate Random String
    ${program_id} =  Salesforce Insert  Funding_Program__c
    ...                  Name=${name}
    ...                  &{fields}
    &{program} =     Salesforce Get  Funding_Program__c  ${program_id}
    [return]         &{program}

API Create Funding Request
    [Arguments]      ${program_id}  &{fields}
    ${name} =        Generate Random String
    ${request_id} =  Salesforce Insert  Funding_Request__c
    ...                  Name=${name}
    ...                  Funding_Program__c=${program_id}
    ...                  &{fields}
    &{program} =     Salesforce Get  Funding_Request__c  ${request_id}
    [return]         &{program}

API Create Disbursement
    [Arguments]           ${request_id}  &{fields}
    ${disbursement_id} =  Salesforce Insert  Disbursement__c
    ...                       Funding_Request__c=${request_id}
    ...                       &{fields}
    &{disbursement} =     Salesforce Get  Disbursement__c  ${disbursement_id}
    [return]              &{disbursement}

API Create Requirement
    [Arguments]          &{fields}
    ${name} =            Generate Random String
    ${requirement_id} =  Salesforce Insert  Requirement__c
    ...                      ${name}
    ...                      &{fields}
    &{requirement} =     Salesforce Get  Requirement__c  ${requirement_id}
    [return]             &{requirement}