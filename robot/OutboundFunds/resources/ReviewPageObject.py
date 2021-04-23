from cumulusci.robotframework.pageobjects import ListingPage
from cumulusci.robotframework.pageobjects import DetailPage
from cumulusci.robotframework.pageobjects import pageobject
from BaseObjects import BaseOutboundFundsPage
from OutboundFunds import outboundfunds_lex_locators


@pageobject("Listing", "Review__c")
class ReviewListingPage(BaseOutboundFundsPage, ListingPage):
    def _is_current_page(self):
        """Verify we are on the Review Listing page
        by verifying that the url contains '/view'
        """
        self.selenium.location_should_contain(
            "/list?",
            message="Current page is not a Review List view",
        )


@pageobject("Details", "Review__c")
class ReviewDetailPage(BaseOutboundFundsPage, DetailPage):
    def _is_current_page(self):
        """Verify we are on the Review detail page
        by verifying that the url contains '/view'
        """
        self.selenium.wait_until_location_contains(
            "/view", timeout=60, message="Detail page did not load in 1 min"
        )