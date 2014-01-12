require 'rubygems'

require_relative 'pudding/base.rb'

# Runtime connfiguration is CONSTANT
CONFIG = Configuration::Initializer.new


# Runtime failure checks
# Check for server config corruption
unless CONFIG.server_data.subdomain == 'pu' || CONFIG.server_data.domain == 'bits-pilani.ac.in' || CONFIG.server_data.index_page == 'index.php'
  fail StandardError, "Please do not tamper with the server config files! To reset them, delete them and re-run this application"
end

# Check for end-user laziness
if CONFIG.client_data.username == '' || CONFIG.client_data.username == ''
  Greeting.init(:new => true)
  fail StandardError, "Username and/or password uninitialized! Please fill up the config files"
end

Greeting::init(:new => false, :username => CONFIG.client_data.username)

PU_ADDRESS = CONFIG.server_data.protocol << '://' << CONFIG.server_data.subdomain << '/' << CONFIG.server_data.index_page

brobot = Browser::Brobot.new('Mechanize')
brobot.start(PU_ADDRESS, CONFIG)

Greeting.goodbye
