require 'telegram/errors/common_error'

module Telegram
  module Errors
    module Renderer
      class MultipleTemplatesError < Telegram::Errors::CommonError
        def initialize view_name
          super "Multiple templates for #{view_name}. Please specify :format explicitly"
        end
      end
    end
  end
end
