require 'telegram/rails/action_dispatcher'


module Telegram
  class ClientAdapter

    class ApiProxy
      def initialize adapter
        @adapter = adapter
      end

      def method_missing command, *args
        puts "call adapter with #{command}"
        p args
        @adapter.send_command command, *args
      end
    end


    attr_accessor :connection
    attr_accessor :queue_namespace
    attr_accessor :options
    attr_accessor :bot_name


    def configure
      yield self
      self
    end


    def start
      send_queue_name    = "#{queue_prefix}.commands"
      receive_queue_name = "#{queue_prefix}.messages"

      @channel       = connection.create_channel
      @send_queue    = @channel.queue send_queue_name
      @receive_queue = @channel.queue receive_queue_name

      @receive_queue.subscribe do |info,metadata,raw_data|
        data = Marshal.load(raw_data)
        @receive_callbacks.each do |callback|
          callback.call(data)
        end
      end

      @api_proxy = ApiProxy.new(self)
    end


    def on_message_received &block
      @receive_callbacks ||= []
      @receive_callbacks << block
    end


    def api
      @api_proxy
    end


    def send_message payload
      api.send_message payload
    end


    def send_command command, payload
      raw_data = Marshal.dump(serialize_command(command,payload))
      @channel.default_exchange.publish raw_data, routing_key: @send_queue.name
    end


    private

    def serialize_command command, payload
      {command: command, payload: payload}
    end

    def queue_prefix
      "#{queue_namespace}.#{bot_name}"
    end

  end # ClientAdapter
end # Telegram
