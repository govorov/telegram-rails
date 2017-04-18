require 'active_support/inflector'
require 'telegram/errors/controller/block_not_given_error'
#WIP-- `ag byebug`
require 'byebug'


module Telegram
  module Utils
    class Responder

      class << self
        private
        def register_type type
          instance_eval do
            define_method type do |&block|
              set_respond_to type, &block
            end
          end
        end
      end


      RESPONSE_TYPES = [
        :from,
        :date,
        :chat,
        :forward_from,
        :forward_from_chat,
        :forward_from_message_id,
        :forward_date,
        :reply_to_message,
        :edit_date,
        :text,
        :entities,
        :audio,
        :document,
        :game,
        :photo,
        :sticker,
        :video,
        :voice,
        :caption,
        :contact,
        :location,
        :venue,
        :new_chat_member,
        :left_chat_member,
        :new_chat_title,
        :new_chat_photo,
        :delete_chat_photo,
        :group_chat_created,
        :supergroup_chat_created,
        :channel_chat_created,
        :migrate_to_chat_id,
        :migrate_from_chat_id,
        :pinned_message,
      ]


      RESPONSE_TYPES.each do |type_const|
        register_type type_const.to_s.underscore.to_sym
      end


      def current_message= message
        @message = message
      end


      def current_message
        @message
      end


      def clear_current_message
        @message = nil
      end


      def any &block
        set_respond_to :any, &block
      end


      #TEST
      #match first not nil attribute
      def set_respond_to type, &block
        @stack ||= []
        @stack.push type
        if block && @block.nil?
          # check if message matches stack
          has_attr = @stack.find do |format|
            format == :any || !current_message.send(format).nil?
          end

          if has_attr
            @block = block
          end

          @stack.clear
        end

      end


      def block
        @block or raise Telegram::Errors::Controller::BlockNotGivenError
      end

    end
  end
end
