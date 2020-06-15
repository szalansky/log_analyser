#!/usr/bin/env ruby
require "optparse"

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: analyser.rb [options]"

  opts.on("-fFILE", "--file=FILE", "File to analyse.") do |f|
    options[:file_path] = f.strip
  end
end.parse!

file_path = options.fetch(:file_path) do
  STDERR.puts "Please provide file to analyse."
  exit 1
end

if file_path.empty?
  STDERR.puts "Blank FILE argument in -fFILE/--file=FILE."
  exit 1
end

begin
  file = File.open(file_path, "r")
rescue Errno::ENOENT
  STDERR.puts "Could not read #{file_path} file."
  exit 1
end

require_relative "./lib/file_source"
require_relative "./lib/loader"
require_relative "./lib/repository"

source = FileSource.new(file)
loader = Loader.new(source)
repo = Repository.new

loader.each_entry do |url, ip|
  repo.append(url, ip)
end

STDOUT.puts "Page views:"
repo.each_by_total_visits.each do |visit|
  STDOUT.puts("#{visit.fetch(:url)} #{visit.fetch(:total_visits)} visits")
end
STDOUT.puts ""
STDOUT.puts "Unique page views"
repo.each_by_unique_visits.each do |visit|
  STDOUT.puts("#{visit.fetch(:url)} #{visit.fetch(:unique_visits)} unique visits")
end

file.close
