*** Settings ***
Documentation  User with Read Only Access should not  be able to Create a Disbursement
Resource       robot/OutboundFunds/resources/OutboundFunds.robot
Library        cumulusci.robotframework.PageObjects
...            robot/OutboundFunds/resources/FundingRequestPageObject.py
...            robot/OutboundFunds/resources/OutboundFunds.py

Suite Setup     Run keywords
...             Open test browser       useralias=${test_user}      AND
...             Setup Test Data
Suite Teardown  Capture Screenshot And Delete Records And Close Browser

*** Variables ***
${test_user}             permtest

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
Disbursement FLS Check
    [Documentation]                            Login as User who only have read access
    ...                                        to Disbursements Object and Verify
    ...                                        that user cannot save a disbursement
    [tags]                                      W-9027758   feature:FundingRequest
    Go To Page                                  Details     Funding_Request__c
    ...                                         object_id=${funding_request}[Id]
    Wait Until Loading Is Complete
    Click Button                                Create Disbursements
    wait until modal is open
    Populate Field                              Number of Disbursements     4
    Populate Field                              Interval    4
    Populate Field                              Amount      80000
    click button                                Calculate
    Wait Until Element Is Visible               text:Scheduled Date
    Save Disbursement
    Wait Until Element Is Visible               text:Resolve error