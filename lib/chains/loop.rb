require "#{$lib}/chains/element"

module Chains
  class Loop < Chains::Element
    attr_accessor :type
    attr_accessor :hash
    
    # Hash:
    #  FOR LOOP
    #    :init =>       'i = 0, len = max_length_array(items)'
    #    :contition =>  'i <= len'
    #    :increment =>  'i++' (optional)
    #  FOR/IN
    #    :symbol =>     'i'
    #    :set =>        'items'
    #  WHILE
    #    :condition =>  'x > 0'
    def initialize(type, hash)
      super()
      
      @type = type
      @hash = hash
    end
    
    def empty?
      @type.nil? || @type.empty?
    end
    
    def to_s
      out  = ''
      out += "#{type.to_s} "
      
      if hash[:symbol]
        # FOR/IN
        out += "#{hash[:symbol]} in #{hash[:set]}"
        
      elsif hash[:init]
        # FOR
        out += "#{hash[:init]}; #{hash[:condition]}; #{hash[:increment]}"
        
      elsif hash[:condition]
        # WHILE
        out += "#{hash[:condition]}"
      end
      
      out += ' ' + @comment.to_s if @comment
      out += "\n"
      
      @children.each {|child| out += "\t#{child.to_s}"}
      @siblings.each {|sibling| out += "#{sibling.to_s}"}
      
      out += "\n"
      out
    end
  end
end