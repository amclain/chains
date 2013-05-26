# A parser rule.

require "#{$lib}/chains/rules/rule"

require "#{$lib}/chains/assignment"

module Chains
  class CommentRule < Chains::Rule
    
    def initialize
      super()
    end
    
    def parse(line, parent = nil)
      @element = nil
      
      # Separate out single line comments after statement.
      line.scan(/(.*)\s*(\/\/\^?.*)/).collect do |statement, comment|
        @stack << Chains::Comment.new(nil, comment.strip)
        @stack << Chains::Verbatim.new(nil, statement.rstrip) if statement && !statement.empty?
      end
      
      @element = @stack.pop
      
      if !@stack.empty? && !@element.is_a?(Chains::Comment)
        comment = @stack.pop
        comment.parent = @element
        @element.comment = comment
      end
      @stack.clear
      
      @element  
    end
    
  end
end
