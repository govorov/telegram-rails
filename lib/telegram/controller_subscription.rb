module Telegram
  class ControllerSubscription

    def initialize controllerClass, client
      #TODO implement like rails controller dispatch
      @controllerClass, @client = controllerClass, client
    end


    def message_received payload
      #HERE basic class, AASM/как хранить контекст?
      #методы respond .....
      controller = @controllerClass.new(@client)
      controller.message = payload
      controller.process
    end

  end # ControllerSubscription
end # Telegram
