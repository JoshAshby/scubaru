# Scubaru

![](http://weknowmemes.com/wp-content/uploads/2013/02/scubaru-meme.jpg)

Scubaru is a set of utilities to help me with hacking on rails projects.
Currently it has two parts:
 - A middleware that will set the log level to a different value for certain urls
 - An [ActiveSupport::Notifications](https://github.com/rails/rails/blob/master/activesupport/lib/active_support/notifications.rb) subscriber that pretty logs events on the notification bus.


# Usage

Add this to your `Gemfile`
```ruby
gem 'scubaru', git: 'https://github.com/JoshAshby/scubaru.git', require: 'scubaru'
```

Then you can either stick with the default behavior (which isn't that bad but also not recommended) or you can set up your own options in an initializer:

## Subscriber options
```ruby
# Use rails standard reverse domain notation for notifications
Scubaru::Subscriber.fqn_direction = :reverse

# Use redis style : delimiters for the ASN event name notation
Scubaru::Subscriber.delimiter = ':'

# Only blacklist notifications for railties
Scubaru::Subscriber.blacklist = [
  %r|railtie|
]
```

## Middleware options
```ruby
# change the log level to FATAL for urls in the blacklist
Scubaru::Middleware.log_level = Logger::FATAL

# make any GET request that starts with `/home` has its log level changed to `log_level`
Scubaru::Middleware.blacklist = [
  { pattern: $r|^/home|, method: :get }
]
```
