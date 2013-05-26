=begin
  Assignment:
  Symbol with an optional type at the beginning, followed by a value.
  Separated by an equals sign and terminated with a colon.
  A type of statement.
  
  integer dspPreset     = false;
  dvTP_Main             = 10001:1:0;
  BTN_LIGHTING_SCENE_1  = 30; 
=end

require "#{$lib}/netlinx/statement"

module NetLinx
  class Assignment < NetLinx::Statement
    def initialize(symbol, value, type = nil)
      super ''
      
      @symbol = symbol
      @value = value
      @type = type
      
      
      @statement  = ''
      @statement += "#{@type.to_s} " if type
      @statement += "#{@symbol.to_s} = #{@value.to_s}"
    end
  end
end
