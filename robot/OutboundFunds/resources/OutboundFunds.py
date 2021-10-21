import logging
import random
import string
import warnings
import time

from BaseObjects import BaseOutboundFundsPage
from selenium.common.exceptions import NoSuchWindowException
from robot.libraries.BuiltIn import RobotNotRunningError
from locators_52 import outboundfunds_lex_locators as locators_52
from locators_51 import outboundfunds_lex_locators as locators_51
from cumulusci.robotframework.utils import selenium_retry, capture_screenshot_on_error
from selenium.webdriver.common.keys import Keys

locators_by_api_version = {
    51.0: locators_51,  # Spring '21
    52.0: locators_52,  # Summer '21
}
# will get populated in _init_locators
outboundfunds_lex_locators = {}


@selenium_retry
class OutboundFunds(BaseOutboundFundsPage):
    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    ROBOT_LIBRARY_VERSION = 1.0

    def __init__(self, debug=False):
        self.debug = debug
        self.current_page = None
        self._session_records = []
        # Turn off info logging of all http requests
        logging.getLogger("requests.packages.urllib3.connectionpool").setLevel(
            logging.WARN
        )
        self._init_locators()

    def _init_locators(self):
        try:
            client = self.cumulusci.tooling
            response = client._call_salesforce(
                "GET", "https://{}/services/data".format(client.sf_instance)
            )
            self.latest_api_version = float(response.json()[-1]["version"])
            if self.latest_api_version not in locators_by_api_version:
                warnings.warn(
                    "Could not find locator library for API %d"
                    % self.latest_api_version
                )
                self.latest_api_version = max(locators_by_api_version.keys())
        except RobotNotRunningError:
            # We aren't part of a running test, likely because we are
            # generating keyword documentation. If that's the case, assume
            # the latest supported version
            self.latest_api_version = max(locators_by_api_version.keys())
        locators = locators_by_api_version[self.latest_api_version]
        outboundfunds_lex_locators.update(locators)

    def get_namespace_prefix(self, name):
        """This is a helper function to capture the namespace prefix of the target org"""
        parts = name.split("__")
        if parts[-1] == "c":
            parts = parts[:-1]
        if len(parts) > 1:
            return parts[0] + "__"
        else:
            return ""

    def get_outfunds_namespace_prefix(self):
        """Get outfunds__ prefix for custom objects"""
        if not hasattr(self.cumulusci, "_describe_result"):
            self.cumulusci._describe_result = self.cumulusci.sf.describe()
        objects = self.cumulusci._describe_result["sobjects"]
        fundingprogram_object = [o for o in objects if o["label"] == "Funding Program"][
            0
        ]
        return self.get_namespace_prefix(fundingprogram_object["name"])

    def _check_if_element_exists(self, xpath):
        """Checks if the given xpath exists
        this is only a helper function being called from other keywords
        """
        elements = int(self.selenium.get_element_count(xpath))
        return True if elements > 0 else False

    def check_if_element_exists(self, xpath):
        """Checks if an element with given xpath exists"""
        elements = self.selenium.get_element_count(xpath)
        return True if elements > 0 else False

    def new_random_string(self, len=5):
        """Generate a random string of fixed length"""
        return "".join(random.choice(string.ascii_lowercase) for _ in range(len))

    def generate_new_string(self, prefix="Robot Test"):
        """Generates a random string with Robot Test added as prefix"""
        return "{PREFIX} {RANDOM}".format(
            PREFIX=prefix, RANDOM=self.new_random_string(len=5)
        )

    def random_email(self, prefix="robot_", suffix="example.com"):
        """
        Return a random fake email address.
        :param prefix: Some text to put in front of the randomized part of the username.
                   Defaults to "robot_"
        :type  prefix: str
        :param suffix: The domain part of the email address.
                   Defaults to "example.com"
        :type  suffix: str
        :returns: The fake email address.
        :rtype: str
        """
        return "{PREFIX}{RANDOM}@{SUFFIX}".format(
            PREFIX=prefix, RANDOM=self.new_random_string(len=5), SUFFIX=suffix
        )

    def click_link_with_text(self, text):
        """Click on link with passed text"""
        locator = outboundfunds_lex_locators["link"].format(text)
        self.selenium.wait_until_page_contains_element(locator)
        element = self.selenium.driver.find_element_by_xpath(locator)
        self.selenium.driver.execute_script("arguments[0].click()", element)

    def click_save(self):
        """Click Save button in modal's footer"""
        locator = outboundfunds_lex_locators["new_record"]["footer_button"].format(
            "Save"
        )
        self.salesforce.scroll_element_into_view(locator)
        self.salesforce._jsclick(locator)

    def validate_field_value(self, field, status, value, section=None):
        """If status is 'contains' then the specified value should be present in the field
        'does not contain' then the specified value should not be present in the field
        """
        if section is not None:
            section = "text:" + section
            self.salesforce.scroll_element_into_view(section)
        list_found = False
        locators = outboundfunds_lex_locators["confirm"].values()
        if status == "contains":
            for i in locators:
                print("inside for loop")
                locator = i.format(field, value)
                print(locator)
                if self.check_if_element_exists(locator):
                    print(f"element exists {locator}")
                    actual_value = self.selenium.get_webelement(locator).text
                    print(f"actual value is {actual_value}")
                    assert (
                        value == actual_value
                    ), "Expected {} value to be {} but found {}".format(
                        field, value, actual_value
                    )
                    list_found = True
                    break
        if status == "does not contain":
            for i in locators:
                locator = i.format(field, value)
                if self.check_if_element_exists(locator):
                    print(f"locator is {locator}")
                    raise Exception(f"{field} should not contain value {value}")
            list_found = True

        assert list_found, "locator not found"

    @capture_screenshot_on_error
    def click_tab(self, label):
        """Click on a tab on a record page"""
        locator = outboundfunds_lex_locators["tab"]["tab_header"].format(label)
        self.selenium.wait_until_element_is_enabled(
            locator, error="Tab button is not available"
        )
        element = self.selenium.driver.find_element_by_xpath(locator)
        self.selenium.driver.execute_script("arguments[0].click()", element)

    @capture_screenshot_on_error
    def click_flexipage_dropdown(self, title, value):
        """Click the lightning dropdown to open it and select value"""
        locator = outboundfunds_lex_locators["new_record"]["flexipage-list"].format(
            title
        )
        option = outboundfunds_lex_locators["span"].format(value)
        self.selenium.wait_until_page_contains_element(locator)
        self.salesforce.scroll_element_into_view(locator)
        element = self.selenium.driver.find_element_by_xpath(locator)
        try:
            self.selenium.get_webelement(locator).click()
            self.wait_for_locator("flexipage-popup")
            self.salesforce.scroll_element_into_view(option)
            self.selenium.click_element(option)
        except Exception:
            self.builtin.sleep(1, "waiting for a second and retrying click again")
            self.selenium.driver.execute_script("arguments[0].click()", element)
            self.wait_for_locator("flexipage-popup")
            self.salesforce.scroll_element_into_view(option)
            self.selenium.click_element(option)

    def click_related_list_wrapper_button(self, heading, button_title):
        """loads the related list  and clicks on the button on the list"""
        locator = outboundfunds_lex_locators["related"]["flexi_button"].format(
            heading, button_title
        )
        self.salesforce._jsclick(locator)
        self.salesforce.wait_until_loading_is_complete()

    @capture_screenshot_on_error
    def click_related_list_link(self, text):
        """Click on link with passed text"""
        locator = outboundfunds_lex_locators["related"]["link"].format(text)
        self.selenium.wait_until_page_contains_element(locator)
        element = self.selenium.driver.find_element_by_xpath(locator)
        self.selenium.driver.execute_script("arguments[0].click()", element)

    def click_flexipage_related_list_link(self, text):
        """Click on link with passed text"""
        locator = outboundfunds_lex_locators["related"]["flexi_link"].format(text)
        self.selenium.wait_until_page_contains_element(locator)
        element = self.selenium.driver.find_element_by_xpath(locator)
        self.selenium.driver.execute_script("arguments[0].click()", element)


    @capture_screenshot_on_error
    def select_value_from_picklist(self, dropdown, value):
        """Select given value in the dropdown field"""
        locator = outboundfunds_lex_locators["new_record"]["dropdown_field"].format(
            dropdown
        )
        self.selenium.wait_until_page_contains_element(locator)
        self.selenium.get_webelement(locator).click()
        self.selenium.get_webelement(locator).click()
        popup_loc = outboundfunds_lex_locators["new_record"]["dropdown_popup"]
        self.selenium.wait_until_page_contains_element(
            popup_loc, error="Picklist dropdown did not open"
        )
        value_loc = outboundfunds_lex_locators["new_record"]["dropdown_value"].format(
            value
        )
        self.salesforce._jsclick(value_loc)

    def populate_new_record_form(self, **kwargs):
        """Populate New Record Form with Key Value Pair"""
        for key, value in kwargs.items():
            if key in (
                "Applying Contact",
                "Applying Employee",
                "Applying Organization",
                "Funding Program",
                "Assigned",
                "Primary Contact",
                "Assigned",
                "Funding Request",
                "Disbursement",
            ):
                locator = outboundfunds_lex_locators["new_record"][
                    "lightning_lookup"
                ].format(key)
                self.check_if_element_exists(locator)
                self.salesforce.scroll_element_into_view(locator)
                self.selenium.set_focus_to_element(locator)
                self.salesforce.populate_lookup_field(key, value)
            elif key in (
                "Requested Amount",
                "Awarded Amount",
                "Recommended Amount",
                "Funding Request Name",
                "Funding Program Name",
                "Total Program Amount",
                "Description",
                "Requirement Name",
            ):
                locator = outboundfunds_lex_locators["new_record"][
                    "amount_field"
                ].format(key)
                self.check_if_element_exists(locator)
                self.salesforce.scroll_element_into_view(locator)
                self.selenium.get_webelement(locator).send_keys(value)
            elif key in (
                "Awarded Date",
                "Close Date",
                "Awarded Date",
                "Application Date",
                "Start Date",
                "End Date",
                "Due Date",
                "Completed Date",
            ):
                locator = outboundfunds_lex_locators["new_record"]["date_field"].format(
                    key
                )
                self.selenium.set_focus_to_element(locator)
                self.selenium.clear_element_text(locator)
                self.selenium.get_webelement(locator).send_keys(value)
            elif key in ("Status", "Geographical Area Served", "Type"):
                locator = outboundfunds_lex_locators["new_record"][
                    "dropdown_field"
                ].format(key)
                self.selenium.get_webelement(locator).click()
                popup_loc = outboundfunds_lex_locators["new_record"]["dropdown_popup"]
                self.selenium.wait_until_page_contains_element(
                    popup_loc, error="Picklist dropdown did not open"
                )
                value_loc = outboundfunds_lex_locators["new_record"][
                    "dropdown_value"
                ].format(value)
                self.salesforce._jsclick(value_loc)
            else:
                raise Exception(f"Field provided by name '{key}' does not exist")

    @capture_screenshot_on_error
    def verify_toast_message(self, value):
        """Verifies the toast message"""
        locator = outboundfunds_lex_locators["toast_message"].format(value)
        self.selenium.wait_until_element_is_visible(locator)
        try:
            close_locator = outboundfunds_lex_locators["toast_close"].format(value)
            self.selenium.wait_until_page_contains_element(close_locator)
            self.selenium.click_element(close_locator)
        except Exception:
            self.builtin.log("The toast could not be closed.", "WARN")

    def select_value_from_dropdown(self, dropdown, value):
        """Select given value in the dropdown field"""
        if dropdown in ("Role", "Status"):
            locator = outboundfunds_lex_locators["funding_req_role"][
                "select_dropdown"
            ].format(dropdown)
            selection_value = outboundfunds_lex_locators["funding_req_role"][
                "select_value"
            ].format(value)
            self.salesforce._jsclick(locator)
            self.selenium.click_element(selection_value)

    @capture_screenshot_on_error
    def share_a_record(self):
        """Click on Sharing link on Funding Request and Requirement Record"""
        locator_sharing = outboundfunds_lex_locators["sharing"]["sharing_button"]
        self.selenium.click_element(locator_sharing)
        locator_sharing_link = outboundfunds_lex_locators["sharing"]["sharing_link"]
        self.selenium.wait_until_page_contains_element(
            locator_sharing_link,
            error="'Sharing' option is not available in the list of actions",
        )
        self.selenium.click_element(locator_sharing_link)
        if self.latest_api_version == 52.0:
            self.selenium.location_should_contain(
                "recordShare?",
                message="Current page is not Share",
            )
        else:
            pass
        locator = outboundfunds_lex_locators["header_title"].format("Share")
        self.selenium.wait_until_page_contains_element(
            locator, error="The header for this page is not 'Share' as expected"
        )
        user_locator = outboundfunds_lex_locators["sharing"]["search_user"]
        set_user = self.selenium.driver.find_element_by_xpath(user_locator)
        set_user.click()
        time.sleep(1)
        set_user.send_keys("PermsTestingUser RobotUser")
        time.sleep(2)
        set_user.send_keys(Keys.ENTER)
        if self.latest_api_version == 52.0:
            save_locator = outboundfunds_lex_locators["sharing"]["save_share"]
        else:
            save_locator = outboundfunds_lex_locators["funding_req_role"][
                "save_button_old"
            ]
        self.selenium.set_focus_to_element(save_locator)
        self.selenium.click_element(save_locator)
