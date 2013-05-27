require 'test_helper'
require "#{$lib}/chains/parser"

class TestChainsParserRollover < Test::Unit::TestCase
  
  def setup
    @rollover = Chains::ParserRollover.new
  end
  
  def teardown
    @rollover = nil
  end
  
  def test_rollover
    # Separated assignment.
    @rollover << 'myVar2 ='
    assert @rollover.begin_capture?
    assert @rollover.capturing?
    assert @rollover.rollover_once?
    @rollover.starting_line_number = 1
    assert @rollover.starting_line_number == 1
    
    @rollover << '   123   '
    assert @rollover.end_capture?
    assert @rollover.capturing? == false
    assert @rollover.rollover_once? == false
    assert @rollover.starting_line_number == 1
    
    # Returns correct output.
    s = @rollover.to_s
    assert s == 'myVar2 = 123',
      "Output: #{s}"
    
    # Rollover doesn't accept additional input after
    # 'end_capture?' flag is raised.
    @rollover << 'myVar3 ='
    assert @rollover.end_capture?
    assert @rollover.begin_capture? == false
    assert @rollover.capturing? == false
    assert @rollover.rollover_once? == false
    
    # Separated function parameters.
    
    # Nested array.
  end
end
