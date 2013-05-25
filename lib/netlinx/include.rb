require "#{$lib}/netlinx/element"

module NetLinx
  class Include < Element
    
    def initialize(name)
      super()
      
      @name = name
    end
    
    # Override to do nothing.
    def add_element(e)
    end
    
    def to_s
      "#include '#{@name.to_s}'\n"
    end
    
  end
end
