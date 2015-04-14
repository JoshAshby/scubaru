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

Then you can either stick with the default behavior, which isn't too recommended or you can set up your own options in an initializer:

## Subscriber options
```ruby
Scubaru::Subscriber.enable = false

# Use rails standard reverse domain notation for notifications
Scubaru::Subscriber.direction = :reverse

# Use redis style : delimiters for domain notation
Scubaru::Subscriber.delimiter = ':'

# Only blacklist notifications for railties
Scubaru::Subscriber.blacklist = Scubaru::Lister.new(items: [
  Scubaru::Subscriber::BlacklistItem(%r|railtie|)
])
```

## Middleware options
```ruby
Scubaru::Middleware.enable = false

# change the log level to FATAL for urls in the blacklist
Scubaru::Middleware.log_level = Logger::FATAL

# make any url that has `/home` in it log quietly
Scubaru::Middleware.blacklist = Scubaru::Lister.new(items: [
  Scubaru::Middleware::BlacklistItem.new($r|^/home|, :GET)
])
```
