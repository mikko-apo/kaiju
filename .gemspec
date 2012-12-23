# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler/version'

Gem::Specification.new do |s|
  s.name        = "kaiju"
  if defined?(BuildVersion)
    s.version = BuildVersion
  else
    s.version = "0.0.1"
  end
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mikko Apo"]
  s.homepage    = "https://github.com/mikko-apo/kaiju"
  s.summary     = "Simple issue tracking system"
  s.description = "Kaiju aims to provide powerful core features and easy to use user interface for issue tracking"

#  s.rubyforge_project         = "kaiju"

  s.add_development_dependency "rspec"

  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
  s.executables  = ['bundle']
  s.require_path = 'lib'
end