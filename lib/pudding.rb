require 'rubygems'

require_relative 'pudding/config.rb'
require_relative 'pudding/initializer.rb'
require_relative 'pudding/browser.rb'
require_relative 'pudding/downloader.rb'
require_relative 'pudding/helpers/greeting_helpers'

agent = Mechanize.new
agent.user_agent_alias = 'Mechanize'

# Runtime connfiguration is CONSTANT
CONFIG = Configuration::Initializer.new

# Check for server config corruption
unless CONFIG.server_data.subdomain == 'pu' || CONFIG.server_data.domain == 'bits-pilani.ac.in' || CONFIG.server_data.index_page == 'index.php'
  fail StandardError, "Please do not tamper with the server config files! To reset them, delete them and re-run this application"
end


# Check for end-user laziness
if CONFIG.client_data.username == '' || CONFIG.client_data.username == ''
  Greeting::greet_init(:new => true)
  fail StandardError, "Username and/or password uninitialized! Please fill up the config files"
end

Greeting::greet_init(:new => false, :username => CONFIG.client_data.username)
# Add constant for PU link

login_page = agent.get(CONFIG.server_data.protocol << '://' << CONFIG.server_data.subdomain << '/' << CONFIG.server_data.index_page)

# Add constant for Form ID
login_form = login_page.form('formElem')

# Add constants for username and password
login_form.username = CONFIG.client_data.username
login_form.password = CONFIG.client_data.password

response_page = agent.submit(login_form, login_form.buttons.first)

# Add constants for Form ID
student_home = agent.submit(response_page.form('formElem'), response_page.form('formElem').buttons.first)

# Hack alert! find a better way to match notification count
# Potential bug: add a begin...rescue NoMethodError for match returning nil
unread_notifications = student_home.links[5].text.match(/[0-9]+/).to_s.to_i

# Add logic for desktop notifications

if unread_notifications.zero?
  puts "No new notifications\nNothing to download"
else
  puts "You have #{unread_notifications} unread notifications"
  puts "Downloading #{unread_notifications} files:"
  notice_page = student_home.link_with(text: student_home.links[5].text).click
  unread_links = notice_page.links_with(text: "Download")[0...unread_notifications]

  notice_agent = PuddingAgent.new(unread_links)
  notice_agent.download
end
