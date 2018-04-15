# Receiving Events

In many cases, in addition to sending events to Remarkety, you'd also like to be informed on actions that Remarkety
performs or knows about, such as email sends, opens, clicks and unsubscribes.

Remarkety supports publishing these events via JSON webhooks. You supply an SSL (https) endpoint, and we will POST 
events to that endpoint as detailed below.

## Setup
Setup your receiving endpoint in your Remarkety Settings page.

## Webhook Structure

```http
POST /endpoint.yoursite.com HTTP/1.1
X-Event-Hmac-SHA256: 4293d6f6232a9d346fbd5da0ba0c9a86851675507b750509373f227414f3cb98
X-Event-Topic: newsletter/subscribed
Content-Type: application/json
User-Agent: Remarkety
Cache-Control: no-cache

{
	"email": "john@doe.com",
	"ip_signup": "10.0.0.1",
	"ip_opt": "10.0.0.1",
	"properties": {
		"first_name": "John",
		"last_name": "Doe",
		"campaign": "Lead gen #3"
	}
}
```

Our POST to your endpoint will have the structure shown on the right:

### Headers
 Header | Purpose
 ------ | -------
 `X-Event-Hmac-SHA256` | Message digest for authentication - see below
 `X-Event-Topic` | The event topic, or type

### Body
The request body will contain JSON-formatted text as detailed in the topics below.
 
## Authentication
```php
<?php
define('SHARED_SECRET', '<shared secret>');

function verify_webhook($data, $hmac_header)
{
  $calculated_hmac = base64_encode(hash_hmac('sha256', $data, SHARED_SECRET, true));
  return hash_equals($hmac_header, $calculated_hmac);
}


$hmac_header = $_SERVER['HTTP_X_EVENT_HMAC_SHA256'];
$data = file_get_contents('php://input');
$verified = verify_webhook($data, $hmac_header);
if ($verified) {
    $payload = json_decode($data);
    $eventTopic = $_SERVER['HTTP_X_EVENT_TOPIC'];
} else {
    error_log("Invalid signature");
}
```
    
In order to verify that the request came from Remarkety, you can use the X-Event-Hmac-SHA256 header, which includes
a digital signature of the message contents (body only - not including the headers). We create the signature using the 
Shared Secret provided in the app. On the right is a PHP example on how to verify the signature.

## Retries and Errors
We expect your endpoint to respond within 5 seconds with a 2xx return code. In case the request exceeds the timeout or 
returns with a 5xx error code, we will continue retrying in increasing intervals, for 2 hours. If we fail after 2 hours,
we will stop retrying and will send an email to the account administrator.
  
# Event Topics and Payloads

Common fields:

   Field | Purpose
   ----- | -------
   timestamp | The timestamp of the event itself
   email | The recipient's email address (cc or bcc will not trigger events)
   campaign_name | The plain-text name of the campaign that triggered this email
   campaign_group | The plain-text name of the campaign group
   campaign_id | The internal Remarkety id of the campaign
   umk | A unique identifier per email message
   useragent | The useragent header as sent by the recipient's email client
   ip | The ip address of the recipient
   
   
## email/sent

```json
{
  "timestamp": "2018-04-12T12:50:00+00:00",
  "email": "john@doe.com",
  "campaign_name": "Abandoned cart #1",
  "campaign_id": 13118,
  "umk": "5acf31d0b22410.937575625acf31d0b"
}
```

Sent when an email is sent to the recipient.

## email/clicked

```json
{
  "timestamp": "2018-04-12T12:50:00+00:00",
  "email": "john@doe.com",
  "campaign_name": "Abandoned cart #1",
  "campaign_id": 13118,
  "umk": "5acf31d0b22410.937575625acf31d0b",
  "link_url": "https://my.website.com/some-page",
  "useragent": "Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko Firefox/11.0 (via ggpht.com GoogleImageProxy)",
  "ip": "1.2.3.4"
}
```

Sent when a recipient clicks on a link inside an email

## email/opened

```json
{
  "timestamp": "2018-04-12T12:50:00+00:00",
  "email": "john@doe.com",
  "campaign_name": "Abandoned cart #1",
  "campaign_id": 13118,
  "umk": "5acf31d0b22410.937575625acf31d0b",
  "useragent": "Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko Firefox/11.0 (via ggpht.com GoogleImageProxy)",
  "ip": "1.2.3.4"
}
```

Sent when an email is opened. This is not 100% correct because open tracking is done via images, which are sometimes blocked
and sometimes opened by the receiving mail server and not the actual, human recipient.

## email/delivered
```json
{
  "timestamp": "2018-04-12T12:50:00+00:00",
  "email": "john@doe.com",
  "campaign_name": "Abandoned cart #1",
  "campaign_id": 13118,
  "umk": "5acf31d0b22410.937575625acf31d0b"
}
```
Sent when the recipient's email server acknowledges receipt of the message. This does not necessarily mean that the email 
reached the inbox.

## email/bounced

```json
{
  "timestamp": "2018-04-12T12:50:00+00:00",
  "email": "john@doe.com",
  "campaign_name": "Abandoned cart #1",
  "campaign_id": 13118,
  "umk": "5acf31d0b22410.937575625acf31d0b",
  "reason": "554 5.4.14 Hop count exceeded - possible mail loop ATTR34 [SN1NAM04FT063.eop-NAM04.prod.protection.outlook.com]"
}
```

Sent when the receiving email server does not accept the message. May signal a soft bounce (for example: mailbox full) 
or a hard bounce (address doesn't exist).

## email/spam

```json
{
  "timestamp": "2018-04-12T12:50:00+00:00",
  "email": "john@doe.com",
  "campaign_name": "Abandoned cart #1",
  "campaign_id": 13118,
  "umk": "5acf31d0b22410.937575625acf31d0b"
}
```

Sent when an email is marked as spam. Not all email servers send back a spam notification, gmail in particular does *not*.

## email/unsubscribed

```json
{
  "timestamp": "2018-04-12T12:50:00+00:00",
  "email": "john@doe.com",
  "campaign_name": "Abandoned cart #1",
  "campaign_id": 13118,
  "umk": "5acf31d0b22410.937575625acf31d0b"
}
```

## newsletter/unsubscribed

```json
{
  "timestamp": "2018-04-12T12:50:00+00:00",
  "email": "john@doe.com"
}
```
Sent when a customer's marketing preferences changes to "no", either by unsubscribing directly from a Remarkety email, 
by an admin setting on the website, or by an external API call.

## newsletter/subscribed

```json
{
  "timestamp": "2018-04-12T12:50:00+00:00",
  "optin_timestamp": "2018-04-12T12:55:00+00:00",
  "email": "john@doe.com",
  "signup_ip" : "1.2.3.4",
  "optin_ip": "1.2.3.4"
}
```
Sent when a customer's marketing preferences changes to "yes", either by signing up to a popup, by an API call, or by an
admin in the app. `signup_ip` (optional) is the IP address used to initially sign up the user (might a server IP if this was an API call).
`optin_ip` (optional) is the IP used to click the "confirm email" link in the double opt-in email, if sent.