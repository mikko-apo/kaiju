require 'rubygems'
require 'rspec'
require 'mocha'
require 'rack/test'

RSpec.configure do |config|
  config.mock_with :mocha
end

require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/spec-slow/"
end
require 'kaiju_all'
#$:.unshift File.join(File.dirname(File.dirname(__FILE__)),"lib")

