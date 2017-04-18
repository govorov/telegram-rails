require 'telegram/utils/responder'
require 'telegram/utils/keyboard_builder'


module Telegram
  class Controller

    def initialize client
      @client = client
      @responder = Telegram::Utils::Responder.new
    end


    def message= payload
      @message = payload
    end


    private

    def message
      @message
    end


    def send_message *args
      bot.api.send_message *args
    end


    def bot
      @client
    end


    def default_response
      { chat_id: @message.chat.id }
    end


    def respond_to
      @responder.current_message = message
      yield @responder
      @responder.clear_current_message
      response = respond_with @responder.block.call
      send_message response
    end


    def respond_with payload
      #HERE !Hash => to_s
      response = payload.clone
      # :keyboard        => :reply_markup, call :keyboard
      # :inline_keyboard => :reply_markup, call :inline_keyboard
      if response.has_key? :keyboard
        response[:reply_markup] = keyboard(response[:keyboard])
        response.delete :keyboard
      end

      if response.has_key? :inline_keyboard
        response[:reply_markup] = inline_keyboard(response[:inline_keyboard])
        response.delete :inline_keyboard
      end

      if response.has_key?(:remove_keyboard) && response[:remove_keyboard]
        response[:reply_markup] = remove_keyboard
        response.delete :remove_keyboard
      end

      send_message default_response.merge(response)
    end


    keyboard_builder = Telegram::Utils::KeyboardBuilder

    define_method :keyboard do |buttons|
      keyboard_builder.keyboard buttons
    end


    define_method :inline_keyboard do |buttons|
      keyboard_builder.inline_keyboard buttons
    end


    define_method :remove_keyboard do
      res = keyboard_builder.remove_keyboard
    end


  end # Controller
end # Telegram
