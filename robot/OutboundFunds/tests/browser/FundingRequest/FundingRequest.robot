*** Settings ***

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
    ${ns} =                             Get Outfunds Namespace Prefix
    Set Suite Variable                  ${ns}
    ${fundingprogram} =                 API Create Funding Program
    Store Session Record                ${ns}Funding_Program__c         ${fundingprogram}[Id]
    Set suite variable                  ${fundingprogram}
    ${contact} =                        API Create Contact
    Store Session Record                Contact                              ${contact}[Id]
    Set suite variable                  ${contact}
    ${funding_request} =                API Create Funding Request           ${fundingprogram}[Id]     ${contact}[Id]
    Store Session Record                ${ns}Funding_Request__c         ${funding_request}[Id]
    Set suite variable                  ${funding_request}
    ${awardedfunding_request} =         API Create Funding Request           ${fundingprogram}[Id]     ${contact}[Id]
    ...                                 ${ns}Status__c=Awarded          ${ns}Awarded_Amount__c=100000
    Store Session Record                ${ns}Funding_Request__c         ${awardedfunding_request}[Id]
    Set suite variable                  ${awardedfunding_request}
    ${fr_name} =                        Generate New String
    Set suite variable                  ${fr_name}
    ${req_name} =                       Generate New String
    Set suite variable                  ${req_name}

*** Test Case ***
Create Funding Request Via API
    [Documentation]                             Creates a Funding Request via API.
    ...                                         Verifies that Funding Request is created and
    ...                                         displays under recently viewed Funding Request
    [tags]                                      feature:FundingRequest
    Go To Page                                  Listing          Funding_Request__c
    Click Link With Text                        ${funding_request}[Name]
    Wait Until Loading Is Complete
    Current Page Should Be                      Details          Funding_Request__c
    Validate Field Value                        Status  contains    In progress
    Validate Field Value                        Funding Request Name    contains    ${funding_request}[Name]

Create Funding Request via UI in Outbound Funds
     [Documentation]                            Creates a Funding Request via UI.
     ...                                        Verifies that Funding Request is created.
     [tags]                                     feature:FundingRequest
     Go To Page                                 Listing          Funding_Request__c
     Click Object Button                        New
     wait until modal is open
     Populate Field                             Funding Request Name    ${fr_name}
     Populate Lookup Field                      Funding Program     ${fundingprogram}[Name]
     Populate Lookup Field                      Applying Contact    ${contact}[Name]
     Click Save
     wait until modal is closed
     Current Page Should Be                     Details           Funding_Request__c
     Validate Field Value                       Funding Request Name           contains         ${fr_name}
