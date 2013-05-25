require 'test_helper'
require "#{$lib}/netlinx/element/include"

class TestInclude < Test::Unit::TestCase
  
  def test_include
    d = NetLinx::Include.new 'amx-lib-volume'
    assert d.to_s == "#include 'amx-lib-volume'\n"
  end
  
end
