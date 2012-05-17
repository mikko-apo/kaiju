require 'rubygems'
require 'rake'
require 'rubygems/package_task'
require 'rspec/core/rake_task'
require 'yard'

RSpec::Core::RakeTask.new do |t|
  t.pattern = FileList['spec/**/*_spec.rb']
end

YARD::Rake::YardocTask.new
