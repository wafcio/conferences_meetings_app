ENV['RACK_ENV'] = 'test'

require 'rack/test'
require_relative '../app'

module AppSetup
  def self.included(base)
    base.instance_eval do
      include Rack::Test::Methods
    end
  end

  def app
    Rack::Builder.new do
      run App
    end
  end
end
