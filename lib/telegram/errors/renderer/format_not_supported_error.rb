require 'telegram/errors/common_error'

module Telegram
  module Errors
    module Renderer
      class FormatNotSupportedError < Telegram::Errors::CommonError
        def initialize(template_format)
          super "Format not supported: #{template_format}"
        end
      end
    end
  end
end
