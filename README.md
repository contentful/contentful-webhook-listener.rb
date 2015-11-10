[![Build Status](https://travis-ci.org/contentful/contentful-webhook-listener.rb.svg)](https://travis-ci.org/contentful/contentful-webhook-listener.rb)

# Contentful Webhook Listener

A Simple HTTP Webserver with pluggable behavior for listening to API Webhooks

## Contentful
[Contentful](http://www.contentful.com) is a content management platform for web applications,
mobile apps and connected devices. It allows you to create, edit & manage content in the cloud
and publish it anywhere via powerful API. Contentful offers tools for managing editorial
teams and enabling cooperation between organizations.

## What does `contentful-webhook-listener` do?
The aim of `contentful-webhook-listener` is to have developers setting up their Contentful
Webhooks for triggering background jobs.

## Installation

Add this line to your application's Gemfile:

    gem 'contentful-webhook-listener'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install contentful-webhook-listener

## Usage

Require gem:

```ruby
require 'contentful/webhook/listener'
```

Create your own Controllers:

```ruby
class MyController < Contentful::Webhook::Listener::Controllers::Wait
  def perform(request, response)
    super(request, response)
    "do your process..." # This will run on a brackground Thread
  end
end
```

Configure and start your Webhook Listener

```ruby
require 'logger'

Contentful::Webhook::Listener::Server.start do |config|
  config[:port] = 5678         # Optional
  config[:address] = "0.0.0.0" # Optional
  config[:logger] = Logger.new(STDOUT) # Optional, will use a NullLogger by default
  config[:endpoints] = [
    {
      endpoint: "/receive",     # Where your server will listen
      controller: MyController, # The controller that will process the endpoint
      timeout: 15               # If using Wait, will wait `X` seconds before executing
    }
  ]
end
```

You can add multiple endpoints, each with it's own Controller.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/contentful-webhook-listener/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
