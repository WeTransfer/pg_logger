module PgLogger
  # Maps PG notice levels to Ruby Logger levels
  POSTGRES_ERROR_MAPPING = {
    'DEBUG' => :debug,
    'LOG' => :info,
    'INFO' => :info, 
    'NOTICE' => :warn,
    'WARNING' => :warn,
    'EXCEPTION' => :error,
  }
  
  DEFAULT_FORMAT = '[pg] %s'.freeze
  
  # Creates a Proc from the given Logger object. The
  # proc will accept PG::Result objects from notices
  # and forward their contents into the given logger
  #
  # @param logger[Logger] the Ruby Logger object or a compatible
  # @param format_str[String] the default format string
  # @return [Proc] the proc that can be passed to the connection adapter
  def self.notice_proc_for_logger(logger, format_str = DEFAULT_FORMAT)
    ->(*pg_results) {
      pg_results.each do |pg_result|
        # message is a PG::Result, we need to extract the errors from it
        # Only use the PG constants _within_ the proc so that the gem can still be loaded
        # before the "pg" gem.
        severity = pg_result.error_field(PG::Result::PG_DIAG_SEVERITY)
      
        message_consts = [
          PG::Result::PG_DIAG_MESSAGE_PRIMARY, 
          PG::Result::PG_DIAG_MESSAGE_DETAIL,
          PG::Result::PG_DIAG_MESSAGE_HINT,
        ]
        
        message = message_consts.map do |err_const|
            pg_result.error_field(err_const)
        end.join(' ')
      
        logger_method_name = POSTGRES_ERROR_MAPPING.fetch(severity)
        logger.public_send(logger_method_name) { format_str % message }
      end
    }
  end
end
