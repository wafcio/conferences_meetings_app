require 'bundler/setup'
require 'rom/sql/rake_task'
require_relative 'db/db'

task :setup do
  require_relative 'db/db'
  DB.setup
end

namespace :assets do
  desc "Precompile the assets"
  task :precompile do
    require './app'
    App.compile_assets
  end
end
