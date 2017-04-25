require 'bunny'
require 'active_support/notifications'

require 'telegram/rails/routes_helper'
require 'telegram/client_adapter'

require 'telegram/errors/configuration/token_missing_error'
require 'telegram/errors/routing/bot_not_found_error'
require 'telegram/controller'
require 'telegram/bot'


module Telegram
  module Rails
    class Railtie < ::Rails::Railtie

      # add config section
      config.telegram = ActiveSupport::OrderedOptions.new
      notifications   = ActiveSupport::Notifications

      #add route helper
      config.before_initialize do
        ::ActionDispatch::Routing::Mapper.send(:include, Telegram::Rails::RoutesHelper)
      end

      initializer "telegram_rails.run_client_adapters" do |app|

        @options ||= default_options.merge(app.config.telegram)
        @adapters = {}
        dispatcher = Telegram::Rails::ActionDispatcher.new @adapters

        @connection = Bunny.new(get_option :bunny).start
        at_exit { @connection.close }

        #create adapter for each bot
        get_option(:bots).each do |pair; name,options|
          name, options = pair

          adapter = Telegram::ClientAdapter.new.configure do |c|
            c.bot_name        = name
            c.options         = options
            c.connection      = @connection
            c.queue_namespace = get_option(:queue_namespace)
          end

          adapter.on_message_received do |message|
            #TODO logging
            dispatcher.dispatch_message name, message
          end

          @adapters[name] = adapter
          adapter.start
        end

        notifications.subscribe "telegram.register_route" do |name, started, finished, id, data|
          dispatcher.register_route data
        end

      end # initializer


      private

      def get_option *args
        (@options || {}).dig *args
      end


      def default_options
        Hash.new
      end

    end # Railtie
  end # Rails
end # Telegram
