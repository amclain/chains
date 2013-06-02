# Parse a Chains file to a Chains DOM

require 'treetop'
require "#{$lib}/chains/chains_extensions"

module Chains
  class Parser
    attr_reader :document
    attr_reader :line_number
    
    def initialize(input = nil)
      @document = nil
      
      @commentOpeningSymbols = ['(*', '(^', '(!', '/*', '/^', '/!']
      @commentClosingSymbols = ['*)', '^)', '!)', '*/', '^/', '!/']
      
      # For parser.
      @indentFlag   = '~@(INDENT)@~'
      @outdentFlag  = '~@(OUTDENT)@~'
      @indent = Array.new
      @line_number = 0
      
      
      parse input if input
    end
    
    def parse(input)
      # Input =
      #   Input string, file path, file object.
      
      # TODO: For now we don't care. Assume input string for testing.
      
      treetop = Treetop.load(File.join($lib, 'chains', 'chains.treetop'))
      ttparser = ChainsParser.new
      
      @indent = Array.new    # Push and pop as indentation changes.
      @indent << 0
      
      @line_number = 0

      rollover = ParserRollover.new
      
      inBlockComment = false
      commentClosingSymbol = nil # If in a comment, tracks the closing symbol to watch for.
      
      out = ''
      
      input.each_line do |line|
        @line_number += 1
        
        # Skip empty lines.
        #next if line.strip.empty? && !inBlockComment
        
        
        # Check indentation and pop parents accordingly.
        indentResult = update_indent line unless inBlockComment || rollover.capturing?
        
        
        # Check for multiline comment.
        # Ends with '*/' or '*)'. Possibly on another line.
        @commentOpeningSymbols.each do |symbol|
          if line.strip.start_with? symbol
            inBlockComment = true
            commentClosingSymbol = @commentClosingSymbols[@commentOpeningSymbols.index(symbol)]
            break 
          end
        end
        
        if inBlockComment
          # Look for closing tag.
          inBlockComment = false if line.strip.end_with? commentClosingSymbol
          out += line
          
          unless inBlockComment
            closingSymbol = nil
          end 
          
          next # Skip to next line.
        end

        
        # Check for line rollover.
        # rollover << line
        # rollover.starting_line_number = @line_number
        
        # if rollover.end_capture?
          # line = rollover.to_s
          # rollover.clear
        # end
        
        
        # Add indent and outdent flags to assist the PEG parser.
        if indentResult == 1
          # Line was indented. Add flag.
          out += "#{@indentFlag}#{line}"
          
        elsif indentResult == 0
          # No change in indentation. Pass line through.
          out += line
          
        elsif indentResult <= -1
          # Indentation shifted left one or more times.
          # Add one or more flags.
          
          # Put the outdent flag on the previous line and add the LF back in.
          1.upto(indentResult.abs) {out = out.chop + @outdentFlag + "\n"}
          out += "#{line}"
        end
        
      end # End .each_line
      
      
      # ------------------------------------------------------------------
      # TODO: Check for bad indents before sending document to the parser.
      # ------------------------------------------------------------------
      
      tree = ttparser.parse(out)
      #binding.pry
      
      # Error handling.
      if tree.nil?
        #raise Exception, "Parse error at offset: #{@@parser.index}"
        
        msg = "Parse error at\n\nLine: #{ttparser.failure_line}\n" +
          "Column: #{ttparser.failure_column}\n\n" +
          "OUTPUT:\n\n"
        
        fail = ttparser.failure_line - 1
        start = fail - 5
        stop = fail + 5
        
        start.upto(stop).each do |i|
          msg += (i == fail) ? ' => ' : '    '
          # TODO: Delete indentation flags.
          msg += "%03d: #{out.lines[i].chop
            #gsub(@indentFlag, '').gsub(@outdentFlag, '')
            }\n" % (i + 1) if out.lines[i]
        end
        
        msg += "\n"
        
        raise ParserException, msg
      end
      
      #tree = Parser.clean_tree tree
      
      @document = tree
      tree
    end # End of parser.
    
    
    private
    def self.clean_tree(root_node)
      return if root_node.elements.nil?
      root_node.elements.reverse_each {|e| self.clean_tree e}
      root_node.elements.delete_if do |e|
        e.class.name == 'Treetop::Runtime::SyntaxNode' &&
        (e.elements.nil? || e.elements.count == 0)
      end
    end
    
    def self.clean(tree)
      s = tree.inspect
      out = ''
      s.each_line {|line| out += line unless line.strip.start_with? 'SyntaxNode'}
      out
    end
    
    
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
    
    # Returns 0 if the new indentation is equal to the last
    # indentation. (Indentation level didn't change.)
    #
    # Returns +n number of indent levels if the new indentation
    # is greater than the last indentation. (Entered new level.)
    # Will always return +1 because you can only move one level
    # in at a time.
    #
    # Returns -n number of outdent levels if the new indentation
    # level is less than the last indentation. (Exited one or more
    # levels.)
    def update_indent(line)
      # Parent (p) is based on Indentation (i)
      #
      # i > last
      #   p: push
      #
      # i == last
      #   p: pop, push
      #
      # i < last
      #   p: pop
      #   p: pop (again) if p is a sibling
      
      
      # Update indent level.
      this_indent = indent_count line
      
      if this_indent == @indent.last
        return 0
        
      elsif this_indent > @indent.last
        @indent << this_indent
        return 1
        
      elsif this_indent < @indent.last
        popped = 0
        
        until @indent.last == this_indent
          @indent.pop
          popped -= 1
        end
        
        return popped
      end
    end
    
  end
  
  
  # Rollover object should be discarded or cleared
  # after the 'end_capture?' flag is raised, as it
  # will not accept additional input.
  class ParserRollover
    attr_reader :starting_line_number
    attr_accessor :line_number
    
    def initialize
      @subrollover = nil    # ParserRollover object to handle nested rollovers.
                            # Nil if no nested items.
      
      @beginCapture = false # Flag that line begins rollover capture.
      @endCapture = false   # Flag that line ends rollover capture.
      @isCapturing = false  # Flag that rollover is being captured.
      @rolloverOnce = false # Flag to rollover once and test for rollover again on next line.
      
      @openingSymbol = nil
      @closingSymbol = nil
      @starting_line_number = 0
      @lineBuf = Array.new
      @line_number = 0
      
      
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
        ',', '=', '+', '-', '*', '/', '%', '^', '&', '|', '<', '\\', '?',
        '>', # Must not have a - or = before it.
        ':', # TODO: Must not have a preceeding alphanumeric character.
        # Quotes without a closing set?
      ]
      
    end
    
    def <<(line)
      add_line line
    end
    
    def add_line(line)
      @line_number += 1
      
      line.strip!
      
      # Strip off comments.
      commentPos = line =~ %r{\/\/}
      line = line[0,commentPos].strip if commentPos
      
      # Strip off commas. They will be added back when the rollover is assembled.
      line.chop! if line[-1] == ','
      
      # Reset flags.
      @beginCapture = false
      
      if @rolloverOnce
        # Reset flags.
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
      
      # If in a subrollover, delegate to that subrollover.
      if @subrollover
        @subrollover << line if @subrollover.capturing?
        
        if @subrollover.end_capture?
           # Extract the subrollover's data to the line buffer
           # and destroy the subrollover.
           @lineBuf << @subrollover.to_s
           @subrollover = nil
           return
         else
           # Subrollover is still capturing data.
           return
         end
      end
      
      # Parser is already in a rollover.
      # Start up a sub-rollover helper.
      if (@rolloverOnce || @openingSymbol) &&
         (will_rollover_once?(line) || will_rollover_many?(line))
           # Create a new subrollover unless one already exists
           # due to subrollover capture in progress.
           unless @subrollover
             @subrollover = ParserRollover.new
             @subrollover.starting_line_number = @line_number
             @subrollover << line
           end
           
           # Let sub-sub-rollover data roll through to the sub-rollover.
           # If that makes sense...
           return
      end
      
      # Check for the closing rollover symbol.
      if will_end_rollover? line
        @endCapture = true
        @isCapturing = false
      end
      
      # Check for rollover-once symbols.
      if will_rollover_once? line
        @beginCapture = true
        @endCapture = false
        @isCapturing = true
        @rolloverOnce = true
        
        @lineBuf << line
        return
      end
      
      # Check for begin rollover symbols.
      if will_rollover_many? line
          symbol = line[-1]
        
          @beginCapture = true
          @endCapture = false
          @isCapturing = true
          @rolloverOnce = false
          
          @openingSymbol = symbol
          
          # Store the corresponding closing symbol.
          @closingSymbol = @rolloverClosingSymbols[
            @rolloverOpeningSymbols.index @openingSymbol
          ]
          
          @lineBuf << line
          return
      end
      
      @lineBuf << line if @isCapturing || @endCapture
    end
    
    def starting_line_number=(value)
      @starting_line_number = value
      @line_number = value
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
      @subrollover = nil
      
      @beginCapture = false
      @endCapture = false
      @isCapturing = false
      @rolloverOnce = false
      
      @openingSymbol = nil
      @closingSymbol = nil
      @starting_line_number = 0
      @line_number = 0
      @lineBuf.clear
    end
    
    def will_rollover_once?(line)
      # Check for rollover-once symbols.
      symbol = line[-1]
      if @rolloverOnceSymbols.include? symbol
        skip = false
        
        # Things to skip.
        ch  = line[-2]
        case symbol
          
        # Function definition.
        #  -> or =>
        when '>'
          skip = true if ch == '-' || ch == '='
        
        # Ternary, NOT type definition.
        # (x > 0) ? 1 : 0
        # NOT myType:
        when ':'
          # Do not rollover if preceeding character is alphanumeric.
          skip = true if ch =~ /\w/
        end
        
        return true unless skip
      end
      
      return false
    end
    
    def will_rollover_many?(line)
      # Check for begin rollover symbols.
      @rolloverOpeningSymbols.each do |symbol|
        if symbol == line[-1]
          return true
        end
      end
      
      return false
    end
    
    def will_end_rollover?(line)
      # Check for the closing rollover symbol.
      @closingSymbol == line[0] ? true : false
    end
    
    def to_s
      out = ''
      
      # TODO: This will have to be somewhat intelligent on how it
      #       rejoins strings based on the ending character of the
      #       last line.
      #       Sometimes joins need spaces, sometimes they need commas.
      separator = ''
      
      @lineBuf.each do |line|
        separator = ''  if will_end_rollover? line
        
        out += separator unless line == @lineBuf.first
        out += line.strip
        
        # First line is going to ignore the separator.
        # Set it here for the line to follow.
        separator = ', '
        separator = ''  if will_rollover_many? line
        separator = ' ' if will_rollover_once? line
      end
      
      out
    end
    
  end
  
  class ParserException < Exception
  end
  
end
