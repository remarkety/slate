# Errors

The API may return the following error codes:

Error Code | Meaning
---------- | -------
400 | Bad Request -- The request is malformed or is missing mandatory fields
401 | Unauthorized -- Wrong API key
403 | Forbidden
404 | Not Found
406 | Not Acceptable -- You requested a format that isn't json
418 | I'm a teapot
429 | Too Many Requests -- You are making too many requests in a limited time
500 | Internal Server Error -- We had a problem with our server. Try again later.
503 | Service Unavailable -- We're temporarily offline for maintenance. Please try again later.
