=begin
  Statement:
  A line of executible code.
  Ends with a semicolon.
  
  send_command dvTP_Main, 'adbeep';
  doStuff(); 
=end

require "#{$lib}/netlinx/element"

module NetLinx
  class Statement < Element
    def initialize(statement)
      super()
      @statement = text
    end
    
    def to_s
      "#{@statement.to_s};\n"
    end
  end
end
