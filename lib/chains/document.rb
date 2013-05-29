require "#{$lib}/chains/element"
require "#{$lib}/chains/program_name"
require "#{$lib}/chains/parser"
require "#{$lib}/chains/writer"

module Chains
  class Document < Chains::Element
    attr_accessor :programName
    attr_accessor :writer
    attr_accessor :user_types
    attr_accessor :globals
    
    def initialize(writer = nil)
      super()
      @writer = writer || Chains::Writer.new(self)
      
      @user_types = Array.new  # User defined types (structures).
      @globals = Array.new     # Global variables.
    end
    
    def self.parse(input)
      p = Chains::Parser.new
      p.parse input
    end
    
    def to_s
      @writer.to_s
    end
    
  end
end
