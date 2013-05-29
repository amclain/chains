# A parser rule.

require "#{$lib}/chains/rules/rule"

require "#{$lib}/chains/device_definition"

module Chains
  class DeviceDefinitionRule < Chains::Rule
    
    def initialize
      super()
    end
    
    def parse(line)
      @element = nil
      
      line.scan(/\s*(\w*)\s*=\s*(\d{1,5}:\d{1,5}:\d{1,5})\s*(.*)/).
        collect do |symbol, value, filePath|
          filePath = nil if filePath.empty?
          e = Chains::DeviceDefinition.new(symbol, value, filePath)
          @element = e unless e.empty?
      end
      
      @element
    end
    
  end
end
