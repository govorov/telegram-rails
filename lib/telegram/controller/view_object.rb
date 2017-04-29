module Telegram
  class Controller
    class ViewObject

      def initialize(variables = {})
        assign_instance_variables(variables)
      end


      private

      def assign_instance_variables(hash)
        hash.each do |key,value|
          instance_variable_set "@#{key}", value
        end
      end

    end
  end # Controller
end # Telegram
