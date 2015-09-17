require 'rom-csv'
require 'rom-json'
require 'virtus'

class DBClass
  CSV_SETTINGS = [
    { name: :default, options: { encoding: 'utf-8' } }
  ]

  JSON_SETTINGS = [
    { name: :schedules }
  ]

  def setup
    ROM.use(:auto_registration)
    setup_connection_to_db
    load_files
    ROM.finalize
  end

  def setup_connection_to_db
    case ENV.fetch('RACK_ENV', 'development')
    when 'production'
      production_settings
    else
      dev_settings
    end.default.connection
  end

  private

  def rom_settings
    {}.tap do |settings|
      CSV_SETTINGS.each do |csv_setting|
        settings[csv_setting[:name]] = [:csv, expand_path(:csv, csv_setting[:name]), csv_setting[:options]]
      end
      JSON_SETTINGS.each do |json_setting|
        settings[json_setting[:name]] = [:json, expand_path(:json, json_setting[:name])]
      end
    end
  end

  def production_settings
    ROM.setup(rom_settings)
  end

  def dev_settings
    ROM.setup(rom_settings)
  end

  def load_files
    %w(models params validators commands mappers relations).each do |dir|
      paths = File.join(db_dir, dir, '**', '*.rb')
      Dir[paths].each{|file| require file}
    end
  end

  def expand_path(kind, name)
    File.expand_path("./#{kind}/#{name}.#{kind}", File.dirname(__FILE__))
  end

  def db_dir
    File.dirname __FILE__
  end

  def env
    ENV.fetch('RACK_ENV', 'development')
  end
end

DB = DBClass.new
