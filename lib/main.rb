require 'rubygems'
require 'mechanize'
require 'ox'

require_relative 'pudding/config.rb'
require_relative 'pudding/downloader.rb'

agent = Mechanize.new
agent.user_agent_alias = 'Mechanize'
# Add constant for PU link
login_page = agent.get("http://pu/index.php")

# Add constant for Form ID
login_form = login_page.form('formElem')

# Add constants for username and password
login_form.username = AppConfig::USER[:email]
login_form.password = AppConfig::USER[:password]

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

  notice_agent = Downloader::PuddingAgent.new(unread_links)
  notice_agent.download
end



#.bits-pilani.ac.in/

# Cool, this works
#response2 = x.click
#File.open(x.href., 'wb'){|f| f << response2.body}
