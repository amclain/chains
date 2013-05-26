# A parser rule.

require "#{$lib}/chains/rules/rule"

module Chains
  class AssignmentRule < Chains::Rule
    
    def initialize
      super()
    end
    
    def parse(line)
      # (\w*)\s*=\s*(\S*)   ## Not accurate.
      
    end
    
  end
end
