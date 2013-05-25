require "#{@lib}/netlinx/element"

module NetLinx
  class Function < NetLinx::Element
    
    def initialize(name, parameters = nil, returnType = nil)
      super()
      
      @name = name
      @parameters = parameters
      @returnType = returnType
    end
    
    def to_s
      out = ''
      
      return out unless @name
      
      out += 'define_function '
      out += "#{@returnType} " if @returnType
      out += "#{@name}"
      out += " (#{@parameters})" if @parameters
      
      out += "\n{\n"
      
      @elements.each do |e|
        e.to_s.each_line {|line| out += "\t#{line}"}
      end
      
      out += "}\n"
    end
    
  end
end
