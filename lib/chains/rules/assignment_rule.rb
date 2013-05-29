# A parser rule.

require "#{$lib}/chains/rules/rule"

require "#{$lib}/chains/assignment"

module Chains
  class AssignmentRule < Chains::Rule
    
    def initialize
      super()
    end
    
    def parse(line)
      @element = nil
      
      line.scan(/\s*(\w*)\s*=\s*(.*)/).
        collect do |symbol, value|
          e = Chains::Assignment.new(symbol, value)
          @element = e unless e.empty?
      end
      
      @element
    end
    
  end
end
