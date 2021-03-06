#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../environment.rb'
require 'optparse'

ARGV << '-h' if ARGV.empty?

options = {}
options[:type] = "d3"

OptionParser.new do |opts|
  opts.banner = "Usage:populate_search.rb [options]"

  opts.on("-f", "--flush", "Flush the index") do |f|
    options[:flush] = true
  end

  opts.on("-e", "--rebuild-all", "Rebuild the entire index") do |a|
    options[:rebuild_all] = true
  end

  opts.on("-i", "--rebuild-agents", "Rebuild the agent index") do |a|
    options[:rebuild_agents] = true
  end

  opts.on("-o", "--rebuild-occurrences", "Rebuild the occurrences index") do |a|
    options[:rebuild_occurrences] = true
  end

  opts.on("-t", "--rebuild-taxa", "Rebuild the taxa index") do |a|
    options[:rebuild_taxa] = true
  end

  opts.on("-r", "--refresh", "Refresh the index") do |a|
    options[:refresh] = true
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

end.parse!

index = Collector::ElasticIndexer.new

if options[:flush]
  index.delete
end

if options[:refresh]
  index.refresh
end

if options[:rebuild_all]
  index.delete
  index.create
  index.import_taxa
  index.import_occurrences
  index.import_agents
  index.refresh
elsif options[:rebuild_agents]
  index.delete_agents
  index.import_agents
  index.refresh
elsif options [:rebuild_occurrences]
  index.delete_occurrences
  index.import_occurrences
  index.refresh
elsif options[:rebuild_taxa]
  index.delete_taxa
  index.import_taxa
  index.refresh
end