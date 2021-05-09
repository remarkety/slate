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
  "reason": "554 5.4.14 Hop count exceeded - possible mail loop ATTR34 [SN1NAM04FT063.eop-NAM04.prod.protection.outlook.com]",
  "soft_bounce": true
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

## sms/sent

```json
{
  "timestamp": "2020-07-19T10:12:15.296Z",
  "email": "john@doe.com",
  "campaign_name": "Welcome Campaign",
  "campaign_id": "111112",
  "umk": "5acf31d0b22410.937575625acf31d0b",
  "characters_count": 92,
  "body": "Sample message content.",
  "to": "+15417540000",
  "from": "+15417541111",
  "is_test": false,
  "recipient_country_code": "US"
}
```
Sent when an SMS is sent to the recipient.
campaign_id, campaign_name and umk are all optional fields, if the massage was sent by a system message (double opt-in confirmation, unsubscribe confirmation, etc.) these fields will not get included in the JSON.  

## sms/clicked
```json
{
  "timestamp": "2020-07-19T10:12:15.296Z",
  "to": "+15417540000",
  "from": "+15417541111",
  "email": "john@doe.com",
  "campaign_name": "Welcome Campaign",
  "campaign_id": "111112",
  "umk": "5acf31d0b22410.937575625acf31d0b",
  "is_test": false,
  "ip": "1.1.1.1",
  "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36",
  "url": "https://www.remarkey.com"
}
```

Sent when an SMS link with Remarkety's short URL was clicked.
campaign_id, campaign_name and umk are all optional fields, if the massage was sent by a system message (double opt-in confirmation, unsubscribe confirmation, etc.) these fields will not get included in the JSON.

## sms/replied
```json
{
  "to": "+15417540000",
  "from": "+15417541111",
  "body": "Message content body"
}
```

Triggered when someone sends a message to one of your phone numbers that purchased via Remarkety.

## sms/unsubscribed

```json
{
    "timestamp": "2018-04-12T12:50:00+00:00",
    "email": "john@doe.com",
    "campaign_name": "Abandoned cart #1",
    "campaign_id": 11111,
    "umk": "5acf31d0b22410.937575625acf31d0b",
    "phone_number": "+15417543010",
    "reason": "Unsubscribed via link"
}
```

Sent whenever an SMS contact is unsubscribed, by replying to the account's incoming number or by clicking an unsubscribe link.
campaign_id, campaign_name and umk are all optional fields, if the contact unsubscribed by replying to your incoming number, these fields will not get included in the JSON.

## email-suppression/added

```json
{
  "timestamp": "2018-04-12T12:50:00+00:00",
  "email": "john@doe.com",
  "client_ip": "1.1.1.1",
  "type": "unsubscribed",
  "reason": "Recipient unsubscribed"
}
```

Sent when an email is added to the suppression list and will not receive any marketing emails from now on.

The email address can be added multiple times to the suppression list with different suppression types.
 
#### Suppression types
* unsubscribed
* manually_suppressed
* hard_bounce
* soft_bounce
* spam_complaint
* pending_opt_in
* domain_suppressed
* deleted
* suspected_as_spam

## email-suppression/removed

```json
{
  "timestamp": "2018-04-12T12:50:00+00:00",
  "email": "john@doe.com",
  "client_ip": "1.1.1.1",
  "type": "unsubscribed",
  "reason": "Customer re-subscribed"
}
```

Sent when an email is removed from the suppression list.

The email address can be added multiple times to the suppression list with different suppression types, when a specific type is removed the email might still be in the list with a different suppression type.