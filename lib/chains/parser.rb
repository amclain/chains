# Parse a Chains file to a Chains DOM


require "#{$lib}/chains/document"

module Chains
  class Parser
    attr_reader :document
    
    def initialize(input = nil)
      @document = Chains::Document.new
      parse input if input
    end
    
    def parse(input)
      @document = Chains::Document.new
      
      # Input =
      #   Input string, file path, file object.
      
      # TODO: For now we don't care. Assume input string for testing.
      
      stack = Array.new   # Push and pop this to track nesting.
      lineNum = 0
      indent = 0
      lastIndent = 0
      lineBuf = ''
      
      input.each_line do |line|
        lineNum += 1
        
        # Update indent level.
        lastIndent = indent
        indent = indent_count line
        
        binding.pry
      end
      
    end
    
    private
    def indent_count(line)
      indent = 0
      indentArray = line.scan(/([\t ]*).*/).first
      indent = indentArray.first.length if indentArray
      indent
    end
    
  end
end



=begin
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
=end