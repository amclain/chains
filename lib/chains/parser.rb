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
      
       
      
      
      parse input if input
    end
    
    def parse(input)
      @document = Chains::Document.new
      
      # Input =
      #   Input string, file path, file object.
      
      # TODO: For now we don't care. Assume input string for testing.
      
      
      parent = Array.new    # Push and pop this to track nested statement relationships.
      parent << @document

      stack = Array.new     # Push and pop elements being created.
      
      rollover = Array.new  # Push and pop to track nested rollover.
      rollover << ParserRollover.new
      
      lineNum = 0
      indent = 0
      lastIndent = 0
      
      inBlockComment = false
      
      
      input.each_line do |line|
        lineNum += 1
        
        # Skip empty lines.
        next if line.strip.empty? && !inBlockComment
        
        # Check for line rollover.
        
        
        
        
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
      
      case line[0]
      when ' '
        indentArray = line.scan(/([ ]*).*/).first
        indent = indentArray.first.length if indentArray
      when "\t"
        indentArray = line.scan(/([\t]*).*/).first
        indent = indentArray.first.length if indentArray  
      else
        # Line starts with a statement, not whitespace.
      end
      
      indent
    end
    
  end
  
  
  # Rollover object should be discarded or cleared
  # after the 'end_capture?' flag is raised, as it
  # will not accept additional input.
  class ParserRollover
    attr_accessor :starting_line_number
    
    def initialize
      @beginCapture = false # Flag that line begins rollover capture.
      @endCapture = false   # Flag that line ends rollover capture.
      @isCapturing = false  # Flag that rollover is being captured.
      @rolloverOnce = false # Flag to rollover once and test for rollover again on next line.
      
      @openingSymbol = nil
      @closingSymbol = nil
      @starting_line_number = 0
      @lineBuf = Array.new
      
      
      # Rollover starts when the line ends with an opening symbol.
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
    end
    
    def <<(line)
      add_line line
    end
    
    def add_line(line)
      #binding.pry if line == '   123   '
      
      if @rolloverOnce
        # Reset flags.
        @beginCapture = false
        @endCapture = true
        @isCapturing = true
        @rolloverOnce = false
      end
      
      # Rollover object should be discarded or cleared
      # after the 'end_capture?' flag is raised, as it
      # will not accept additional input.
      if @endCapture && !@rolloverOnce
        @lineBuf << line if @isCapturing
        
        @beginCapture = false
        @isCapturing = false
        @rolloverOnce = false
        return
      end
      
      # Check for rollover-once symbols.
      if @rolloverOnceSymbols.include? line.strip[-1]
        @beginCapture = true
        @endCapture = false
        @isCapturing = true
        @rolloverOnce = true
        
        @lineBuf << line.strip
        return
      end
      
      # Check for begin rollover symbols.
      # @rolloverOnceSymbols.each do |symbol|
        # if symbol == line.strip[-1]
          # rolloverSymbolStack << symbol
          # break
        # end
      # end
      
      @lineBuf << line if @isCapturing
    end
    
    def begin_capture?
      @beginCapture
    end
    
    def end_capture?
      @endCapture
    end
    
    def capturing?
      @isCapturing
    end
    
    def rollover_once?
      @rolloverOnce
    end
    
    def empty?
      @lineBuf.empty?
    end
    
    def clear
      @beginCapture = false
      @endCapture = false
      @isCapturing = false
      @rolloverOnce = false
      
      @openingSymbol = nil
      @closingSymbol = nil
      @starting_line_number = 0
      @lineBuf = Array.clear
    end
    
    def to_s
      out = ''
      
      # TODO: This will have to be somewhat intelligent on how it
      #       rejoins strings based on the ending character of the
      #       last line.
      #       Sometimes joins need spaces, sometimes they need commas.
      @lineBuf.each do |line|
        out += ' ' unless line == @lineBuf.first
        out += line.strip
      end
      
      out
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