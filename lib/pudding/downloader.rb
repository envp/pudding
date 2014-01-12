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
          @links = links
        end
      end

      # Click-save link that is attached to
      # the calling instance of the Downloader Object
      def download
        # Iterate over the links and save the sever
        # response to clicking each link
        @links.each do |link|
          fileResponse = link.click
          filename = link.href.gsub(RGXP_DOWNLOAD_LINK, '')
          puts "Downloading #{filename}..."
          File.open(filename, 'wb') { |f| f << fileResponse.body }
        end
      end

  end
end
