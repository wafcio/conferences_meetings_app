require 'rubygems'
require 'bundler/setup'

require 'json'
require 'rack'
require 'roda'
require 'logger'
require 'request_store'
require 'tilt/haml'
require 'countries'

require_relative 'db/db'

class App < Roda
  plugin :render, engine: 'haml'
  plugin :partials
  plugin :multi_route
  plugin :halt
  plugin :hooks
  plugin :all_verbs
  plugin :symbolized_params
  plugin :static, ['/images', '/fonts'], root: 'assets'
  plugin :assets,
    css: %w(bootstrap.min.css bootstrap-theme.min.css font-awesome.min.css gh-fork-ribbon.min.css flag-icon.min.css
            meskond.css),
    css_opts: { style: :compressed, cache: false },
    compiled_css_dir: "stylesheets",
    compiled_js_dir: "javascripts",
    compiled_path: nil,
    precompiled: "compiled_assets.json",
    prefix: nil,
    js:%w(jquery-2.1.4.min.js bootstrap.min.js meskond.js)

    # %script{ src: "http://maps.googleapis.com/maps/api/js?libraries=weather,geometry,visualization,places,drawing&amp;sensor=false" }

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
      require_relative 'services/events/get_events'

      @current_year = params[:year] ? params[:year].to_i : Date.today.year
      @years = ROM.env.relation(:events).limit_fields(:year).to_a.map{ |element| element[:year] }.uniq.sort
      @events = GetEvents.call(@current_year)

      view('home')
    end

    r.on 'events' do
      r.get ':id' do |id|
        require_relative 'services/events/get_event'
        require_relative 'services/get_schedule'

        @years = ROM.env.relation(:events).limit_fields(:year).to_a.map{ |element| element[:year] }.uniq.sort
        @event = GetEvent.call(id)
        @schedule = GetSchedule.call(@event[:id])
        @current_year = @event[:year]

        view('events/show')
      end
    end
  end
end
