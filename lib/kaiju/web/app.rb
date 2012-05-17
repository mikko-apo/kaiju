# -*- encoding: utf-8 -*-

require 'sinatra/base'

class MyApp < Sinatra::Base
  set :sessions, true
  set :foo, 'bar'

  get '/' do
    erb :index
  end
end

class MyApp2 < Sinatra::Base
  set :sessions, true
  set :foo, 'bar'

  get '/' do
    "MyApp2"
  end
end

class KaijuWebServer
  attr_chain :summary, -> {"Commands for handling Kaiju web server: start, stop"}
  attr_chain :shell_command, :require
  attr_chain :help, -> { <<EOF
Kaiju has a built in web server. It can be controlled with following commands
  #{shell_command} start - starts Kaiju web server
  #{shell_command} stop - stops Kaiju web server
EOF
}

  def start_server
    RackServer.new.run! do
      map "/" do
        run MyApp
      end

      map "/admin" do
        run MyApp2
      end
    end
  end

  # Finds matching command and displays its help
  def execute(args)
    if args.size == 1
      case args.first
        when "start"
          start_server
      end
    end
  end
end

KaijuShellCommand.register_cmd("web", KaijuWebServer)
