require 'active_support/inflector'


module Telegram
  module Rails
    class ActionDispatcher

      ROUTE_DELIMETER        = "/"
      ENDPOINT_DELIMETER     = "#"
      COMMAND_START_SYMBOL   = "/"
      COMMAND_ARGS_SEPARATOR = /\s+/
      DEFAULT_ACTION_NAME    = :process


      def initialize adapters
        @adapters = adapters
        @routes   = []
      end


      def register_route route_data
        route = parse_route(route_data)
        @routes << route
      end


      def dispatch_message bot_name, message
        adapter = find_adapter_for bot_name
        return unless adapter

        command, args = extract_command_from message
        route = find_route_for bot_name, command
        return unless route

        process_message message, with: route
      end


      private

      def find_adapter_for name
        @adapters[name]
      end


      def find_route_for bot_name, command
        @routes.find do |route|
          route_match? bot_name, command, route
        end
      end


      def route_match? bot_name, command, route
        bot_name == route[:bot_name] &&
        (command == route[:command] || route[:command].nil?)
      end


      def process_message message, opts
        route = opts[:with]
        controller = route[:controller_class].new
        controller.tap do |c|
          c.bots     = @adapters
          c.bot_name = route[:bot_name]
          c.message  = message
        end

        begin
          # WIP check explicit response...
          controller.send route[:action_name]
        rescue StandardError => e
          puts "RESCUE FROM"
          puts "RESCUE FROM"
          puts "RESCUE FROM"
          puts "RESCUE FROM"
          #HERE rescue_from!!!
          raise e
        end
      end


      #TODO test coverage
      def parse_route route_data
        route_string = route_data[:route]
        options      = route_data[:options]

        segments = route_string.split ROUTE_DELIMETER, 2
        bot_name, command = segments

        bot_name = bot_name.to_sym if bot_name
        command  = command.to_sym if command

        endpoint = options[:to]
        controller_name, action_name = endpoint.to_s.split ENDPOINT_DELIMETER, 2

        controller_class = "#{controller_name}_controller".classify.constantize
        action_name      = action_name ? action_name.to_sym : DEFAULT_ACTION_NAME

        {
          bot_name:         bot_name,
          command:          command,
          controller_class: controller_class,
          action_name:      action_name,
        }
      end


      # get command name from payload
      def extract_command_from payload
        command_str = payload.text
        if command_str && command_str.starts_with?(COMMAND_START_SYMBOL)
          command_str.slice!(0)
          command,*args = command_str.split COMMAND_ARGS_SEPARATOR
          return [command.to_sym, args] if command && command.length
        end
        return [nil,nil]
      end

    end # ActionDispatcher
  end # Rails
end # Telegram
