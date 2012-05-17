# -*- encoding: utf-8 -*-

# bundler/setup limits the available gems to those defined in Gemfile.
# Users might have different json and web server gems, so bundler gem
# management is disabled for now.
# require 'bundler/setup'

require 'kaiju/util/ruby_extensions'
require 'kaiju/util/attr_chain'
require 'kaiju/util/exception_catcher'
require 'kaiju/util/test'
require 'kaiju/util/service_registry'

require 'kaiju/shell/shell'
require 'kaiju/web/app'
require 'kaiju/web/rack'
