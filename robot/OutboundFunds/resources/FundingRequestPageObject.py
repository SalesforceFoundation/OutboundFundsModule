from cumulusci.robotframework.pageobjects import ListingPage
from cumulusci.robotframework.pageobjects import DetailPage
from cumulusci.robotframework.pageobjects import pageobject
from BaseObjects import BaseOutboundFundsPage
from OutboundFunds import outboundfunds_lex_locators


@pageobject("Listing", "Funding_Request__c")
class FundingRequestListingPage(BaseOutboundFundsPage, ListingPage):
    def _is_current_page(self):
        """Verify we are on the Funding Request Listing page
        by verifying that the url contains '/view'
        """
        self.selenium.location_should_contain(
            "/list?",
            message="Current page is not a Funding Request List view",
        )


@pageobject("Details", "Funding_Request__c")
class FundingRequestDetailPage(BaseOutboundFundsPage, DetailPage):
    def _is_current_page(self):
        """Verify we are on the Funding Request detail page
        by verifying that the url contains '/view'
        """
        self.selenium.wait_until_location_contains(
            "/view", timeout=60, message="Detail page did not load in 1 min"
        )

    def save_disbursement(self):
        """Click Save Disbursement"""
        locator = outboundfunds_lex_locators["details"]["button"].format("Save")
        self.selenium.set_focus_to_element(locator)
        self.selenium.get_webelement(locator).click()

    def save_funding_request_role(self):
        """save funding request role"""
        if self.OutboundFunds.latest_api_version == 52.0:
            locator = outboundfunds_lex_locators["funding_req_role"]["save_button"]
            self.selenium.set_focus_to_element(locator)
            self.selenium.get_webelement(locator).click()
        else:
            locator = outboundfunds_lex_locators["funding_req_role"]["save_button_old"]
            self.selenium.set_focus_to_element(locator)
            self.selenium.get_webelement(locator).click()

    def click_funding_request_role_link(self):
        """click on a link in right panel for funding request role"""
        fr_link = outboundfunds_lex_locators["funding_req_role"]["fr_link"]
        self.selenium.wait_until_page_contains_element(
            fr_link, error="The FR- link is not available"
        )
        self.selenium.get_webelement(fr_link).click()


@pageobject("Details", "Funding_Request_Role__c")
class FundingRequestRoleDetailPage(BaseOutboundFundsPage, DetailPage):
    def _is_current_page(self):
        """Verify we are on the Funding Request detail page
        by verifying that the url contains '/view'
        """
        self.selenium.wait_until_location_contains(
            "/view", timeout=60, message="Detail page did not load in 1 min"
        )
