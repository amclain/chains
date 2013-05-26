require "#{$lib}/chains/rules/rules"

require "#{$lib}/chains/rules/assignment_rule"
require "#{$lib}/chains/rules/comment_rule"
require "#{$lib}/chains/rules/device_definition_rule"

module Chains
  class StandardRules < Chains::Rules
    attr_reader :rules
    
    def initialize
      super()
      
      @rules = [
        Chains::CommentRule.new,
        Chains::DeviceDefinitionRule.new,
        Chains::AssignmentRule.new
      ]
    end
    
    def each(&block)
      @rules.each(&block)
    end
    
  end
end
