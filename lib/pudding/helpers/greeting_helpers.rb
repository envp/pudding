module Greeting
  def greet_init(options = {})
    puts "="*16
    puts "Pudding!"
    if options[:new]
      puts "NO CONFIG FILE DETECTED!"
      puts "CREATING DEFAULT CONFIG FILES..."
      puts "#{Configuration::AppConfig::CLIENT_CONFIG_FILE}"
      puts "#{Configuration::AppConfig::SERVER_CONFIG_FILE}"
      puts "Please fill up the generated config files to use the application!"
      puts "="*16
    else
      puts "Welcome back, #{options[:username]}!"
    end
  end
end
