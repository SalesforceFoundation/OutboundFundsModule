*** Settings ***
Documentation  Create an awarded funding request and add disbursemnt
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
    [Documentation]                   Create data to run tests
    ${ns} =                           Get Outfunds Namespace Prefix
    Set Suite Variable                ${ns}
    ${fundingprogram} =               API Create Funding Program
    Set suite variable                ${fundingprogram}
    ${contact} =                      API Create Contact
    Store Session Record              Contact                              ${contact}[Id]
    Set suite variable                ${contact}
    ${funding_request} =              API Create Funding Request
    ...                               ${fundingprogram}[Id]     ${contact}[Id]
    ...                               ${ns}Status__c=Awarded
    ...                               ${ns}Awarded_Amount__c=100000
    Store Session Record              ${ns}Funding_Request__c         ${funding_request}[Id]
    Set suite variable                ${funding_request}

*** Test Case ***
Create Disbursement on a Funding Request
    [Documentation]                             Creates a Funding Request via API.
    ...                                         Verifies that Funding Request is created and
    ...                                         add a new Disbursement
    [tags]                                      feature:FundingRequest
    Go To Page                                  Listing          ${ns}Funding_Request__c
    Click Link With Text                        ${funding_request}[Name]
    Wait Until Loading Is Complete
    Current Page Should Be                      Details          Funding_Request__c
    Click Button                                Create Disbursements
    wait until modal is open
    Populate Field                              Number of Disbursements     4
    Populate Field                              Interval    4
    Populate Field                              Amount      80000
    click button                                Calculate
    Wait Until Element Is Visible               text:Scheduled Date
    Save Disbursement
    Current Page Should Be                      Details          Funding_Request__c
    Validate Field Value                        Unpaid Disbursements    contains    $80,000.00
    Validate Field Value                        Available for Disbursement  contains    $20,000.00