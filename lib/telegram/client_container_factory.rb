require 'telegram/client_container'

module Telegram
  module ClientContainerFactory

    def self.create name, options
      raise Telegram::Errors::Configuration::TokenMissingError, name unless options[:token].present?
      Telegram::ClientContainer.new(name,options)
    end

  end
end
