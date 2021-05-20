from cumulusci.robotframework.pageobjects import ListingPage
from cumulusci.robotframework.pageobjects import DetailPage
from cumulusci.robotframework.pageobjects import pageobject
from cumulusci.robotframework.pageobjects import BasePage
from BaseObjects import BaseOutboundFundsPage
from OutboundFunds import outboundfunds_lex_locators
from cumulusci.robotframework.utils import capture_screenshot_on_error


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


@pageobject("SubmitReview", "Review__c")
class SubmitReviewPage(BaseOutboundFundsPage, BasePage):
    def _is_current_page(self):
        """Verify we are on the Submit Review
        by verifying that the url contains 'SubmitReview?'
        """
        self.selenium.location_should_contain(
            "SubmitReview?",
            message="Current page is not Submit Review",
        )
        locator = outboundfunds_lex_locators["new_record"]["edit_title"].format(
            "Submit Review"
        )
        self.selenium.wait_until_page_contains_element(
            locator, error="The header for this page is not 'Submit Review' as expected"
        )

    @capture_screenshot_on_error
    def submit_review(self):
        footer_locator = outboundfunds_lex_locators["new_record"]["modal_footer"]
        self.selenium.set_focus_to_element(footer_locator)
        locator = outboundfunds_lex_locators["new_record"][
            "modal_footer_button"
        ].format("Save")
        self.selenium.set_focus_to_element(locator)
        self.salesforce._jsclick(locator)
