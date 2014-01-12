require 'mechanize'

require_relative 'config.rb'
require_relative 'downloader.rb'
require_relative 'helpers/greeting_helpers.rb'

module Browser
  include Downloader
  include Configuration
  include Greeting

  class Brobot < Mechanize::HTTP::Agent
    attr_reader :agent, :unread_notification_count

    # Browser-bot, also a real bro
    def initialize(agent_alias)
      @agent = Mechanize.new
      @agent.user_agent_alias = agent_alias

    end

    # Sphagetti methods below, do not tamper
    # Serious magic, Unknown forces, Quite scary
    def start(url, conf)
      # Using Absolute value of the constant here
      # Since there is no need to pass the form selector
      # When it is going to be in the global namespace anyway
      login_form = @agent.get(url).form(Configuration::AppConfig::FORM_CSS_SELECTOR)
      login_form = fill(login_form, conf)

      # First response page
      # This page corresponds to
      # confirm Mobile number, CGPA page
      response_page = submit_form(login_form)

      # Needn't tamper with mobile number / student CGPA
      # I'm assuming it is filled by default
      # Response to Mob/CGPA page is PU/Student Home
      @student_home = submit_form(response_page.form(Configuration::AppConfig::FORM_CSS_SELECTOR))

      # Extract unread notifications
      # using regex on appropriate element(s)
      # @TODO Hack alert! find a better way to match notification count
      # @TODO Potential bug: add a begin...rescue NoMethodError for match returning nil
      @unread_notification_count = @student_home.links[5].text.match(/[0-9]+/).to_s.to_i

      # Click to go to the notices page
      # And get pdf links for unread notifications
      if unread_notification_count.zero?
        # Action for no new
        Greeting.dl(:new => false, :username => conf.client_data.username)
      else
        # Action for new notifications found
        # Scan notices page for links and click
        # Extract unread links into an Array
        notice_page = @student_home.link_with(text: @student_home.links[5].text).click
        unread_links = notice_page.links_with(text: "Download")[0...unread_notification_count]

        # Greetz?
        Greeting.dl(:new => true, :username => conf.client_data.username, :file_count => unread_links.count)
        save_pdfs(unread_links)
      end

    end

    private

    def fill(form, conf)
      form.username = conf.client_data.username
      form.password = conf.client_data.password
      form
    end

    def submit_form(form)
      @agent.submit(form, form.buttons.first)
    end

    def save_pdfs(unread_links)
      notice_agent = Downloader::PuddingAgent.new(unread_links)
      notice_agent.download
    end

  end
end
