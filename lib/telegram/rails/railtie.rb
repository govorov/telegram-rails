require 'active_support/notifications'

require 'telegram/errors/configuration/token_missing_error'
require 'telegram/errors/routing/bot_not_found_error'
require 'telegram/client_container_factory'
require 'telegram/rails/routes_helper'
require 'telegram/controller'


module Telegram
  module Rails
    class Railtie < ::Rails::Railtie

      # add config section
      config.telegram = ActiveSupport::OrderedOptions.new

      config.before_initialize do
        ::ActionDispatch::Routing::Mapper.send(:include, Telegram::Rails::RoutesHelper)
      end

      initializer "telegram_rails.run_client" do |app|
        #retrieve options
        @options ||= app.config.telegram
        #clients pool for bots
        @clients = {}

        get_option(:bots).each do |pair; name,options|
          name, options = pair
          client = Telegram::ClientContainerFactory.create name, options
          client.start_client
          @clients[name] = client
        end


        ActiveSupport::Notifications.subscribe "telegram.register_route" do |name, started, finished, id, data|
          controllerClass = data[:controllerClass]
          name = data[:name]

          clientWrapper = @clients[name] or raise Telegram::Errors::BotNotFound, name
          clientWrapper.register_controller controllerClass
        end
      end # initializer


      private

      def get_option *args
        (@options || {}).dig *args
      end

    end # Railtie
  end # Rails
end # Telegram
