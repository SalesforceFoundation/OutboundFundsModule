*** Settings ***
Documentation  Create a Requirement on a Funding Request.
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
    ${funding_request} =              API Create Funding Request           ${fundingprogram}[Id]
    ...                               ${contact}[Id]
    ...                               ${ns}Status__c=In Progress
    ...                               ${ns}Awarded_Amount__c=100000
    Store Session Record              ${ns}Funding_Request__c         ${funding_request}[Id]
    Set suite variable                ${funding_request}
    ${req_name} =                     Generate New String
    Set suite variable                ${req_name}
    ${date_1} =                       Get current date    result_format=%m/%d/%Y  increment=60 days
    Set suite variable                ${date_2}


*** Test Case ***
Add a Requirement on a Funding Request
    [Documentation]                             Creates a Funding Request via API.
    ...                                         Go to Requirements and add a new Requirement
    [tags]                                      feature:FundingRequest    Requirements
    Go To Page                                  Listing          ${ns}Funding_Request__c
    Click Link With Text                        ${funding_request}[Name]
    Wait Until Loading Is Complete
    Current Page Should Be                      Details          Funding_Request__c
    Click Tab                                   Requirements
    click related list wrapper button           Requirements                               New
    Wait For Modal                              New                                  Requirement
    Populate New Record Form                    Requirement Name=${req_name}
    ...                                         Primary Contact=${contact}[Name]
    ...                                         Type=Letter of Intent
    ...                                         Due Date=${date_1}
    ...                                         Status=Open
    ...                                         Assigned=PermsTestingUser RobotUser
    Click Save
    Verify Toast Message                        Requirement
    Click Related List Link                     ${req_name}
    Validate Field Value                        Requirement Name   contains   ${req_name}
    Validate Field Value                        Primary Contact    contains    ${contact}[Name]
