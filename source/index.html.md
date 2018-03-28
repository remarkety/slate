---
title: Remarkety Event Reference

language_tabs:
  - php

toc_footers:
  - <a href='https://github.com/tripit/slate'>Documentation Powered by Slate</a>

includes:
  - built-in-events
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
* Segment customers based on actions that they've done (or haven't done)

# Sending Events

## Event Format
All events must have a *type*. Remarkety has some built-in event types for e-commerce which you should use
 if you are sending e-commerce related events. In addition, you can send us any other type of event, but we will not
 be able to perform advanced e-commerce related analytics on them. The built-in event types are specified in the 
 [Built-In Events](#built-in-events) section.
 
## Making the Request
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
var storeId = "AAABBB";            // Unique per remarkety account
var eventType = "customers/update"; // See "Event types"

var data = JSON.stringify({
  "email": "john.snow@thewall.org",
  "first_name": "John",
  "last_name": "Snow",
  "accepts_marketing": true
});

var xhr = new XMLHttpRequest();
xhr.withCredentials = true;

xhr.addEventListener("readystatechange", function () {
  if (this.readyState === 4) {
    console.log(this.responseText);
  }
});

xhr.open("POST", "https://webhooks-staging.remarkety.com/webhooks/store/"+storeId);
xhr.setRequestHeader("Content-Type", "application/json");
xhr.setRequestHeader("x-event-type", eventType);
xhr.setRequestHeader("Cache-Control", "no-cache");

xhr.send(data);

```
The request must be a `POST` request to our endpoint.
The request needs to include the following headers:

Header | Value | Example
--------- | ------- | ---------
Content-Type | application/json; charset=UTF-8 |
x-event-type | The event type | customers/update
x-token | Your API Key (not necessary on client-side events) | abc123
x-domain | Your domain (optional) | my.store.com
x-platform | Your e-commerce platform (optional) | MAGENTO1

The `body` of the request is simply the event JSON itself.
<aside class="notice">
Your API Key and Store Id can be found on your Integrations page. 
<strong>If integrating client-side, don't expose this variable!</strong>
</aside>