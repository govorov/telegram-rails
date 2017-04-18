module Telegram
  module Rails
    module RoutesHelper

      def telegram name, options
        ActiveSupport::Notifications.instrument "telegram.register_route", name: name, controllerClass: options[:to]
      end

    end #RoutesHelper
  end #Rails
end #Telegram
