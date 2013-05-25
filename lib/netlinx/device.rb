require "#{$lib}/netlinx/element"

module NetLinx
  class Device < NetLinx::Element
    
    # device = DPS or device number.
    def initialize(name, device, port = nil, system = nil)
      super()
      
      @name = name
      @device = device.to_i
      @port = port.to_i
      @system = system.to_i
      
      
      dps = (device.is_a? String) ? device.split(':') : Array.new 
      
      if dps.count > 0
        # DPS address was specified.
        @device = dps[0]
        @port = dps[1]
        @system = dps[2]
      end
    end
    
    # Override to do nothing.
    def add_element(e)
    end
    
    def to_s
      "#{@name.to_s.ljust 32} = #{@device}:#{@port}:#{@system};\n"
    end
    
  end
end
