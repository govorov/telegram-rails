module Telegram
  module Rails
    module RoutesHelper

      def telegram route, options
        ActiveSupport::Notifications.instrument "telegram.register_route", route: route, options: options
      end

    end #RoutesHelper
  end #Rails
end #Telegram
