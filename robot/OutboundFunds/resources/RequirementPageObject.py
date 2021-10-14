from cumulusci.robotframework.pageobjects import ListingPage
from cumulusci.robotframework.pageobjects import DetailPage
from cumulusci.robotframework.pageobjects import pageobject
from BaseObjects import BaseOutboundFundsPage
from cumulusci.robotframework.utils import capture_screenshot_on_error


@pageobject("Listing", "Requirement__c")
class RequirementListingPage(BaseOutboundFundsPage, ListingPage):
    @capture_screenshot_on_error
    def _is_current_page(self):
        """Verify we are on the Requirement Listing page
        by verifying that the url contains '/view'
        """
        self.selenium.location_should_contain(
            "Requirement__c/list?",
            message="Current page is not a Requirement List view",
        )


@pageobject("Details", "Requirement__c")
class RequirementDetailPage(BaseOutboundFundsPage, DetailPage):
    @capture_screenshot_on_error
    def _is_current_page(self):
        """Verify we are on the Requirement detail page
        by verifying that the url contains '/view'
        """
        self.selenium.wait_until_location_contains(
            "/view", timeout=60, message="Detail page did not load in 1 min"
        )
