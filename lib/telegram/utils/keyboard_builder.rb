require 'telegram/bot/types'

module Telegram
  module Utils
    module KeyboardBuilder
      class << self

        def keyboard buttons
          btnClass = Telegram::Bot::Types::KeyboardButton
          kbClass  = Telegram::Bot::Types::ReplyKeyboardMarkup
          build :keyboard, buttons, btnClass, kbClass
        end


        def inline_keyboard buttons
          btnClass = Telegram::Bot::Types::InlineKeyboardButton
          kbClass  = Telegram::Bot::Types::InlineKeyboardMarkup
          build :keyboard, buttons, btnClass, kbClass
        end


        def remove_keyboard
          Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
        end


        private
        def build key, buttons, btnClass, kbClass
          keyboard = buttons.map do |button|
            btnClass.new button
          end
          kbClass.new({ key => keyboard })
        end
      end
    end
  end # Utils
end # Telegram
