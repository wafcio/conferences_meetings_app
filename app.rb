require 'rubygems'
require 'bundler/setup'

require 'rack'
require 'roda'
require 'logger'
require 'request_store'

require_relative 'db/db'

class App < Roda
  plugin :render, engine: 'haml'
  plugin :multi_route
  plugin :halt
  plugin :hooks
  plugin :all_verbs
  plugin :symbolized_params

  if [:production, :development].include?(ENV.fetch('RACK_ENV').to_sym)
    use Rack::CommonLogger, Logger.new(STDOUT)
  end

  if [:development, :test].include?(ENV.fetch('RACK_ENV').to_sym)
    require 'dotenv'
    Dotenv.load
  end

  use Rack::Session::Cookie, secret: ENV.fetch('SECRET')
  use Rack::Deflater
  use RequestStore::Middleware

  ROM::Error = Class.new(StandardError)

  DB.setup

  route do |r|
    r.root do
      view('home')
    end

    # require_relative 'apps/products'
    # require_relative 'apps/sessions'
    # require_relative 'apps/users'

    # r.on 'login' do
    #   r.route 'sessions'
    # end

    # r.on 'products' do
    #   r.route 'products'
    # end

    # r.on 'users' do
    #   r.route 'users'
    # end
  end
end
