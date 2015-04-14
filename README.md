# Scubaru

![](http://weknowmemes.com/wp-content/uploads/2013/02/scubaru-meme.jpg)

Scubaru is a set of utilities to help me with hacking on rails projects.
Currently it has two parts:
 - A middleware that will set the log level to a different value for certain urls
 - An [ActiveSupport::Notifications](https://github.com/rails/rails/blob/master/activesupport/lib/active_support/notifications.rb) subscriber that pretty logs events on the notification bus.
