=begin
  Precompiler Directive:
  Directive name followed by a value.
  Separated with space, starting with a #.
  
  #include 'camera' 
=end

require "#{$lib}/netlinx/element"

module NetLinx
  class Directive < Element
    
    def initialize(directive, value = nil)
      super()
      
      @directive = directive
      @value = value
    end
    
    def to_s
      out  = "##{@directive}"
      out += " #{@value}" if @value
      out += "\n"
    end
    
  end
end
