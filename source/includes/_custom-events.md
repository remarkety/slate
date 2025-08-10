# Custom Events

```php
$headers = [
    "x-domain: $domain",
    "x-token: $apiKey",
    "x-platform: CUSTOM",
    "x-event-type: custom-event",
    'Content-Type: application/json; charset=UTF-8'
];

$customData = [
   // custom fields
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
// Send a site-search event

var _rmData = _rmData || [];

//Identify using email address
var customerEmail = "<Your customer email here>";
_rmData.push(['setCustomerEmail', customerEmail]);

var eventType = 'site-search';
var data = {
             "searchKeyword": "Red shorts",
             "result_1_title": "Swim Short",
             "result_1_image": "http://www.example.com/swim_shorts.png"
           };
_rmData.push(['track', eventType, data]); 


// On a different page - send a room booking event

var _rmData = _rmData || [];

var customerEmail = "<Your customer email here>";
_rmData.push(['setCustomerEmail', customerEmail]);

var eventType = 'room-booked';
var data = {
             "lodging": {
                 "name": "Kempinski Seychelles Resort",
                 "stars": 5,
                 "type": "resort",
                 "image": "https://r-ec.bstatic.com/images/hotel/max1024x768/169/16951276.jpg"
             },
             "guest": {
                "reservation_name": "John and Jane Doe"   
             }
           };
_rmData.push(['track', eventType, data]); 
```

In addition to the built-in eCommerce events, you can use our client-side tracking script to send custom events as well.
These events, with their associated properties, can be used to trigger automations inside Remarkety.

Top-level properties can be used to filter the events triggering the automation. Any and all properties sent in the 
event can be used inside the email template triggered by this event.   

See some usage examples on the right.

**Please note:** When sending any client-side event (including custom events), the user must first be identified. We 
currently don't track events that were sent without a user being identified first. Please [read here](#identifying-visitors) 
on how to identify users.