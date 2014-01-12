# Check for first time usage
# And create a config.xml to
# Store credentials
# First time usage: There is no config.xml
# @TODO Need to replace that definition soon

require 'ox'

require_relative 'config.rb'

module Configuration
  class Initializer
    # This class is instantiated every time the application is booted
    # To check for existing config files
    # ox should speed up the process but, this is might cause lag
    attr_reader :client_data, :server_data

    def initialize
      puts "Initializing..."
      # Check for existance of config files on creation of every instance
      # Takes no arguments, returns the configuration objects
      # And either loads or, dumps a default on every time it is called
      if config_exists?
        # Load configuration data
        client_xml = file_to_string(AppConfig::CLIENT_CONFIG_FILE)
        server_xml = file_to_string(AppConfig::SERVER_CONFIG_FILE)

        # Parse config data to relevant instance objects
        @client_data = Ox.parse_obj(client_xml)
        @server_data = Ox.parse_obj(server_xml)
      else
        # Alert messages!
        # Set config data and dump said data in appropriate config file
        @client_data = AppConfig::ClientConf.new('', '')
        @server_data = AppConfig::ServerConf.new('pu', 'bits-pilani.ac.in', 'index.php')

        # Write client xml
        dump_ox_to_file(@client_data, AppConfig::CLIENT_CONFIG_FILE)

        # Write server xml
        dump_ox_to_file(@server_data, AppConfig::SERVER_CONFIG_FILE)
      end
    end

    private

    def config_exists?
      File.exist?(AppConfig::CLIENT_CONFIG_FILE) && File.exist?(AppConfig::SERVER_CONFIG_FILE)
    end

    def dump_ox_to_file(document, filename)
      File.open(filename, 'w+') { |f| f << Ox.dump(document) }
    end

    def file_to_string(filename)
      file = File.open(filename)
      data = ''
      file.each { |line| data << line }
      return data
    end
  end
end
