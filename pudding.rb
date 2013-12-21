require 'mechanize'
require 'nokogiri'
require 'net/http'
require 'diffy'


agent = Mechanize.new
# Add constant for PU link
login_page = agent.get("http://pu.bits-pilani.ac.in/index.php")

# Add constant for Form ID
login_form = login_page.form('formElem')

# Add constants for username and password
login_form.username = 'f2010172'
login_form.password = 'p7grCRVz'

response_page = agent.submit(login_form, login_form.buttons.first)

# Add constants for Form ID
response_form = response_page.form('formElem')
response_form.cgpa = '6.70'
response_form.mobile = '9649965806'
student_home = agent.submit(response_form, response_form.buttons.first)

# Hack alert! find a better way to match notification count
# Notices tab title form "Noties\d new" we need the \d
unread_notifications = student_home.links[5].text.match(/[0-9]+/).to_s

# Add logic for desktop notifications
if unread_notifications == "0"
  puts "No new notifications"
else
  puts "You have #{unread_notifications} unread notifications"
end
