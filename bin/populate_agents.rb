#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../environment.rb'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: populate_agents.rb [options]"

  opts.on("-t", "--truncate", "Truncate data") do |a|
    options[:truncate] = true
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

if options[:truncate]
  puts "Truncating data"
  Occurrence.connection.execute("TRUNCATE TABLE agents")
  Occurrence.connection.execute("TRUNCATE TABLE occurrence_determiners")
  Occurrence.connection.execute("TRUNCATE TABLE occurrence_recorders")
  Occurrence.connection.execute("TRUNCATE TABLE agent_barcodes")
  Occurrence.connection.execute("TRUNCATE TABLE agent_descriptions")
  Occurrence.connection.execute("TRUNCATE TABLE agent_works")
  Occurrence.connection.execute("TRUNCATE TABLE agent_datasets")
  Occurrence.connection.execute("TRUNCATE TABLE taxon_determiners")
end

puts 'Starting to populate agents'
Occurrence.populate_agents
Description.populate_agents
puts 'Done populating agents'