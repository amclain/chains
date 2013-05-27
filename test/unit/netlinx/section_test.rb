require 'test_helper'
require "#{$lib}/netlinx/document"
require "#{$lib}/netlinx/section"
require "#{$lib}/netlinx/device"

class TestSection < Test::Unit::TestCase
  
  def test_add_to_section
    doc = NetLinx::Document.new
    e = NetLinx::Device.new :dvTP, '10001:1:0'
    
    doc[:devices] << e
    assert doc.to_s.include? 'dvTP'
  end
  
end
