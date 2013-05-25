require 'test_helper'
require "#{$lib}/netlinx/element/device"

class TestDevice < Test::Unit::TestCase
  
  def test_dps
    d = NetLinx::Device.new 'dvTP', '10001:1:0'
    
    string = d.to_s
    
    assert string.length > 0,
      'String is empty.'
    
    # Split string at =
    split = string.split '='
    
    assert split.count > 1,
      'Device did not output an equals (=) sign.'
      
    name = split[0].strip
    assert name == 'dvTP',
      "Device name is '#{name}'. Expected 'dvTP'."
      
    dps = split[1].strip.delete ';'
    assert dps == '10001:1:0',
      "DPS is #{dps}. Expected 10001:1:0."
      
    semicolon = split[1].strip[-1, 1]
    assert semicolon == ';',
      'Line did not end with a semicolon.'
  end
  
  def test_device_port_system
    d = NetLinx::Device.new 'dvTP', 10001, 1, 0
    string = d.to_s
    
    assert string.length > 0,
      'String is empty.'
      
    split = string.split '='
    assert split.count > 1
    
    dps = split[1].strip.delete ';'
    assert dps == '10001:1:0',
      "DPS is #{dps}. Expected 10001:1:0."
  end
  
  def test_device_symbol
    d = NetLinx::Device.new :dvTP, '10001:1:0'
    string = d.to_s
    
    split = string.split '='
    assert split.count > 1
    
    name = split[0].strip
    assert name == 'dvTP',
      "Device name is '#{name}'. Expected 'dvTP'."
  end
  
end
