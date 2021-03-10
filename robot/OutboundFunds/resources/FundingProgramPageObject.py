from cumulusci.robotframework.pageobjects import ListingPage
from cumulusci.robotframework.pageobjects import DetailPage
from cumulusci.robotframework.pageobjects import pageobject
from BaseObjects import BaseOutboundFundsPage
from cumulusci.robotframework.utils import capture_screenshot_on_error


@pageobject("Listing", "Funding_Program__c")
class FundingProgramListingPage(BaseOutboundFundsPage, ListingPage):
    @capture_screenshot_on_error
    def _is_current_page(self):
        """Verify we are on the Funding Program Listing page
        by verifying that the url contains '/view'
        """
        self.selenium.location_should_contain(
            "/list?",
            message="Current page is not a Funding Program List view",
        )


@pageobject("Details", "Funding_Program__c")
class FundingProgramDetailPage(BaseOutboundFundsPage, DetailPage):
    @capture_screenshot_on_error
    def _is_current_page(self):
        """Verify we are on the Funding Program detail page
        by verifying that the url contains '/view'
        """
        self.selenium.wait_until_location_contains(
            "/view", timeout=60, message="Detail page did not load in 1 min"
        )
