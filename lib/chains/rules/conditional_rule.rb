# A parser rule.

require "#{$lib}/chains/rules/rule"

require "#{$lib}/chains/conditional"

module Chains
  class ConditionalRule < Chains::Rule
    
    def initialize
      super()
      
      # if
      # else if
      # else
      # case
      # when
      @startsWith = [
        'if', 'else if', 'else', 'case', 'when'
      ]
    end
    
    def parse(line)
      @element = nil
      
      foundMatch = false
      elementType = ''
      
      @startsWith.each do |type|
        type += ' ' unless type == 'else'
        if line.strip.start_with?(type)
          foundMatch = true
          elementType = type
          break
        end
      end
      
      return nil unless foundMatch
      
      
      # TODO: This needs to be more robust.
      #       Will screw up at parenthesis and such.
      
      
      
      if elementType == 'when'
        e = Chains::Conditional.new(elementType, line[5, -1])
        @element = e unless e.empty?
        
      elsif elementType == 'else'
        e = Chains::Conditional.new(elementType)
        @element = e unless e.empty?
        
      else
        e = Chains::Conditional.new(elementType, line[elementType.length + 1, -1])
        @element = e unless e.empty?
        
      end
      
      @element
    end
    
  end
end
