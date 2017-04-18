require 'telegram/errors/common_error'

module Telegram
  module Errors
    module Configuration
      class TokenMissingError < Telegram::Errors::CommonError
        def initialize name
          super "No token were provided for bot \"#{name}\""
        end
      end
    end
  end
end
