*** Settings ***
Documentation  Create a funding request.
Resource       robot/OutboundFunds/resources/OutboundFunds.robot
Library        cumulusci.robotframework.PageObjects
...            robot/OutboundFunds/resources/FundingRequestPageObject.py
...            robot/OutboundFunds/resources/OutboundFunds.py

Suite Setup     Run keywords
...             Open Test Browser
...             Setup Test Data
Suite Teardown  Capture Screenshot And Delete Records And Close Browser

*** Keywords ***
Setup Test Data
    [Documentation]                     Create data to run tests
    ${ns} =                             Get Outfunds Namespace Prefix
    Set Suite Variable                  ${ns}
    ${fundingprogram} =                 API Create Funding Program
    Store Session Record                ${ns}Funding_Program__c         ${fundingprogram}[Id]
    Set suite variable                  ${fundingprogram}
    ${contact} =                        API Create Contact
    Store Session Record                Contact                              ${contact}[Id]
    Set suite variable                  ${contact}
    ${funding_request} =                API Create Funding Request
    ...                                 ${fundingprogram}[Id]     ${contact}[Id]
    Store Session Record                ${ns}Funding_Request__c         ${funding_request}[Id]
    Set suite variable                  ${funding_request}
    ${awardedfunding_request} =         API Create Funding Request
    ...                                 ${fundingprogram}[Id]      ${contact}[Id]
    ...                                 ${ns}Status__c=Awarded  ${ns}Awarded_Amount__c=100000
    Store Session Record                ${ns}Funding_Request__c  ${awardedfunding_request}[Id]
    Set suite variable                  ${awardedfunding_request}
    ${fr_name} =                        Generate New String
    Set suite variable                  ${fr_name}
    ${req_name} =                       Generate New String
    Set suite variable                  ${req_name}
    ${date_1} =                         Get current date    result_format=%m/%d/%Y  increment=1 day
    Set suite variable                  ${date_1}
    ${contact_role} =                   API Create Contact
    Store Session Record                Contact                              ${contact_role}[Id]
    Set suite variable                  ${contact_role}

*** Variables ***
${test_user}             permtest

*** Test Case ***
Create Funding Request Via API
    [Documentation]                             Creates a Funding Request via API.
    ...                                         Verifies that Funding Request is created and
    ...                                         displays under recently viewed Funding Request
    [tags]                                      feature:FundingRequest
    Go To Page                                  Listing          ${ns}Funding_Request__c
    Click Link With Text                        ${funding_request}[Name]
    Wait Until Loading Is Complete
    Current Page Should Be                      Details          Funding_Request__c
    Validate Field Value                        Status  contains    In progress
    Validate Field Value                        Funding Request Name    contains
    ...                                         ${funding_request}[Name]

Create Funding Request via UI in Outbound Funds
     [Documentation]                            Creates a Funding Request via UI.
     ...                                        Verifies that Funding Request is created.
     [tags]                                     feature:FundingRequest
     Go To Page                                 Listing          ${ns}Funding_Request__c
     Click Object Button                        New
     wait until modal is open
     Populate New Record Form                   Funding Request Name=${fr_name}
     ...                                        Funding Program=${fundingprogram}[Name]
     ...                                        Application Date=${date_1}
     ...                                        Status=Submitted
     ...                                        Geographical Area Served=State
     ...                                        Applying Contact=${contact}[Name]
     ...                                        Requested Amount=25000
     Click Save
     Verify Toast Message                       Funding Request
     Current Page Should Be                     Details           Funding_Request__c
     Validate Field Value                       Funding Request Name    contains    ${fr_name}

Add New Funding Request Role
    [Documentation]                             Add New Funding Request Role on a Funding Request
     [tags]                                     feature:FundingRequest      feature:FundingRequestRole
     Go To Page                                 Listing          ${ns}Funding_Request__c
     Click Link With Text                        ${funding_request}[Name]
     Wait Until Loading Is Complete
     Current Page Should Be                      Details          Funding_Request__c
     Click Button                                Create Funding Request Role
     Wait Until Modal Is Open
     Populate Lookup Field                       Contact    ${contact_role}[Name]
     Select Value From Dropdown                  Status     Current
     Select Value From Dropdown                  Role       Applicant
     Save Funding Request Role
     Verify Toast Message                        A new Funding Request Role has been created
     Current Page Should Be                      Details          Funding_Request__c
     Click Funding Request Role link
     Current Page Should Be                      Details          Funding_Request_Role__c
     Validate Field Value                        Status     contains    Current

Share a Funding Request
    [Documentation]                             Creates a Funding Request via API and Share
    ...                                         Verifies that Funding Request is created and
    ...                                         Share Funding Request
    [tags]                                      feature:FundingRequest
    Go To Page                                  Details          Funding_Request__c   object_id=${funding_request}[Id]
    Share A Record
    Close Browser
    Open test browser                           useralias=${test_user}
    Go To Page                                  Details          Funding_Request__c   object_id=${funding_request}[Id]
    Validate Field Value                        Status  contains    In progress
    Validate Field Value                        Funding Request Name    contains
    ...                                         ${funding_request}[Name]
    Page Should Not Contain Element             OutboundFunds:object_button
