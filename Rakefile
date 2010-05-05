require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "podium"
    gem.summary = %Q{Haml and JS based presentation system.}
    gem.description = %Q{Haml and JS based presentation system.}
    gem.email = "tsaleh@gmail.com"
    gem.homepage = "http://github.com/tsaleh/podium"
    gem.authors = ["tsaleh"]
    gem.add_dependency 'haml',                  '~> 2.2.0'
    gem.add_dependency 'sinatra',               '>= 0.9.0'
    gem.add_dependency 'sinatra-static-assets', '>= 0.5.0'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :test => :check_dependencies

task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must gem install yard"
  end
end
