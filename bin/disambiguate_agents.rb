#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../environment.rb'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: disambiguate_agents.rb [options]"

  opts.on("-r", "--reset", "Reset") do |a|
    options[:reset] = true
  end

  opts.on("-w", "--write-graphics", "Write graphics files") do
    options[:write] = true
  end

  opts.on("-r", "--reassign", "Reassign data") do
    options[:reassign] = true
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

end.parse!

graphs = Collector::AgentDisambiguator.new

if options[:reset]
  graphs.reset
end

if options[:write]
  graphs.write_graphics = true
end

puts 'Starting to disambiguate agents'
graphs.disambiguate

if options[:reassign]
  puts 'Starting to reassign data'
  graphs.reassign_data
end

puts 'Done disambiguating agents'