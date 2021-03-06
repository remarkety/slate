---
title: Remarkety Event Reference

language_tabs:
  - php
  - javascript

toc_footers:
  - <a href='https://github.com/tripit/slate'>Documentation Powered by Slate</a>

includes:
  - built-in-events
  - custom-events
  - receiving-events
  - errors

search: true
---

# Introduction

With Remarkety, you can trigger automations based on various **events** which occur in your system.

## What are events?

**Events** simply describe something that happened on your website or business. Events always have a **type**, a **time** and a **subject**.
 
Some examples of events are:

 * A *customer* made an *order* on your website on *July 4, 2017, 10:00am*.
 * A *visitor* visited a *page* on your website on *February 26, 2016, 8:53pm*.
 * A *product* was restocked to a level of *100* units on  *June 5, 2016, 9:41am*.
 * An *order* was *shipped* to a customer on *Oct 12, 2015, 9:34am*
 * A *subscriber* signed up for a *newsletter* on...
 * A *recipient* clicked on a link in a *campaign* on...

You get the picture ;)

## How are events used in Remarkety?

Events are used within Remarkety to:

* Trigger automations, either immediately or with a delay
* Update eCommerce data in Remarkety (Customers/Orders/Products/Carts).

# Sending Events

## Event Format
All events must have a *type*. Remarkety has some built-in event types for e-commerce which you should use
 if you are sending e-commerce related events. In addition, you can send us any other type of custom event, but we will not
 be able to perform advanced e-commerce related analytics on them. 
 
 The built-in event types are specified in the [E-Commerce Event Types](#e-commerce-event-types) section. For sending 
 your own custom events, please see the [Custom Events](#custom-events) section. 
 
## Server-Side API
```php
<?php

$storeId = "AAABBB";            // Unique per remarkety account
$apiKey = "SuperSecretApiKey";  // Get this from Remarkety 
$eventType = "customers/update"; // See "Event types"
$domain = "kingslanding.com";   // Your store's domain
$platform = "MAGENTO";          // Per-platform setting

$headers = [
    "x-domain: $domain",
    "x-platform: $platform",
    "x-token: $apiKey",
    "x-event-type: $eventType",
    'Content-Type: application/json; charset=UTF-8'
];

$customerData = [
    'created_at' => '2017-04-04T15:12:21-05:00',
    'email' => 'john.snow@thewall.org',
    'first_name' => 'John',
    'last_name' => 'Snow',
    'updated_at' => '2017-04-04T15:12:21-05:00',
    'accepts_marketing' => true
];

$dataString = json_encode($customerData);

$ch = curl_init("https://webhooks.remarkety.com/webhooks/?storeId=$storeId");
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
curl_setopt($ch, CURLOPT_POSTFIELDS, $dataString);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

$result = curl_exec($ch);
```

```javascript
var storeId = "AAABBB";             // Unique per remarkety account - get yours from the API setting page
var eventType = "customers/update"; // See "Event types"

var data = JSON.stringify({
  "email": "john.snow@thewall.org",
  "first_name": "John",
  "last_name": "Snow",
  "accepts_marketing": true
});

// If run server-side, send the request directly to our webhook endpoint, and include your API token
var token ="<Your API token>";  // Never expose this client-side!
var xhr = new XMLHttpRequest();
xhr.withCredentials = true;

xhr.addEventListener("readystatechange", function () {
  if (this.readyState === 4) {
    console.log(this.responseText);
  }
});

xhr.open("POST", "https://webhooks.remarkety.com/webhooks/store/"+storeId);
xhr.setRequestHeader("Content-Type", "application/json");
xhr.setRequestHeader("x-event-type", eventType);
xhr.setRequestHeader("x-token", token);
xhr.setRequestHeader("Cache-Control", "no-cache");

xhr.send(data);
```

The request must be a `POST` request to our endpoint.
The request needs to include the following headers:

Header&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Value | Example
--------- | ------- | ---------
Content-Type | application/json; charset=UTF-8 |
x-event-type | The event type | customers/update
x-api-key | Your Remarkety API Key (not necessary on client-side events) | abc123
x-domain | Your domain (optional) | my.store.com
x-platform | Your e-commerce platform (optional). For custom events use "custom". | MAGENTO1
x-event-time | UNIX timestamp.<br />When this event occurred. By default, Remarkety assumes events happen when a request is made. Add this header if you'd like to track an event that happened in past. | 1573649331

The `body` of the request is simply the event JSON itself.
<aside class="notice">
Your API Key and Store Id can be found on your Integrations page. 
<strong>If integrating client-side, don't expose this variable!</strong>
</aside>
<aside class="notice">
For authentication, you must use one of the two methods: your store API Key in the `x-token` header OR your Remarkety API Key in the `x-api-key`.
</aside>

## Client-Side API

Remarkety's client-side library allows you to send events to Remarkety based on the visitor's actions on the store.

You can also send eCommerce events using the client-side library based on the event payload described on the [E-Commerce event types](#e-commerce-event-types) docs.  

### Adding the client-side snippet

```php
For client-side library examples switch to "javascript" examples
```

```javascript
<script>
var _rmData = _rmData || [];
_rmData.push(['setStoreKey', '<STORE_ID>']);
</script>
<script>(function(d, t) {
var g = d.createElement(t),
s = d.getElementsByTagName(t)[0];
g.src = 'https://d3ryumxhbd2uw7.cloudfront.net/webtracking/track.js';
s.parentNode.insertBefore(g, s);
}(document, 'script'));
</script>
```

All pages on the website should include this piece of code, just before the `</body>` tag.

**Make sure to include the correct `<STORE_ID>` which you can find under _Settings > API Keys_ in your account.**

<br><br><br><br><br><br><br>

### Identifying Visitors

```php
For client-side library examples switch to "javascript" examples
```

```javascript
var _rmData = _rmData || [];
//Identify using email address
_rmData.push(['setCustomer', '<CUSTOMER_EMAIL>']);

//Identify using customer id
_rmData.push(['setCustomerId', '<CUSTOMER_ID>']);

//Identify the customer and update the accepts_marketing and first_name properties
_rmData.push(['setCustomer', {
    "email": "john.snow@thewall.org",
    "first_name": "John",
    "accepts_marketing": true
}]);
```

The `setCustomer` and `setCustomerId` method allows you identify the visitors based on their email address or your internal customer id.

You can also use the `setCustomer` method with customer information, that will get updated in Remarkety contact's details.

For the full list of customer properties please check the ["customers/create"](#customers-create) properties. 

**Please Note:** 

* If the contact does not exists in Remarkety, the setCustomer method will create the contact.
* The `setCustomerId` method requires that the contact will already be synced to Remarkety.
* Without identifying the visitor, Remarkety *will not* receive the events.

<br><br><br><br>

### Sending events

```php
For client-side library examples switch to "javascript" examples
```

```javascript
var _rmData = _rmData || [];
//Sending an eCommerce event for updating the customer data
var eventType = 'customers/update';
var data = {
             "email": "john.snow@thewall.org",
             "first_name": "John",
             "last_name": "Snow",
             "accepts_marketing": true
           };
_rmData.push(['track', eventType, data]);

//Sending a custom event based on visitor's action on the website
var eventType = 'site-search';
var data = {
             "searchKeyword": "Red shorts",
             "result_1_title": "Swim Short",
             "result_1_image": "http://www.example.com/swim_shorts.png"
           };
_rmData.push(['track', eventType, data]);

```

When sending events you can choose to send eCommerce-related events or you can choose to send any custom event with custom properties.

<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

### Product view events

```php
For client-side library examples switch to "javascript" examples
```

```javascript
//Example code for productView event
var _rmData = _rmData || [];
_rmData.push(['productView', {
   productId: '1112222',
   productCategories: ['Men / Shorts', 'Men / Swimwear']
}]);
```

To let Remarkety know that a visitor viewed a particular product, for using in the "Browse Abandonment" automation or product recommendations,
you should send the `productView` event with the properties listed below.

These properties should match the product id as received from the products feed.

Property name | description | required
------------- | ----------- | --------
productId | The product id that the visitor viewed. | Yes
productCategories | List of categories that this product attached to. | No