require 'telegram/errors/common_error'


module Telegram
  module Errors
    module Routing
      class BadRouteError < Telegram::Errors::CommonError
        def initialize route
          super "Bad route \"#{route}\""
        end
      end
    end
  end
end
