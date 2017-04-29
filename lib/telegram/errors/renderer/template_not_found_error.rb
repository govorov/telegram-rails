require 'telegram/errors/common_error'

module Telegram
  module Errors
    module Renderer
      class TemplateNotFoundError < Telegram::Errors::CommonError
        def initialize view_name
          super "Template not found for #{view_name}"
        end
      end
    end
  end
end
