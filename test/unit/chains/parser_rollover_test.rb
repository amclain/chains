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
    
    # Clear rollover.
    @rollover.clear
    assert @rollover.begin_capture? == false
    assert @rollover.end_capture? == false
    assert @rollover.capturing? == false
    assert @rollover.rollover_once? == false
    assert @rollover.to_s == ''
    
    # Separated function parameters.
    @rollover << 'myFunction ('
    assert @rollover.begin_capture?
    assert @rollover.capturing?
    @rollover << 'ui a'
    assert @rollover.capturing?
    assert @rollover.begin_capture? == false
    assert @rollover.end_capture? == false
    assert @rollover.rollover_once? == false
    @rollover << 'ui b'
    @rollover << 'ui c'
    @rollover << ') -> doStuff'
    assert @rollover.end_capture?
    assert @rollover.capturing? == false
    
    s = @rollover.to_s
    assert s == 'myFunction (ui a, ui b, ui c) -> doStuff',
      "Output: #{s}"
    
    # Multi-line with single rollover nested.
    @rollover.clear
    @rollover << 'a = {'
    @rollover << '  1 +'
    @rollover << '  2'
    @rollover << '}'
    
    s = @rollover.to_s
    assert s == 'a = {1 + 2}',
      "Output: #{s}"
    
    # Nested rollovers.
    # a = {
    #   {
    #     1...
    #   {
    #     a...
    # }
    @rollover.clear
    
    @rollover << 'a = {'
    assert @rollover.begin_capture?
    @rollover << '  {'
    @rollover << '    1'
    @rollover << '    2'
    @rollover << '    3'
    @rollover << '  }'
    assert @rollover.end_capture? == false # Shouldn't end inside the nested rollover.
    assert @rollover.capturing?
    @rollover << '  {'
    @rollover << '    a'
    @rollover << '    b'
    @rollover << '    c'
    @rollover << '  }'
    @rollover << '}'
    assert @rollover.end_capture?
    
    s = @rollover.to_s
    assert s == 'a = {{1, 2, 3}, {a, b, c}}',
      "Output: #{s}"
  end
end
