require "#{$lib}/netlinx/element"

module NetLinx
  class Function < NetLinx::Element
    
    def initialize(name, parameters = nil, returnType = nil)
      super()
      
      @name = name
      @parameters = parameters
      @returnType = returnType
      @variables = Hash.new
    end
    
    def add_variable(type, name)
      @variables[type] = Array.new unless @variables[type]
      @variables[type].push name
    end
    
    def to_s
      out = ''
      
      return out unless @name
      
      out += 'define_function '
      out += "#{@returnType} " if @returnType
      out += "#{@name}"
      out += " (#{@parameters})" if @parameters
      
      out += "\n{\n"
      
      # Print variables.
      @variables.each do |type, names|
        out += "\t#{type.to_s.downcase} #{names.join ', '}\n"
      end
      
      out += "\n" unless @variables.empty?
      
      # Print children.
      @elements.each do |e|
        e.to_s.each_line {|line| out += "\t#{line}"}
      end
      
      out += "}\n"
    end
    
  end
end
