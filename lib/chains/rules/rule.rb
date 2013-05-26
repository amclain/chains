# A parser rule.

module Chains
  class Rule
    attr_reader :element
    
    def initialize
      @element = nil
      
      @parent = Array.new
      @stack = Array.new
    end
    
    def parse(line)
      nil
    end
    
  end
end
