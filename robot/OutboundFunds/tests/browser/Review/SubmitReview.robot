*** Settings ***
Documentation  Create a Review on a Funding Request.
Resource       robot/OutboundFunds/resources/OutboundFunds.robot
Library        cumulusci.robotframework.PageObjects
...            robot/OutboundFunds/resources/FundingRequestPageObject.py
...            robot/OutboundFunds/resources/ReviewPageObject.py
...            robot/OutboundFunds/resources/OutboundFunds.py

Suite Setup     Run keywords
...             Open test browser
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
    ${funding_request} =              API Create Funding Request           ${fundingprogram}[Id]
    ...                               ${contact}[Id]
    ...                               ${ns}Status__c=Not Started
    ...                               ${ns}Awarded_Amount__c=100000
    Store Session Record              ${ns}Funding_Request__c         ${funding_request}[Id]
    Set suite variable                ${funding_request}
    &{review} =                       API Create Review on a Funding Request
    ...                               ${funding_request}[Id]
    Set Suite Variable                &{review}
    ${submitted_date} =               Get current date    result_format=%m/%d/%Y
    Set suite variable                ${submitted_date}
    Close Browser

*** Test Case ***
Submit a Review
    [Documentation]                             Submit a Review
    [tags]                                      feature:Review
    Open Test Browser                           useralias=${test_user}
    ${today} =                                  Get current date        result_format=%-m/%d/%Y
    Go To Page                                  Details     Review__c
    ...                                         object_id=${review}[Id]
    Current Page Should Be                      Details             Review__c    
    Validate Field Value                        Status    contains    In Progress
    Click Button                                Submit Review
    Wait until modal is open
    Current page should be                      SubmitReview        Review__c
    Submit Review
    Verify Toast Message                        Review submitted.
    Current Page Should Be                      Details             Review__c
    Validate Field Value                        Status    contains     Submitted
