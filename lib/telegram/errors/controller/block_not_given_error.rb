require 'telegram/errors/common_error'

module Telegram
  module Errors
    module Controller
      class BlockNotGivenError < Telegram::Errors::CommonError
        def initialize
          super "Block not given"
        end
      end
    end
  end
end
