import stripe
from stripe.webhook import Webhook

stripe.api_key = "sk_test_xyz"
stripe.api_key = 2
stripe.api_base = "http://localhost:12111"
stripe.does_not_exist = "foo"
cus = stripe.Customer.create(email="richard@example.com")
cus = stripe.Customer.create(does_not_exist="richard@example.com")
cus = stripe.Customer.create(idempotency_key=4)
lst = stripe.Customer.list()
lst.data["foo"]
lst.does_not_exist
for x in lst:
    foo1: int = x
    x.bar
for x in lst.data:
    foo2: int = x
    x.bar
for x in lst.auto_paging_iter():
    foo3: int = x
    x.bar
foo4: str = lst.has_more
foo5: bool = lst.has_more
foo6: str = lst.is_empty
page: int = lst.next_page()
cus["id"]
cus.id
cus["does_not_exist"]
cus.does_not_exist
cus.this_method_does_not_exist()
stripe.Customer.this_method_does_not_exist()
Webhook.construct_event("{}", "sig", "secret")
Webhook.construct_event("{}", "sig")
stripe.DoesNotExist.create(foo="bar")
