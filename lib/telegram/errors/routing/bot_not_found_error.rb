require 'telegram/errors/common_error'

module Telegram
  module Errors
    module Routing
      class BotNotFoundError < Telegram::Errors::CommonError
        def initialize name
          super "Bot \"#{name}\" was not found"
        end
      end
    end
  end
end
