#!/usr/bin/env ruby

require 'haml'
require 'sass'

$LOAD_PATH << File.join(File.dirname(__FILE__))
require "podium/haml_filters"
require "podium/helpers"
require "podium/commands"

command = ARGV.shift

case command
when "new":   
  Podium::Commands::New.new(*ARGV)
  Podium::Commands::Build.new(File.join(ARGV.first, "index.haml"))
when "build": 
  Podium::Commands::Build.new(*ARGV)
else
  raise "Unrecognized command: #{command}."
end

