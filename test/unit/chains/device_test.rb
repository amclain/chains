require 'test_helper'
require "#{$lib}/chains/parser"

class TestChainsParser < Test::Unit::TestCase
  
  def setup
    @parser = Chains::Parser.new
  end
  
  def teardown
    @parser = nil
  end
  
  # def test_rollover_concatenation
    # input =
# <<EOS
# ui myVar2 =
  # 456
# EOS
# 
    # doc = @parser.parse(input)
    # assert doc.to_s == input,
      # "Function input does not match output.\n\n#{input}\n\n#{doc.to_s}"
  # end
  
  def test_indentation
    input = 
<<EOS
vdvTP   = 33000:1:0
  dvTP  = 10001:1:0
 
dvTP2   = 10002:1:0
EOS
    
    doc = @parser.parse(input)
    assert doc.to_s == input,
      "Function input does not match output.\n\n#{input}\n\n#{doc.to_s}"
      
    input2 = 
<<EOS
vdvTP   = 33000:1:0
  dvTP  = 10001:1:0
 
  dvTP2   = 10002:1:0
EOS

    output2 = 
<<EOS
vdvTP   = 33000:1:0
  dvTP  = 10001:1:0
  dvTP2   = 10002:1:0
EOS
    
    doc = @parser.parse(input2)
    assert doc.to_s == output2,
      "Function input does not match output.\n\n#{input}\n\n#{doc.to_s}"
  end
  
  # def test_block_comment
    # flunk
  # end
#   
  # def test_single_line_comment
    # flunk
  # end
#   
  # def test_single_element
    # flunk
  # end
#   
  # def test_nested_element
    # flunk
  # end
#   
  # def test_syntax_error
    # flunk
  # end
  
end
