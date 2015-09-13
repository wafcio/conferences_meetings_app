require 'rubygems'
require 'bundler/setup'

require 'rack'
require 'roda'
require 'logger'
require 'request_store'
require 'tilt/haml'

require_relative 'db/db'

class App < Roda
  plugin :render, engine: 'haml'
  plugin :multi_route
  plugin :halt
  plugin :hooks
  plugin :all_verbs
  plugin :symbolized_params
  plugin :assets, css: ['meskond.css'], js: ['meskond.js']
  plugin :static, ['/images'], root: 'assets'

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
    r.assets

    r.root do
      require 'json'
      require 'countries'
      require_relative 'services/events/get_event'

      @current_year = params[:year] ? params[:year].to_i : Date.today.year
      @years = ROM.env.relation(:events).limit_fields(:year).to_a.map{ |element| element[:year] }.uniq.sort
      @events = GetEvents.call(@current_year)

      view('home')
    end
  end
end
