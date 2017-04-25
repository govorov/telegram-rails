require 'telegram/utils/responder'
require 'telegram/utils/keyboard_builder'


module Telegram
  class Controller

    def bots= adapters
      @bots = adapters
    end


    def bot_name= name
      @bot_name = name
    end


    def message= payload
      @message = payload
    end


    def explicit_response?
      @explicit_response
    end


    private

    def bot
      @bots[@bot_name]
    end


    def bots
      @bots
    end


    def request
      @message
    end


    def send_message *args
      bot.api.send_message *args
      @explicit_response = true
    end


    def default_response
      { chat_id: @message.chat.id }
    end


    def respond_with payload
      response = payload.clone
      # WIP угадывать тип, посмотреть какие есть типы ответа
      unless response.is_a? Hash
        response = {text: response.to_s}
      end

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
