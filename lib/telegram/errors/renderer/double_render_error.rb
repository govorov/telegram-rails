require 'telegram/errors/common_error'

module Telegram
  module Errors
    module Renderer
      class DoubleRenderError < Telegram::Errors::CommonError
        def initialize
          super "Response is already rendered"
        end
      end
    end
  end
end
