import stripe
from stripe.stripe_response import StripeResponse
from stripe.stripe_object import StripeObject
import stripe.util as util
from stripe.webhook import Webhook
from stripe.api_resources.list_object import ListObject
from stripe.api_resources.abstract.api_resource import APIResource
from collections import OrderedDict
import json

stripe.api_key = "sk_test_xyz"
stripe.api_base = "http://localhost:12111"
cuss = stripe.Customer.list()
# Check if cuss instanceof ListObject
if not isinstance(cuss, ListObject):
    raise Exception("Customers.list() should return a ListObject")

cus = cuss.data[0]
if not isinstance(cus, APIResource) or not isinstance(cus, stripe.Customer):
    raise Exception("Customers.list() should return a ListObject of Customer")
cus = cus.modify(cus.id, email="jenny.rosen@example.com")

if cus.last_response.code != 200:
    raise Exception("Customer.modify() should return 200")

obj = util.convert_to_stripe_object(
    json.loads(cus.last_response.body, object_pairs_hook=OrderedDict)
)
if not isinstance(obj, StripeObject):
    raise Exception("convert_to_stripe_object should return a StripeObject")

try:
    Webhook.construct_event("", "", "secret")
except stripe.error.SignatureVerificationError:
    pass


stripe.default_http_client = stripe.http_client.RequestsClient()
stripe.terminal.Reader.create(registration_code="123")
try:
    import pycurl

    stripe.default_http_client = stripe.http_client.PycurlClient()
    stripe.terminal.Reader.create(registration_code="123")
except ImportError:
    pass
stripe.default_http_client = stripe.http_client.Urllib2Client()
reader = stripe.terminal.Reader.create(registration_code="123")

print("Did not crash!!")
