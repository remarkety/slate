# E-Commerce Event Types

Following is a list of e-commerce **Event Types** and their JSON format. Each event type has several mandatory fields, which must 
by included in the JSON. The rest are optional, but the more data you send the more accurate Remarkety can be in
analyzing the data and communicating with your customer. 

The event type must be specified in the `x-event-type` header.

## customers/create

```json
{
  "accepts_marketing": true,
  "birthdate": "1997-02-26",
  "created_at": "2012-02-15T15:12:21-05:00",
  "default_address": {
    "country": "United States",
    "country_code": "USA",
    "province_code": "MO",
    "zip": "45415-3423",
    "phone": "1-923-555-5555"
  },
  "email": "guy@remarkety.com",
  "first_name": "Guy",
  "gender": "M",
  "groups": [
    {
      "id": 1,
      "name": "VIP Customers"
    }
  ],
  "id": 1234,
  "info": {},
  "last_name": "Harel",
  "updated_at": "2012-02-15T15:12:21-05:00",
  "tags": [
    "tag1",
    "tag2"
  ],
  "title": "Mr.",
  "verified_email": true
}
```

Used to inform Remarkety about customers being created or updated.

### Mandatory Fields
Field | Data type | Description
--------- | ------- | ---------
`email` *or* <br>`id`| Valid email and/or user id (string)| Send at least one of these fields.<br>If the email of a user has changed, <br>the user_id will be used to locate the record.
`accepts_marketing` | Boolean | If the user did not explicitly opt in or out on the website, send `null` here.
`created_at` | 

## customers/update

Same format as [customers/create](#customers-create). Used to inform Remarkety about a customer update.

If the customer has changed her email address, make sure to send a valid `id`. Remarkety will then update the 
customer record based on this id. Otherwise, a new customer might be created with the new email.

## orders/create

```json
{
  "created_at": "2012-02-15T15:12:21-05:00",
  "currency": "USD",
  "customer": {
    "accepts_marketing": true,
    "birthdate": "1997-02-26",
    "created_at": "2012-02-15T15:12:21-05:00",
    "default_address": {
      "country": "United States",
      "country_code": "USA",
      "province_code": "MO",
      "zip": "45415-3423",
      "phone": "1-923-555-5555"
    },
    "email": "guy@remarkety.com",
    "first_name": "Guy",
    "gender": "M",
    "groups": [
      {
        "id": 1,
        "name": "VIP Customers"
      }
    ],
    "id": 1234,
    "info": {},
    "last_name": "Harel",
    "updated_at": "2012-02-15T15:12:21-05:00",
    "tags": "tag1,tag2",
    "title": "Mr.",
    "verified_email": true
  },
  "discount_codes": [
    {
      "code": "10OFF",
      "amount": 20,
      "type": "fixed_amount"
    }
  ],
  "email": "guy@remarkety.com",
  "fulfillment_status": "string",
  "id": 1234,
  "line_items": [
    {
      "product_id": 1234,
      "quantity": 1,
      "sku": "SKU1234",
      "name": "Blue Shirt, Size S",
      "url": "https://my.cool.store/catalog/cool-gadget.html",
      "image": "https://my.cool.store/images/cool-gadget.jpg",
      "title": "Shirt",
      "variant_title": "Blue",
      "vendor": "Castro",
      "price": 100,
      "taxable": true,
      "tax_lines": [
        {
          "title": "VAT",
          "price": 18,
          "rate": 0.18
        }
      ],
      "added_at": "2012-02-15T15:12:21-05:00",
    }
  ],
  "note": "Please don't break this!",
  "shipping_lines": [
    {
      "title": "Fedex 2-day",
      "price": 20,
      "code": "fedex-2-day"
    }
  ],
  "status": {
    "code": "S",
    "name": "Shipped"
  },
  "financial_status": {
    "code": "S",
    "name": "Shipped"
  },
  "subtotal_price": 100,
  "tax_lines": [
    {
      "title": "VAT",
      "price": 18,
      "rate": 0.18
    }
  ],
  "taxes_included": true,
  "test": true,
  "total_discounts": 20,
  "total_line_items_price": 100,
  "total_price": 100,
  "total_shipping": 20,
  "total_tax": 18,
  "total_weight": 150,
  "updated_at": "2012-02-15T15:12:21-05:00",
  "source": "POS"
}
```

Used to inform Remarkety about a new order in the system. 
Send us much information as possible here.

Note that the `order` information is a nested object which also includes information about the `customer` and `lineitems`.
 
### Mandatory fields
 
 Field | Data type | Description
 --------- | ------- | ---------
 `id` | String | The order id in your backoffice
 `created_at` | Datetime string (with timezone) | Order creation date.
 `customer.accepts_marketing` | Boolean | Is the customer opted in to marketing emails
 `customer.created_at` | Datetime string (with timezone) | The time this customer was created
 `customer.updated_at` | Datetime string (with timezone) | The time this customer was last updated
 `customer.email` | Valid email | The email associated with the customer.
 `lineitems[].product_id` | String | Your backoffice's product id
 `lineitems[].quantity` | Numeric | The amount of this item in the order
 `lineitems[].sku` | String | The SKU of this item
 `lineitems[].name` | String | The name of the product to be displayed to the user
 `lineitems[].url` | URL | A link to this item's product page in your store
 `lineitems[].image` | URL | URL of the image of this item or product
 `lineitems[].price` | Numeric | The price of this item in this specific order
 `status.name` | String | The name of the order status
 `subtotal_price` | Numeric | Order subtotal 
 `total_discounts` | Numeric | The total of all discounts applied. This should be a **positive** number.
 `total_shipping` | Numeric | Shipping costs for this order
 `total_tax` | Numeric | Tax added to this order
 `total_price` | Numeric | The total that the customer was charged for this order

## orders/update

Same format as [orders/create](#orders-create). Inform Remarkety about an order being updated (status changed, products changed, etc)

## products/create

```json
{
  "body_html": "This is an <strong>awesome</strong> product!",
  "categories": [
    {
      "code": 12,
      "name": "Men's clothing"
    }
  ],
  "created_at": "2012-02-15T15:12:21-05:00",
  "id": 1234,
  "image": {
    "id": 1111,
    "product_id": 1234,
    "created_at": "2012-02-15T15:12:21-05:00",
    "updated_at": "2012-02-15T15:12:21-05:00",
    "src": "https://my.cool.store/image1.jpg",
    "variant_ids": [
      null
    ]
  },
  "images": [
    {
      "id": 1111,
      "product_id": 1234,
      "created_at": "2012-02-15T15:12:21-05:00",
      "updated_at": "2012-02-15T15:12:21-05:00",
      "src": "https://my.cool.store/image1.jpg",
      "variant_ids": [
        null
      ]
    }
  ],
  "options": [
    {
      "id": 4444,
      "name": "Color",
      "values": [
        "red"
      ]
    }
  ],
  "published_at": "2012-02-15T15:12:21-05:00",
  "product_exists": true,
  "sku": "SKU1234",
  "tags": "cool,new",
  "title": "Cool Gadget",
  "updated_at": "2012-02-15T15:12:21-05:00",
  "url": "https://my.cool.store/catalog/cool-gadget.html",
  "variants": [
    {
      "barcode": "string",
      "currency": "USD",
      "created_at": "2012-02-15T15:12:21-05:00",
      "fulfillment_service": "string",
      "id": 12345,
      "image": "https://my.cool.store/images/image1.jpg",
      "inventory_quantity": 12,
      "price": 199.23,
      "product_id": 1234,
      "sku": "SKU1234",
      "taxable": true,
      "title": "Blue Shirt",
      "option1": "Blue",
      "updated_at": "2012-02-15T15:12:21-05:00",
      "requires_shipping": true,
      "weight": 150,
      "weight_unit": "g"
    }
  ],
  "vendor": "Samsung"
}
```

Inform Remarkety about a new product.

### What are product variants?

A variant is a "subtype" of a more generic product. For example, for the product "Nike Air Jordan", you would
have different variants such as White / Size 12 or Black / Size 12.

For an iPhone 7, you might have the Silver / 32GB and the Gold / 256GB variants.

If you don't have such variants (for example: you sell A Chair), then the product would have exactly one variant, with 
most of the properties (SKU, id, etc) being duplicated into the variant.

### Mandatory fields
 
 Field | Data type | Description
 --------- | ------- | ---------
 `id` | String | The product id in your backoffice
 `sku` | String | The product SKU
 `created_at` | Datetime string (with timezone) | The time this product was created
 `image.src` | URL | URL of the main product image thumbnail
 `product_exists` | Boolean | Is this product currently for sale in the store?
 `title` | String | Short title describing the product
 `url` | URL | Link to the product page on the store website
 `vendor` | String | Name of the product vendor/manufacturer
 `variants[].id` | String | The backoffice ID of this specific variant
 `variants[].image` | URL | The image URL of this variant
 `variants[].inventory_quantity` | Numeric | # of items youhave in stock
 `variants[].product_id` | Numeric | The id of this variant's parent
 `variants[].sku` | String | The SKU of this product variant
 `variants[].title` | String | The title of this specific variant
  
 
## products/update

Similar to [products/create](#products-create), inform Remarkety about a product that's been updated.

## products/delete

Products **cannot** be deleted, but they can be updated so that they are no longer available for recommendations.
To do this, update the product with `product_exists=false`.

## carts/create
```json
{
    "abandoned_checkout_url": "https://my.cool.store/carts/2341234sdfasdf",
    "billing_address": {
      "country": "United States",
      "country_code": "USA",
      "province_code": "MO",
      "zip": "45415-3423",
      "phone": "1-923-555-5555"
    },
    "accepts_marketing": true,
    "cart_token": "cart_abc",
    "created_at": "2012-02-15T15:12:21-05:00",
    "currency": "USD",
    "customer": {
      "accepts_marketing": true,
      "birthdate": "1997-02-26",
      "created_at": "2012-02-15T15:12:21-05:00",
      "default_address": {
        "country": "United States",
        "country_code": "USA",
        "province_code": "MO",
        "zip": "45415-3423",
        "phone": "1-923-555-5555"
      },
      "email": "guy@remarkety.com",
      "first_name": "Guy",
      "gender": "M",
      "groups": [
        {
          "id": 1,
          "name": "VIP Customers"
        }
      ],
      "id": 1234,
      "info": {},
      "last_name": "Harel",
      "updated_at": "2012-02-15T15:12:21-05:00",
      "tags": "tag1,tag2",
      "title": "Mr.",
      "verified_email": true
    },
    "discount_codes": [
      {
        "code": "10OFF",
        "amount": 20,
        "type": "fixed_amount"
      }
    ],
    "email": "guy@remarkety.com",
    "fulfillment_status": "string",
    "id": 1234,
    "line_items": [
      {
        "product_id": 1234,
        "quantity": 1,
        "sku": "SKU1234",
        "name": "Blue Shirt, Size S",
        "title": "Shirt",
        "variant_title": "Blue",
        "vendor": "Castro",
        "price": 100,
        "taxable": true,
        "tax_lines": [
          {
            "title": "VAT",
            "price": 18,
            "rate": 0.18
          }
        ],
        "added_at": "2012-02-15T15:12:21-05:00"
      }
    ],
    "note": "Please don't break this!",
    "shipping_address": {
      "country": "United States",
      "country_code": "USA",
      "province_code": "MO",
      "zip": "45415-3423",
      "phone": "1-923-555-5555"
    },
    "shipping_lines": [
      {
        "title": "Fedex 2-day",
        "price": 20,
        "code": "fedex-2-day"
      }
    ],
    "subtotal_price": 100,
    "tax_lines": [
      {
        "title": "VAT",
        "price": 18,
        "rate": 0.18
      }
    ],
    "taxes_included": true,
    "total_discounts": 20,
    "total_line_items_price": 100,
    "total_price": 100,
    "total_shipping": 20,
    "total_tax": 18,
    "total_weight": 150,
    "updated_at": "2012-02-15T15:12:21-05:00"
  }
```

When a user browses the site, they will start (hopefully) adding products to the cart. As long as the cart did not turn
into an actual order, you should use the `carts` endpoints in order to let Remarkety know about them. If the cart is 
anonymous (most are...), the `customer` and `emails` fields can be sent as `null`.

### Mandatory fields
 
 Field | Data type | Description
 --------- | ------- | ---------
 `abandoned_checkout_url` | URL | This URL should lead to the cart contents. Optimally, this URL should work on any browser.
 `accepts_marketing` | Boolean | Does this customer accept email marketing?
 `created_at` | Datetime string (with timezone) | Time that this cart was originally created
 `currency` | String | 3-letter code of this cart's currency
 `customer` | Boolean | If this cart is not a guest (anonymouns) cart, send the customer information here. Otherwise set to `null` 
 `customer.accepts_marketing` | Boolean | Does this customer accept marketing?
 `customer.email` | Email | The email address of this customer
 `customer.id` | String | The backoffice customer id
 `email` | String | For guest checkouts, this can be set even if there is no registered customer. If unknown, set as `null`
 `id` | String | The cart ID in the backoffice. Used when updating (and deleting) the cart.
 `title` | String | Short title describing the product
 `line_items` | Array| The products in the cart. Same as in the order
 `total_discounts` | Numeric | Discounts given for this cart
 `total_price` | Numeric | Total price of this cart, incl tax, discounts and shipping
 `updated_at` | Datetime (with timezone) | Last time this cart was updated. **Very important** for timing the emails.
 
## carts/update
 
Same format as [carts/create](#carts-create). Make sure to keep the same `id` so that carts don't get duplicated.
 
## carts/delete
```json
{
   "id": 1234
}
```
Be sure to send a `carts/delete` event with the cart ID once a cart turns into an order.
 
## newsletter/subscribe
```json
{
  "email": "shopper@gmail.com",
  "first_name": "Edgar",
  "last_name": "Poe",
  "tags": ["politics", "sport"]
}
```
Send this event to inform Remarkety of a customer's explicit wish to receive email newsletters.
When Remarkety received this event, we **will not** send an opt-in confirmation. If you would like Remarkety to handle
the double opt-in process, send a `customer/create` event instead, with `accepts_marketing: true`.

## newsletter/unsubscribe
```json
{
"email": "shopper@gmail.com"
}
```
Inform Remarkety that a shopper wishes to unsubscribe. We will add this email to our suppression list, so that if the
customer record is updated from different sources, we will **not** send marketing materials to this user, even if the
customer record contains `accepts_marketing: true`. 

If you would like to resubscribe the customer after an unsusbcribe event, send an explicit `newsletter/subscribe` event.
