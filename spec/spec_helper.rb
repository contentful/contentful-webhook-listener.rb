$LOAD_PATH.unshift File.expand_path('lib', __FILE__)

require 'contentful/webhook/listener'
require 'rspec'
require 'rspec/mocks'

class MockServer
  def [](key)
    nil
  end
end

class MockRequest
end

class MockResponse
  attr_accessor :status, :body
end
