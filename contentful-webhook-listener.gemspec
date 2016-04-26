# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'contentful/webhook/listener/version'

Gem::Specification.new do |spec|
  spec.name          = "contentful-webhook-listener"
  spec.version       = Contentful::Webhook::Listener::VERSION
  spec.authors       = ["Contentful GmbH (David Litvak Bruno)"]
  spec.email         = ["david.litvak@contentful.com"]
  spec.summary       = %q{A Simple HTTP Webserver with pluggable behavior for listening to Contentful API Webhooks}
  spec.description   = %q{A Simple HTTP Webserver with pluggable behavior for listening to Contentful API Webhooks}
  spec.homepage      = "https://github.com/contentful/contentful-webhook-listener.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "listen", "~> 3.0.0"
end
