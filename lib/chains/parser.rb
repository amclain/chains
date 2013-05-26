# Parse a Chains file to a Chains DOM


require "#{$lib}/chains/document"
require "#{$lib}/chains/rules/standard_rules"
require "#{$lib}/chains/rules/inline_comment_rule"

require "#{$lib}/chains/verbatim"

module Chains
  class Parser
    attr_reader :document
    
    def initialize(input = nil)
      @document = Chains::Document.new
      
      @inlineCommentRule = Chains::InlineCommentRule.new
      @rules = Chains::StandardRules.new
      
      parse input if input
    end
    
    def parse(input)
      @document = Chains::Document.new
      
      # Input =
      #   Input string, file path, file object.
      
      # TODO: For now we don't care. Assume input string for testing.
      
      parent = Array.new   # Push and pop this to track nesting.
      parent << @document
      
      stack = Array.new   # Push and pop elements being created.
      
      lineNum = 0
      indent = 0
      lastIndent = 0
      lineBuf = ''
      
      input.each_line do |line|
        lineNum += 1
        
        # Update indent level.
        lastIndent = indent
        indent = indent_count line
        
        # Check if the line ends with a comment.
        inlineResult = @inlineCommentRule.parse(line)
        
        if inlineResult.is_a? Chains::Comment
          @document << inlineResult
          next
        elsif inlineResult.is_a? Chains::Verbatim
          line = inlineResult.text
        end
        
        # Check for line rollover. (Ends with '(' or ',').
        
        
        
        # Run line through rules.
        result = nil
        @rules.each do |rule|
          result = rule.parse(line)
          next unless result
          
          @document << result
        end
        
        unless result
          # TODO: Raise exception.
          puts "SYNTAX ERROR line #{lineNum}:\n#{line}"
          @document = nil
          return
        end
        
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