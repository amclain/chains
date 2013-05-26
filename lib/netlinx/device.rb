require "#{$lib}/netlinx/assignment"

module NetLinx
  class Device < NetLinx::Assignment
    attr_reader :name
    attr_reader :device
    attr_reader :port
    attr_reader :system
    
    # device = DPS or device number.
    def initialize(name, device, port = nil, system = nil)
      @name = name
      @device = device.to_i
      @port = port.to_i
      @system = system.to_i
      
      @port = 1 if port.is_a?(String) && port.empty?
      
      
      dps = (device.is_a? String) ? device.split(':') : Array.new 
      
      if dps.count > 1
        # DPS address was specified.
        @device = dps[0]
        @port = dps[1]
        @system = dps[2]
      end
      
      super @name, "#{@device}:#{@port}:#{@system}"
    end
    
  end
end
