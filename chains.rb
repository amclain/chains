$root = File.dirname(__FILE__)
$lib = "#{$root}/lib"

require 'pry'

require "#{$lib}/netlinx/document"

require "#{$lib}/netlinx/assignment"
require "#{$lib}/netlinx/block"
require "#{$lib}/netlinx/conditional"
require "#{$lib}/netlinx/device"
require "#{$lib}/netlinx/event"
require "#{$lib}/netlinx/event_handler"
require "#{$lib}/netlinx/function"
require "#{$lib}/netlinx/statement"


path = "#{$root}/test/input.axs.chains"
unless File.exists? path
  puts "Couldn't find input file: #{path}"
  exit
end

f = File.open("#{$root}/test/input.axs.chains", 'r')
unless f
  puts "Failed to open file: #{path}"
  exit
end

programName = 'Test Program'

header = <<EOS
(***********************************************************
    #{programName}
    
    This file was automatically generated.
    The original code was written in CHAINS.
    
    http://sourceforge.net/projects/chains
************************************************************)
EOS

doc = NetLinx::Document.new(programName, header)


# Tracks when sections of the document have been entered and exited.
# Needed for resetting parser data.
section = nil

# Level of indentation.
indent = 0
lastIndent = 0

# Line buffer for collecting expressions that roll over to another line.
lineBuf = ''

# For creating statements.
statementBuf = ''

# Array for tracking parents.
parent = Array.new

f.read.each_line do |line|
  next if line.empty?
  
  # Track indentation.
  lastIndent = indent
  indentArray = line.scan(/([\t ]*).*/).first
  indent = indentArray.first.length if indentArray
  
  # Assignment
  # (\w+)\s*=\s*(\S+)*
  
  # Device definition.
  # This is a type of assignment.
  # (dvTP = 10001:1:0)
  line.strip.scan(/(\w+)\s*=\s*(\d{1,5}):?(\d{0,5}):?(\d{0,5})/).
    collect do |symbol, device, port, system|
      break if port.empty? || system.empty?
      
      section = :deviceDefinition
      device = NetLinx::Device.new(symbol, device, port, system)
      doc[:devices] << device
      parent[indent] = device
      
      doc[:start] << NetLinx::Statement.new("combine_devices(#{parent[0].symbol}, #{symbol})") if parent.count > 1
    end
    
  
end

puts doc
