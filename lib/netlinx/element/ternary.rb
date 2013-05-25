require "#{$lib}/netlinx/element"
require "#{$lib}/netlinx/element/verbatim"

module NetLinx
  class Ternary < Element
    def initialize(condition = nil, trueValue = nil, falseValue = nil, variable = nil)
      super()
      
      @variable = variable
      @condition = condition
      @trueValue = trueValue
      @falseValue = falseValue
    end
    
    def to_s
      out = ''
      
      return out unless @variable
      return out unless @condition
      return out unless @trueValue
      return out unless @falseValue
      
      out += "if (#{@condition})\n"
      out += "{\n"
      out += "\t#{@variable} = #{@trueValue};\n"
      out += "}\n"
      out += "else\n"
      out += "{\n"
      out += "\t#{@variable} = #{@falseValue};\n"
      out += "}\n"
    end
  end
end
