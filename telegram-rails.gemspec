# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'telegram/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "telegram-rails"
  spec.version       = Telegram::Rails::VERSION
  spec.authors       = ["Stanislav E. Govorov"]
  spec.email         = ["govorov.st@gmail.com"]

  spec.summary       = %q{ Rails integration for telegram-bot-ruby }
  # TODO
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "telegram-bot-ruby"
  spec.add_runtime_dependency "wisper"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "byebug"
end
