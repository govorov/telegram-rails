require 'telegram/errors/common_error'

module Telegram
  module Errors
    module Renderer
      class BadTemplateFormatError < Telegram::Errors::CommonError
        def initialize view_name
          super "Unable to find template for #{view_name}"
        end
      end
    end
  end
end
