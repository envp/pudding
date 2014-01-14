require_relative '../config.rb'

module Greeting
  # Decorator constants
  CNT = 32
  SEP_HORIZ = '='

  # Greeting to be printed to console
  # On App initialization
  def self.init(options = {})
    puts SEP_HORIZ * CNT
    puts "Pudding!"
    if options[:new]
      puts "=" * CNT
      puts "NO CONFIG FILE DETECTED!"
      puts "CREATING DEFAULT CONFIG FILES..."
      puts "#{Configuration::AppConfig::CLIENT_CONFIG_FILE}"
      puts "#{Configuration::AppConfig::SERVER_CONFIG_FILE}"
      puts "Please fill up the generated config files to use the application!"
      puts SEP_HORIZ * CNT
    else
      puts SEP_HORIZ * CNT
      puts "Welcome back, #{options[:username]}!"
    end
  end

  # Download greeting
  def self.dl(options = {})
    if options[:new]
      # Greeter for new notifications
      puts SEP_HORIZ * CNT
      puts "#{options[:username]}, you have #{options[:file_count]} new notification(s)!"
      puts "Downloading #{options[:file_count]} file(s)..."

    else
      # Greeter for no new notifications
      puts SEP_HORIZ * CNT
      puts "#{options[:username]}, you have no new notifications!"
      puts "Nothing to download!"
    end

  end

  # Press Enter to exit!
  def self.prompt
    print "Press Enter to exit!"
  end
  # End of Application greeting
  def self.goodbye
    puts SEP_HORIZ * CNT
    puts "Exiting..."

  end

end
