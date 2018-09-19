*** Settings ***

Resource        tests/OutboundFunds.robot
Suite Setup     Open Test Browser
Suite Teardown  Delete Records and Close Browser

*** Test Cases ***

Create Requirement via Quick Action
    # Create Funding Request
    &{program} =          API Create Funding Program
    &{request} =          API Create Funding Request
    ...                       program_id=&{program}[Id]
    
    # Open Funding Request in the browser
    Go To Record Home     &{request}[Id]

    # Validate that the Quick Action is on the layout
    Page Should Contain   New Requirement

    # Use the Quick Action in the browser
    ${name} =             Generate Random String
    Click Object Button   New Requirement
    Populate Form
    ...                   Requirement Name=${name}
    Click Modal Button    Save
    Wait Until Modal Is Closed
    Click Link            ${name}
    Capture Page Screenshot
    ${requirement_id} =   Get Current Record Id
    Store Session Record  Requirement__c  ${requirement_id}

    # Validate the created Requirement
    &{requirement} =      Salesforce Get  Requirement__c  ${requirement_id}
    Should Be Equal       &{requirement}[Name]  ${name}
    Should Be Equal       &{requirement}[Funding_Request__c]  &{request}[Id]