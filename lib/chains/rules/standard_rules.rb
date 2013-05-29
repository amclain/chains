require "#{$lib}/chains/rules/rules"

require "#{$lib}/chains/rules/assignment_rule"
require "#{$lib}/chains/rules/comment_rule"
require "#{$lib}/chains/rules/conditional_rule"
require "#{$lib}/chains/rules/device_definition_rule"
require "#{$lib}/chains/rules/function_rule"
require "#{$lib}/chains/rules/loop_rule"
require "#{$lib}/chains/rules/variable_rule"
require "#{$lib}/chains/rules/verbatim_rule"

module Chains
  class StandardRules < Chains::Rules
    attr_reader :rules
    
    def initialize
      super()
      
      @rules = [
        Chains::CommentRule.new,
        Chains::DeviceDefinitionRule.new,
        Chains::VariableRule.new,
        Chains::AssignmentRule.new,
        Chains::LoopRule.new,
        Chains::ConditionalRule.new,
        Chains::FunctionRule.new,
        Chains::VerbatimRule.new
      ]
    end
    
    def each(&block)
      @rules.each(&block)
    end
    
  end
end
