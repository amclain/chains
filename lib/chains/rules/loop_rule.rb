# A parser rule.

require "#{$lib}/chains/rules/rule"

require "#{$lib}/chains/loop"

module Chains
  class LoopRule < Chains::Rule
    
    def initialize
      super()
      
      @startsWith = ['for', 'while']
    end
    
    def parse(line)
      @element = nil
      
      skip = true
      
      @startsWith.each do |type|
        if line.strip.start_with?(type + ' ')
          skip = false
          break
        end
      end
      
      return @element if skip
      
      # traditional for
      line.scan(/(?i:for)\s+(.*)\s*;\s*(.*)\s*;\s*(.*)?/).
        collect do |init, condition, increment|
          e = Chains::Loop.new(:for,
            :init => init,
            :condition => condition,
            :increment => increment
          )
          @element = e unless e.empty?
          return @element
      end
      
      # for i in items
      line.scan(/(?i:for)\s+(\w+)\s+(?i:in)\s+(\w+)/).
        collect do |symbol, set|
          e = Chains::Loop.new(:for,
            :symbol => symbol,
            :set => set
          )
          @element = e unless e.empty?
          return @element
      end
      
      # while
      # TODO: Fix this regex.
      line.scan(/(?i:while)\s+?(.*)/).
        collect do |condition|
          e = Chains::Loop.new(:while,
            :condition => condition
          )
          @element = e unless e.empty?
          return @element
      end
      
      @element
    end
    
  end
end
