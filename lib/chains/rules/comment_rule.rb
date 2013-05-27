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
      
      # Separate out multi-line comments.
      # Ignore // and //^ which are handled by the inline comment parser.
      line.scan(/(.*)\s*(\/\/\^?.*)/).collect do |text|
        binding.pry
      end
      
      @element  
    end
    
  end
end
