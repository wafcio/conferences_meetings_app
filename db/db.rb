require 'rom-csv'
require 'virtus'

class DBClass
  CSV_SETTINGS = [
    { name: :default, options: { encoding: 'utf-8' } }
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

  def csv_settings
    {}.tap do |settings|
      CSV_SETTINGS.each do |csv_setting|
        settings[csv_setting[:name]] = [:csv, load_csv(csv_setting[:name]), csv_setting[:options]]
      end
    end
  end

  def production_settings
    ROM.setup(csv_settings)
  end

  def dev_settings
    ROM.setup(csv_settings)
  end

  def load_files
    %w(models params validators commands mappers relations).each do |dir|
      paths = File.join(db_dir, dir, '**', '*.rb')
      Dir[paths].each{|file| require file}
    end
  end

  def load_csv(name)
    File.expand_path("./csv/#{name}.csv", File.dirname(__FILE__))
  end

  def db_dir
    File.dirname __FILE__
  end

  def env
    ENV.fetch('RACK_ENV', 'development')
  end
end

DB = DBClass.new
