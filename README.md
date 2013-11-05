## Install

```ruby
  gem install keepify
```

## Usage

### Initialize Keepify

```ruby
  @keepify = Keepify::Tracker.new(YOUR_KEEPIFY_API_TOKEN, asynch)
```
* **async** : Boolean

  *Default: false*

  Built in async feature. When set to true, the http tracking requests are sent from a separate thread. This solution may become inefficient if your application generates events at a high rate. in that case, consider using a more robust solution such as using eventmachine or delegating the tracking to a background job using resque.

### Tracking events

```ruby
  @keepify.trackEvent(event_type, user_id, options)
```
Where **event_type** is a string representing the type of the tracked event, for example : "page_view" or "item_purchase", **user_id** is a unique identifier of the tracked user such as the user's email.
and **options** is a hash that accepts the following keys:

  * **kphn** : hostname e.g. "http://mysite.com"
  * **kppt** : page title e.g. "homepage"
  * **kpr** : the referral url
  * **kppr** : the path of the current URL e.g. "/myitems/1"