require "#{$lib}/chains/rules/rules"

require "#{$lib}/chains/rules/comment_rule"

module Chains
  class StandardRules < Chains::Rules
    attr_reader :rules
    
    def initialize
      super()
      
      @rules = [
        #Chains::AssignmentRule.new
      ]
    end
    
    def each(&block)
      @rules.each(&block)
    end
    
  end
end
