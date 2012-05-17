# -*- encoding: utf-8 -*-

=begin
Copyright (c) 2007, 2008, 2009, 2010, 2011 Blake Mizerany

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
                                                        copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
=end

# Code from Sinatra used to start a rack application in to stand alone server
# License applies to the class below
class RackServer

  def run!(app=nil, &block)
    if block && app.nil?
      app = Rack::Builder.new(&block)
    end
    handler = detect_rack_handler
    handler_name = handler.name.gsub(/.*::/, '')
    handler.run app do |server|
      unless handler_name =~ /cgi/i
        $stderr.puts "== Sinatra/#{Sinatra::VERSION} has taken the stage " +
                         "on #{server.port} for #{"development"} with backup from #{handler_name}"
      end
      [:INT, :TERM].each { |sig| trap(sig) { quit!(server, handler_name) } }
    end
  rescue Errno::EADDRINUSE => e
    $stderr.puts "== Someone is already performing on port #{port}!"
  end

  def quit!(server, handler_name)
    server.respond_to?(:stop!) ? server.stop! : server.stop
    $stderr.puts "\n== Sinatra has ended his set (crowd applauds)" unless handler_name =~/cgi/i
  end

  def detect_rack_handler
    servers = Array(%w[thin mongrel webrick])
    servers.each do |server_name|
      begin
        return Rack::Handler.get(server_name.to_s)
      rescue LoadError
      rescue NameError
      end
    end
    fail "Server handler (#{servers.join(',')}) not found."
  end
end