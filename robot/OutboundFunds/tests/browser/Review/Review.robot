*** Settings ***
Documentation  Create a Review on a Funding Request.
Resource       robot/OutboundFunds/resources/OutboundFunds.robot
Library        cumulusci.robotframework.PageObjects
...            robot/OutboundFunds/resources/FundingRequestPageObject.py
...            robot/OutboundFunds/resources/ReviewPageObject.py
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
    &{review} =                       API Create Review on a Funding Request
    ...                               ${funding_request}[Id]
    Set Suite Variable                &{review}
    ${review_name1} =                 Generate New String
    Set suite variable                ${review_name1}
    ${review_name2} =                 Generate New String
    Set suite variable                ${review_name2}

*** Test Case ***
Create Review Via API
    [Documentation]                             Creates a Review via API.
    ...                                         Verifies that Review is created
    [tags]                                      feature:Review
    Go To Page                                  Listing             ${ns}Review__c
    Capture Page Screenshot
    Click Link With Text                        ${review}[Name]
    Wait Until Loading Is Complete
    Current Page Should Be                      Details             Review__c

Add a Review on a Funding Request
    [Documentation]                             Creates a Funding Request via API.
    ...                                         Go to Reviews and add a new Review
    [tags]                                      feature:Review
    Go To Page                                  Listing          ${ns}Funding_Request__c
    Click Link With Text                        ${funding_request}[Name]
    Wait Until Loading Is Complete
    Current Page Should Be                      Details          Funding_Request__c
    Click Tab                                   Reviews
    Click Related List Wrapper Button           Reviews                               New
    Wait For Modal                              New                                  Review
    Populate Field                              Review Name        ${review_name1}
    Click Save
    Wait Until Modal is Closed
    Current Page Should Be                      Details          Funding_Request__c
    Click Tab                                   Reviews
    # validtes column names
    Page Should Contain Element                 //span[@title='Review Name']
    Page Should Contain Element                 //span[@title='Status']
    Page Should Contain Element                 //span[@title='Assigned To']
    Page Should Contain Element                 //span[@title='Due Date']    
    Click Flexipage Related List Link           ${review_name1}
    Validate Field Value                        Review Name   contains   ${review_name1}

Create a Review via Review Object Tab
    [Documentation]                             Creates a Review via the Review object tab
    [tags]                                      feature:Review
    Go To Page                                  Listing          ${ns}Review__c
    Click Object Button                         New
    Wait For Modal                              New                                  Review
    Populate Field                              Review Name    ${review_name2}
    Populate Lookup Field                       Funding Request     ${funding_request}[Name]
    Click Save
    Wait Until Modal Is Closed
    Current Page Should Be                      Details           Review__c
    Validate Field Value                        Review Name    contains    ${review_name2}
