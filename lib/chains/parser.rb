# Parse a Chains file to a Chains DOM


require "#{$lib}/chains/document"
require "#{$lib}/chains/rules/standard_rules"
require "#{$lib}/chains/rules/inline_comment_rule"

require "#{$lib}/chains/comment"
require "#{$lib}/chains/verbatim"

module Chains
  class Parser
    attr_reader :document
    
    def initialize(input = nil)
      @document = Chains::Document.new
      
      @inlineCommentRule = Chains::InlineCommentRule.new
      @rules = Chains::StandardRules.new
      
      @commentOpeningSymbols = ['(*', '(^', '(!', '/*', '/^']
      @commentClosingSymbols   = ['*)', '^)', '!)', '*/', '^/']
      
       
      @rolloverOpeningSymbols = [
        '(', '{', '['
      ]
      # Ending symbol needs to be in the same array position as
      # the starting symbol.
      @rolloverClosingSymbols = [
        ')', '}', ']'
      ]
      @rolloverOnceSymbols = [
        ',', '=', '+', '-', '*', '/', '%', '^', '&', '|', '<', '>', '\\'
      ]
      
      # More rollover:
      # ':', '?' # TODO: These two must not have alphanumeric before them.
      # Quotes without a closing set?
      
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
      
      inBlockComment = false
      rolloverSymbolStack = Array.new
      lineStack = Array.new
      
      
      input.each_line do |line|
        lineNum += 1
        
        # Skip empty lines.
        next if line.strip.empty? && !inBlockComment
        
        # Check for line rollover.
        # if @rolloverOnceSymbols.include? line.strip[-1]
          # lineStack << [lineNum, line]
          # next # Skip to next line.
        # end
        
        # @rolloverOnceSymbols.each do |symbol|
          # if symbol == line.strip[-1]
            # rolloverSymbolStack << symbol
            # break
          # end
        # end
        
        
        
        #unless inBlockComment || lineRollover
          # Update indent level.
          lastIndent = indent
          indent = indent_count line
          
          # When indentation moves right, push a parent.
          # When indentation moves left, pop a parent.
          
          # Pop the element from the last loop.
          parent.pop if indent <= lastIndent && !parent.last.is_a?(Chains::Document)
          # Pop the parent that's now out of scope from deindenting.
          parent.pop if indent < lastIndent && !parent.last.is_a?(Chains::Document)
        #end
        
        
        # Check for multiline comment.
        # Ends with '*/' or '*)'. Possibly on another line.
        # inBlockComment = true if line.strip.start_with? *@commentStartingSymbols
#         
        # lineBuf += line.delete("\r").delete("\n") + "\n"
#         
        # if inBlockComment
          # # Look for closing tag.
          # inBlockComment = false if line.strip.end_with? *@commentEndingSymbols
#           
          # unless inBlockComment
            # e = Chains::Comment.new(parent.last, lineBuf)
            # e.parent = parent.last
            # parent.last << e
            # lineBuf = ''
          # end 
#           
          # next # Skip to next line.
        # end
        
        
        
         
        
        # Check if the line ends with a comment.
        # inlineResult = @inlineCommentRule.parse(line)
#         
        # if inlineResult.is_a? Chains::Comment
          # inlineResult.parent = parent.last
          # @document << inlineResult
          # next
        # elsif inlineResult.is_a? Chains::Verbatim
          # line = inlineResult.text
        # end
        
        # Run line through rules.
        matchedRule = false
        @rules.each do |rule|
          result = rule.parse(line)
          next unless result
          
          matchedRule = true
          stack << result
          break
        end
        
        unless matchedRule
          # TODO: Raise exception.
          #binding.pry
          puts "SYNTAX ERROR line #{lineNum}:\n#{line}"
          @document = nil
          return
        end
        
        
        # Grab the parsed element to work with.
        e = stack.pop
        e.parent = parent.last
        parent.last << e  # Make the element a child of the last parent.
        parent << e       # Push this element onto the parent stack.
        
        #e.comment = inlineResult.comment if inlineResult.is_a? Chains::Verbatim
        
      end
      
      @document
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