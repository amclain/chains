require "#{$lib}/chains/chains_extensions"

require "#{$lib}/netlinx/assignment"
require "#{$lib}/netlinx/block"
require "#{$lib}/netlinx/conditional"
require "#{$lib}/netlinx/device"
require "#{$lib}/netlinx/directive"
require "#{$lib}/netlinx/document"
require "#{$lib}/netlinx/event_handler"
require "#{$lib}/netlinx/event"
require "#{$lib}/netlinx/function"
require "#{$lib}/netlinx/statement"
require "#{$lib}/netlinx/verbatim"

module Chains
  class NetLinxTransformation
    attr_reader :chains_document
    attr_reader :netlinx_document
    
    def initialize(chainsDocuemnt = nil)
      @chains_document = chainsDocuemnt
      @netlinx_document = nil
      
      transform @chains_document if @chains_document
    end
    
    def self.transform(chainsDocument)
      t = Chains::NetLinxTransformation.new chainsDocument
      t.netlinx_document
    end
    
    def transform(chainsDocument = nil)
      chainsDoc = chainsDocument || @chains_document
      
      netlinxDoc = NetLinx::Document.new
      
      convert_element chainsDoc, netlinxDoc
      
      @netlinx_document = netlinxDoc
    end
    
    
    private
    def convert_element(e, netlinxDoc)
      #binding.pry
      
      # TODO: Stack level too deep.
      
      e.each do |element|
        convert_element e, netlinxDoc
      end
      
      case e.class
      when BlockComment
        transform_block_comment e
      when Comment
        transform_comment e
      when EventDefinition
        t = transform_event_definition e
        netlinxDoc[:events] << t
      when EventHandler
        transform_event_handler e
      when FunctionDefinition
        t = transform_function_definition e
        netlinxDoc[:functions] << t
      when Conditional
        transform_conditional e
      when ProgramName
        t = transform_program_name e
        netlinxDoc.programName = t
      when IncludeDirective
        t = transform_include_directive e
        netlinxDoc[:includes] << t
      when DeviceDefinition
        t = transform_device_definition e
        netlinxDoc[:devices] << t
      when DeviceCombine
        transform_device_combine e
      when ConstantDefinition
        t = transform_constant_definition e
        netlinxDoc[:constants] << t
      when StructureDefinition
        t = transform_structure_definition e
        netlinxDoc[:structures] << t
      when VariableDefinition
        t = transform_variable_definition e
        netlinxDoc[:variables] << t
      end
      
    end
    
    
    def transform_block_comment
      
    end
    
    def transform_comment
      
    end
    
    def transform_event_definition
      
    end
    
    def transform_event_handler
      
    end
    
    def transform_function_definition
      
    end
    
    def transform_conditional
      
    end
    
    def transform_program_name
      binding.pry
    end
    
    def transform_include_directive
      
    end
    
    def transform_device_definition
      binding.pry
    end
    
    def transform_device_combine
      
    end
    
    def transform_constant_definition
      
    end
    
    def transform_structure_definition
      
    end
    
    def transform_assignment
      
    end
    
  end
end
