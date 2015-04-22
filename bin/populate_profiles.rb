#!/usr/bin/env ruby
require 'pp'
require_relative '../environment.rb'

if ARGV[0] == '--flush'
  puts "Truncating data"
  Agent.connection.execute("TRUNCATE TABLE works")
  Agent.connection.execute("TRUNCATE TABLE agent_works")
  Agent.connection.execute("UPDATE agents SET email = NULL, position = NULL, affiliation = NULL, processed_profile = NULL")
end

puts 'Starting to populate profiles'
Agent.populate_profiles
puts 'Done populating profiles'