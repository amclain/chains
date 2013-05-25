require "#{$lib}/netlinx/element"

module NetLinx
  class Section < Element
    # Devices
    # Constants
    # Includes
    # Types
    # Variables
    # Functions
    # Events
    # Start
    # Program
    
    def initialize(name = nil)
      super()
      @name = name
    end
    
    def to_s
      out = ''
      
      out += "DEFINE_#{@name.upcase}\n\n" if @name
      
      @elements.each do |e|
        out += e.to_s
      end
      
      out += "\n"
    end
    
  end
end
