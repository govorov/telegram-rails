# Telegram::Rails

## Work in progress

Rails integration for [`telegram-rabbit`](https://github.com/govorov/telegram-rabbit).

Gives you http-like routes and controllers. Allows you to write such a code:

```
#routes.rb
Rails.application.routes.draw do

  telegram 'main/start', to: 'telegram/messages#start'
  telegram 'main/stop',  to: 'telegram/messages#stop'
  telegram 'main',       to: 'telegram/messages'

end

#messages_controller.rb
class Telegram::MessagesController < Telegram::Controller

  def start
    respond_with 'received /start'
  end


  def stop
    respond_with 'received /stop'
  end


  def process
    respond_with 'other commands'
  end


  #rails-like implicit/explicit template rendering (only ERB support now)
  def show
    #app/views/telegram/messages/show.(md|html|txt).erb
    #all instance variables are available in templates, like in rails
    @v1 = 'some value'
  end


  def explicit
    #explicit template rendering
    render 'telegram/path/to/template'
  end

end

```

## TODO

* Sessions
* Callbacks
* `rescue_from`
* `respond_to`
* ...and so on from vanilla rails controllers
* Documentation

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

