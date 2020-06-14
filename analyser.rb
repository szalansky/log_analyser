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
