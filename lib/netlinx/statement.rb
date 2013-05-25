=begin
  Statement:
  A line of executible code.
  Ends with a semicolon.
  
  send_command dvTP_Main, 'adbeep';
  doStuff(); 
=end

require "#{$lib}/netlinx/element"

module NetLinx
  class Statement < NetLinx::Element
    def initialize(statement)
      super()
      @statement = statement
    end
    
    def to_s
      "#{@statement.to_s};\n"
    end
  end
end
