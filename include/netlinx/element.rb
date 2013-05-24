module NetLinx
  class Element
    attr_accessor :elements
    
    def initialize
      @elements = Array.new
    end
    
    def add_element(e)
      @elements.push e if e.is_a? Element
    end
    
    def children_to_s
      out += ''
      
      @elements.each do |e|
        e.to_s.each_line {|line| out += "\t#{line}"}
      end
      
      out
    end
  end
end
