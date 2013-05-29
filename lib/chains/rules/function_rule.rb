# A parser rule.

require "#{$lib}/chains/rules/rule"

require "#{$lib}/chains/function"

module Chains
  class FunctionRule < Chains::Rule
    
    def initialize
      super()
    end
    
    def parse(line)
      @element = nil
      
      #   ui    myFunc    (ui a)   ->  dostuff
      # [type] [symbol] ([params]) -> [statement]
      line.scan(/\s*(\w+(?:\s+))?(\w+)\s*(\(.*\))?\s*\-\>\s*(.*)?/).
        collect do |type, symbol, params, statement|
          e = Chains::Function.new(symbol, params, type)
          @element = e unless e.empty?
      end
      
      @element
    end
    
  end
end
