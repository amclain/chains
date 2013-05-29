# A parser rule.

require "#{$lib}/chains/rules/rule"

require "#{$lib}/chains/verbatim"

module Chains
  class VerbatimRule < Chains::Rule
    
    def initialize
      super()
    end
    
    def parse(line)
      @element = nil
      
      e = Chains::Verbatim.new(line.strip)
      @element = e unless e.empty?
      
      @element
    end
    
  end
end
