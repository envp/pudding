# Downloader module to download an Mechanize#Link
# Accepts an Array as parameter
# -*- encoding : utf-8 -*-

require 'mechanize'

require_relative 'helpers/array_helpers.rb'

module Downloader
  class PuddingAgent < Mechanize::HTTP::Agent

    RGXP_DOWNLOAD_LINK = /notices\/\d+\//
    DEC_ERR_BACKTRACE = "\n\t"

    def initialize(links)
      # Initialize with an array of Mechanize::Page::Link
      begin
        unless links.is_a_homogenous_array?(Mechanize::Page::Link)
          raise ArgumentError, "PuddingAgent must be initialized with an Array of Mechanize::Page::Link!"
        end
      rescue ArgumentError => error
        # Logfiles anyone?
        puts "#{error.message}: #{error.class} found at:#{DEC_ERR_BACKTRACE}#{error.backtrace.join(DEC_ERR_BACKTRACE)}"
      else
        @links = links
      end
    end

    # Click-save link that is attached to
    # the calling instance of the Downloader Object
    def download
      @links.each do |link|
        fileResponse = link.click
        filename = link.href.gsub(RGXP_DOWNLOAD_LINK, '')
        begin
          f = File.open(filename, 'wb')
        # When the user has insufficient write permissions
        rescue IOError => e
          puts "#{error.message}: #{error.class} found at:#{DEC_ERR_BACKTRACE}#{error.backtrace.join(DEC_ERR_BACKTRACE)}"
          File.close(filename)
        else
          f.write(fileResponse.body)
        end
      end
    end

  end

end
