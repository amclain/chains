require "#{$lib}/netlinx/element"

module NetLinx
  class EventHandler < Element
    
    def initialize(handler = nil)
      super()
      
      # Handlers: push, release, on, off, etc.
      @handler = handler
      @variables = Hash.new
    end
    
    def add_variable(type, name)
      @variables[type] = Array.new unless @variables[type]
      @variables[type].push name
    end
    
    def to_s
      out = ''
      
      return out unless @handler
      
      out += "#{@handler}:\n"
      out += "{\n"
      
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
