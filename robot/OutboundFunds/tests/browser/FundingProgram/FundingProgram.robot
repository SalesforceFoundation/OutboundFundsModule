*** Settings ***
Documentation  Create a new Funding Program
Resource       robot/OutboundFunds/resources/OutboundFunds.robot
Library        cumulusci.robotframework.PageObjects
...            robot/OutboundFunds/resources/FundingProgramPageObject.py
...            robot/OutboundFunds/resources/OutboundFunds.py

Suite Setup     Run keywords
...             Open Test Browser
...             Setup Test Data
Suite Teardown  Capture Screenshot And Delete Records And Close Browser

*** Keywords ***
Setup Test Data
    [Documentation]                   Create data to run tests
    ${ns} =                           Get Outfunds Namespace Prefix
    Set suite variable                ${ns}
    &{fundingprogram} =               API Create Funding Program
    ${fp_name} =                      Generate New String
    Set suite variable                &{fundingprogram}
    Set suite variable                ${fp_name}
    ${date_1} =                         Get current date    result_format=%m/%d/%Y  increment=1 day
    Set suite variable                  ${date_1}
    ${date_2} =                         Get current date    result_format=%m/%d/%Y  increment=240 days
    Set suite variable                  ${date_2}

*** Test Case ***
Create Funding Program Via API
    [Documentation]                             Creates a Funding Program via API.
    ...                                         Verifies that Funding Program is created and
    ...                                         displays under recently viewed Funding Program
    [tags]                                      feature:FundingProgram
    Go To Page                                  Listing             ${ns}Funding_Program__c
    Capture Page Screenshot
    Click Link With Text                        ${fundingprogram}[Name]
    Wait Until Loading Is Complete
    Current Page Should Be                      Details             Funding_Program__c
    Validate Field Value                       Funding Program Name   contains     ${fundingprogram}[Name]

Create Funding Program via UI in OutboundFunds
    [Documentation]                             Creates a Funding Program via UI.
     ...                                        Verifies that Funding Program is created.
     [tags]                                     feature:FundingProgram
     Go To Page                                 Listing             ${ns}Funding_Program__c
     Capture Page Screenshot
     Click Object Button                        New
     Wait Until Modal Is Open
     Populate New Record Form                   Funding Program Name=${fp_name}
     ...                                        Status=In progress
     ...                                        Start Date=${date_1}
     ...                                        End Date=${date_2}
     ...                                        Description=Automated Robot Funding Program
     ...                                        Total Program Amount=500000
     Click Save
     Verify Toast Message                       Funding Program
     Current Page Should Be                     Details             Funding_Program__c
     Validate Field Value                       Funding Program Name   contains     ${fp_name}
     Validate Field Value                       Total Program Amount   contains     $500,000.00
