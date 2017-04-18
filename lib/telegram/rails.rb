require "telegram/rails/version"

module Telegram
  module Rails
  end
end

require "telegram/rails/railtie" if defined?(Rails)
