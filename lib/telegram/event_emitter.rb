require 'wisper'

module Telegram
  class EventEmitter

    include Wisper::Publisher

    def emit *args
      broadcast *args
    end

  end # EventEmitter
end #Telegram
