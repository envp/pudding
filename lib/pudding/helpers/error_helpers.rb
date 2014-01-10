# -*- encoding : utf-8 -*-

class StandardError
    DEC_ERR_BACKTRACE = "\n\t"

    def error_log(error, options={})
      case options[:mode]
      when 'console'
        puts "#{error.message}: #{error.class} found at:#{DEC_ERR_BACKTRACE}#{error.backtrace.join(DEC_ERR_BACKTRACE)}"
      end
    end
end
