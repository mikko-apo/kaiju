require 'spec_helper'

describe "Web module test" do
  include Rack::Test::Methods

  def app
    MyApp.new
  end

  it "says hello" do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'fsdf'
  end
end

describe "Web app test" do
  include Rack::Test::Methods

  def app
    KaijuWebServer.new.kaiju_app
  end

  it "says hello" do
    get '/admin'
    last_response.should be_ok
    last_response.body.should == 'MyApp2'
  end
end