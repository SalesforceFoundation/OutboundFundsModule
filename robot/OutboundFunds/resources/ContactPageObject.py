from cumulusci.robotframework.pageobjects import DetailPage
from cumulusci.robotframework.pageobjects import ListingPage
from cumulusci.robotframework.pageobjects import pageobject
from BaseObjects import BaseOutboundFundsPage


@pageobject("Listing", "Contact")
class ContactListingPage(BaseOutboundFundsPage, ListingPage):
    object_name = "Contact"


@pageobject("Detail", "Contact")
class ContactDetailPage(BaseOutboundFundsPage, DetailPage):
    object_name = "Contact"
