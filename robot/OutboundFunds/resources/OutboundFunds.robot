*** Settings ***

Resource       cumulusci/robotframework/Salesforce.robot
Library        robot/OutboundFunds/resources/OutboundFunds.py
Library        DateTime

*** Keywords ***

Capture Screenshot and Delete Records and Close Browser
    [Documentation]                 This keyword will capture a screenshot before closing
    ...                             the browser and deleting records when test fails
    Run Keyword If Any Tests Failed      Capture Page Screenshot
    Close Browser
    Delete Session Records

API Create Account
    [Documentation]                 Create an Account for user
    [Arguments]                     &{fields}
    ${name} =                       Generate New String
    ${account_id} =                 Salesforce Insert  Account
    ...                             Name=${name}
    ...                             &{fields}
    &{account} =                    Salesforce Get  Account  ${account_id}
    [return]                        &{account}

API Create Contact
    [Documentation]                 Create a contact via API
    [Arguments]                     &{fields}
    ${contact_id} =                 Salesforce Insert  Contact
    ...                             FirstName=${faker.first_name()}
    ...                             LastName=${faker.last_name()}
    ...                             &{fields}
    &{contact} =                    Salesforce Get  Contact  ${contact_id}
    [Return]                        &{contact}

API Create Contact for User
    [Documentation]                 Create a contact via API for user creation
    [Arguments]                     ${account_id}   &{fields}
    ${email}=                       Random Email
    ${contact_id} =                 Salesforce Insert  Contact
    ...                             FirstName=${faker.first_name()}
    ...                             LastName=${faker.last_name()}
    ...                             AccountId=${account_id}
    ...                             Email=${email}
    ...                             &{fields}
    &{contact} =                    Salesforce Get  Contact  ${contact_id}
    [Return]                        &{contact}

API Create Funding Program
    [Documentation]                 Create a Funding Program via API
    [Arguments]                     &{fields}
    ${ns} =                         Get Outfunds Namespace Prefix
    ${funding_program_name} =       Generate New String
    ${start_date} =                 Get Current Date  result_format=%Y-%m-%d
    ${end_date} =                   Get Current Date  result_format=%Y-%m-%d    increment=90 days
    ${funding_program_id} =         Salesforce Insert  ${ns}Funding_Program__c
    ...                             Name=${funding_program_name}
    ...                             ${ns}Start_Date__c=${start_date}
    ...                             ${ns}End_Date__c=${end_date}
    ...                             ${ns}Status__c=In Progress
    ...                             ${ns}Total_Program_Amount__c=100000
    ...                             ${ns}Description__c=Robot API Program
    ...                             &{fields}
    &{fundingprogram} =             Salesforce Get  ${ns}Funding_Program__c  ${funding_program_id}
    [Return]                        &{fundingprogram}

API Create Funding Request
    [Documentation]                 Create a Funding Request via API
    [Arguments]                     ${funding_program_id}  ${contact_id}    &{fields}
    ${ns} =                         Get Outfunds Namespace Prefix
    ${funding_request_name} =       Generate New String
    ${application_date} =           Get Current Date  result_format=%Y-%m-%d
    ${funding_request_id} =         Salesforce Insert  ${ns}Funding_Request__c
    ...                             Name=${funding_request_name}
    ...                             ${ns}Applying_Contact__c=${contact_id}
    ...                             ${ns}Status__c=In Progress
    ...                             ${ns}Requested_Amount__c=100000
    ...                             ${ns}FundingProgram__c=${funding_program_id}
    ...                             ${ns}Requested_For__c=Education
    ...                             &{fields}
    &{funding_request} =            Salesforce Get  ${ns}Funding_Request__c  ${funding_request_id}
    Store Session Record            ${ns}Funding_Request__c   ${funding_request_id}
    [Return]                        &{funding_request}

API Create Requirement on a Funding Request
    [Documentation]                 Create a Requirement on a Funding Request via API
    [Arguments]                     ${funding_request_id}  ${contact_id}    ${user_id}   &{fields}
    ${ns} =                         Get Outfunds Namespace Prefix
    ${requirement_name} =           Generate New String
    ${due_date} =                   Get Current Date  result_format=%Y-%m-%d    increment=30 days
    ${requirement_id} =             Salesforce Insert  outfunds__Requirement__c
    ...                             Name=${requirement_name}
    ...                             ${ns}Primary_Contact__c=${contact_id}
    ...                             ${ns}Due_Date__c=${due_date}
    ...                             ${ns}Assigned__c=${user_id}
    ...                            ${ns}Status__c=Open
    ...                             o${ns}Funding_Request__c=${funding_request_id}
    ...                             ${ns}Type__c=Review
    ...                             &{fields}
    &{requirement} =                Salesforce Get  ${ns}Requirement__c  ${requirement_id}
    Store Session Record            ${ns}Requirement__c   ${requirement_id}
    [Return]                        &{requirement}

API Create Disbursement on a Funding Request
    [Documentation]                 Create a Disbursement on a Funding Request via API
    [Arguments]                     ${funding_request_id}  &{fields}
    ${ns} =                         Get Outfunds Namespace Prefix
    ${scheduled_date} =             Get Current Date  result_format=%Y-%m-%d    increment=5 days
    ${disbursement_date} =          Get Current Date  result_format=%Y-%m-%d    increment=10 days
    ${disbursement_id} =            Salesforce Insert  ${ns}Disbursement__c
    ...                             ${ns}Funding_Request__c=${funding_request_id}
    ...                             ${ns}Amount__c=5000
    ...                             ${ns}Status__c=Scheduled
    ...                             ${ns}Scheduled_Date__c=${scheduled_date}
    ...                             ${ns}Type__c=Initial
    ...                             ${ns}Disbursement_Date__c=${disbursement_date}
    ...                             ${ns}Disbursement_Method__c=Check
    ...                             &{fields}
    &{disbursement} =               Salesforce Get  ${ns}Disbursement__c  ${disbursement_id}
    Store Session Record            ${ns}disbursement__c   ${disbursement_id}
    [Return]                        &{disbursement}
