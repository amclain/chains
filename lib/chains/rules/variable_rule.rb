# A parser rule.

require "#{$lib}/chains/rules/rule"

require "#{$lib}/chains/variable"

module Chains
  class VariableRule < Chains::Rule
    
    def initialize
      super()
      
      # ui  unsigned int
      # si  signed int
      # ul  unsigned long
      # sl  signed long
      # ch  character
      # wc  wide character
      # st  string (char[255])
      # st[#] string (char[#])
      # fl  float
      # db  double
      # dv  device
      # dc  devchan
      # [named] user-defined type
      @startsWith = [
        'ui', 'si', 'ul', 'sl', 'ch', 'wc', 'st', 'fl', 'db', 'dv', 'dc',
        'integer', 'sinteger', 'long', 'slong', 'char', 'widechar',
        'float', 'double', 'dev', 'devchan'
      ]
      
      # Have to handle st[x] and user-defined types.
    end
    
    def parse(line)
      @element = nil
      
      foundMatch = false
      
      @startsWith.each do |type|
        if line.strip.start_with?(type + ' ')
          foundMatch = true
          break
        end
      end
      
      
      
      # TODO: Handle st[x] and user-defined types. #################################
      
      return nil unless foundMatch # TODO: Temporary ###############################
      
      
      
      line.scan(/\s*(\w+)\s+(\w+)(\[\d+\])*(?:\s*=\s*(\w+))?/).
        collect do |type, symbol, size, value|
          if size.class == Array
            size.each do |s|
              s.delete! '['
              s.delete! ']'
            end
          elsif size.class == String
            size.delete! '['
            size.delete! ']'
          end
          
          e = Chains::Variable.new(symbol, type, value, size)
          @element = e unless e.empty?
      end
      
      @element
    end
    
  end
end
