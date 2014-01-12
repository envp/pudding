require_relative 'app/base.rb'

# Runtime connfiguration is CONSTANT
module PuddingApp

  # Runtime Constants
  # Constant Object containing all configuration data
  CONFIG = Configuration::Initializer.new

  # Constant for PU's local address
  PU_ADDRESS = CONFIG.server_data.protocol << '://' << CONFIG.server_data.subdomain << '/' << CONFIG.server_data.index_page

  # Call this method to run the application
  # Still a bit spaghetti-ish
  def self.run
    # Minimal runtime failure checks
    PuddingApp.test_configs_or_fail

    # We are good to go!
    Greeting::init(:new => false, :username => CONFIG.client_data.username)

    # brobot instance of Browser::Brobot
    # Calling Brobot#start is enough to do everything
    brobot = Browser::Brobot.new('Mechanize')
    brobot.start(PU_ADDRESS, CONFIG)

    # Exit with a greeting
    Greeting.goodbye
  end

  # Predicate to check if the user
  # Did not fill up his / her config files
  def self.lazy_user?
    CONFIG.client_data.username == '' || CONFIG.client_data.username == ''
  end

  # Predicate to check if server config files are ok
  def self.server_config_ok?
    CONFIG.server_data.subdomain == 'pu' || CONFIG.server_data.domain == 'bits-pilani.ac.in' || CONFIG.server_data.index_page == 'index.php'
  end

  # Test if we are good to go
  def self.test_configs_or_fail
    unless PuddingApp.server_config_ok?
      fail StandardError, "Please do not tamper with the server config files! To reset them, delete them and re-run this application"
    end

    # Check for end-user laziness
    if PuddingApp.lazy_user?
      Greeting.init(:new => true)
      fail StandardError, "Username and/or password uninitialized! Please fill up the config files"
    end
  end

end
