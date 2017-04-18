require 'telegram/bot'
require 'telegram/event_emitter'
require 'telegram/controller_subscription'


module Telegram
  class ClientContainer

    def initialize name, options
      @options = options
      @name    = name
      @client  = Telegram::Bot::Client.new(options[:token])
      @emitter = Telegram::EventEmitter.new
    end


    def start_client
      client  = @client
      emitter = @emitter

      @thread = Thread.new do
        client.run do |bot|
          bot.listen do |message|
            @emitter.emit :message_received, message
          end
        end
      end
      @thread.abort_on_exception = true
      at_exit { Thread.kill @thread }
    end


    def register_controller controllerClass
      @emitter.subscribe(Telegram::ControllerSubscription.new(controllerClass,@client))
    end


  end # ClientContainer
end #Telegram
