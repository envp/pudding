module Configuration

  class AppConfig
    # Configuration constants
    CLIENT_CONFIG_FILE = 'pudding_client_config.xml'
    SERVER_CONFIG_FILE = 'pudding_server_config.xml'

    # Client configuration object
    class ClientConf
      attr_reader :username, :password

      def initialize(username, password)
        @username = username
        @password = password
      end

    end

    # Server configuration object
    class ServerConf
      attr_reader :protocol, :subdomain, :domain, :index_page

      def initialize(protocol = 'http', subdomain, domain, index_page)
        @protocol   = protocol
        @subdomain  = subdomain
        @domain     = domain
        @index_page = index_page
      end

    end
  end

end
