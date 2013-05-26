require "#{$lib}/netlinx/block"
require "#{$lib}/netlinx/statement"

module NetLinx
  class Function < NetLinx::Block
    
    def initialize(name, parameters = nil, returnType = nil)
      super ''
      
      @name = name
      @parameters = parameters || Hash.new
      @returnType = returnType
    end
    
    def empty?
      @name.nil? || @name.empty?
    end
    
    def to_s
      @compound = ''
      
      #return @compouond unless @name
      
      @compound += 'define_function '
      @compound += "#{@returnType} " if @returnType
      @compound += "#{@name}("
      
      # Build input parameters.
      unless @parameters.empty?
        @paramArray = @parameters.to_a
        
        @paramArray.each do |param, type|
          @compound += "#{type} #{param}"
          @compound += ', ' unless param == @paramArray.last[0]
        end
      end
      
      @compound += ")"
      
      #If function has a return type, make sure it returns a value.
      if @final.empty? && @returnType
        if @returnType.to_s == 'char' || @returnType.to_s == 'widechar'
          add_final NetLinx::Statement.new('return \'\'')
        else
          add_final NetLinx::Statement.new('return 0')
        end
      end
      
      super()
    end
    
  end
end
