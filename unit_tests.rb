

require '~/Desktop/go3/go3'


require 'test/unit'



class Go3Test < Test::Unit::TestCase

  def app
    Sinatra::Application
  end


  # Tests Part One - Board Point and Stone Methods

  def test_valid_point
    game = Game.new
    board = game.board
    assert board.valid_point?([1,1])
    assert board.valid_point?([1,4])
    assert board.valid_point?([1,6])
    assert board.valid_point?([2,1])
    assert board.valid_point?([2,7])
    assert board.valid_point?([3,8])
    assert board.valid_point?([4,9])
    assert board.valid_point?([5,10])
    assert board.valid_point?([6,11])
    assert board.valid_point?([9,4])
    assert board.valid_point?([11,6])
    assert board.valid_point?([11,11])

    refute board.valid_point?([0,0])
    refute board.valid_point?([0,1])
    refute board.valid_point?([0,5])
    refute board.valid_point?([0,8])
    refute board.valid_point?([1,0])
    refute board.valid_point?([1,7])
    refute board.valid_point?([1,11])
    refute board.valid_point?([3,9])
    refute board.valid_point?([3,12])
    refute board.valid_point?([4,10])
    refute board.valid_point?([5,11])
    refute board.valid_point?([8,0])
    refute board.valid_point?([9,1])
    refute board.valid_point?([9,3])
    refute board.valid_point?([11,5])
    refute board.valid_point?([12,1])
    refute board.valid_point?([14,6])
  end


  def test_get_point
    game = Game.new
    points = game.board.points
    assert_equal points.get_point([1,1]), :empty
    assert_equal points.get_point([6,1,]), :empty
    assert_equal points.get_point([3,5]), :empty
    assert_equal points.get_point([1,6]), :empty
    assert_equal points.get_point([9,4]), :empty
    assert_equal points.get_point([8,11]), :empty
  end


  def test_set_point
    game = Game.new
    board = game.board
    points = board.points

    points.set_point([4,4], :red)
    points.set_point([9,9], :red)
    points.set_point([4,6], :white)
    points.set_point([2,3], :white)
    points.set_point([5,9], :blue)
    points.set_point([3,4], :blue)
    assert_equal  points.get_point([4,4]), :red
    assert_equal  points.get_point([9,9]), :red
    assert_equal  points.get_point([4,6]), :white
    assert_equal  points.get_point([2,3]), :white
    assert_equal  points.get_point([5,9]), :blue
    assert_equal  points.get_point([3,4]), :blue
    assert_equal  points.get_point([3,3]), :empty
    assert_equal  points.get_point([7,10]), :empty
    assert_equal  points.get_point([11,11]), :empty
    assert_equal  points.get_point([6,3]), :empty
  end


  def test_set_points
    game = Game.new
    board = game.board
    points = board.points

    points.set_points :red, [ [4,4], [9,9] ]
    points.set_points :white, [ [4,6], [2,3] ]
    points.set_points :blue, [ [5,9], [3,4] ]
    assert_equal  points.get_point([4,4]), :red
    assert_equal  points.get_point([9,9]), :red
    assert_equal  points.get_point([4,6]), :white
    assert_equal  points.get_point([2,3]), :white
    assert_equal  points.get_point([5,9]), :blue
    assert_equal  points.get_point([3,4]), :blue
    assert_equal  points.get_point([3,3]), :empty
    assert_equal  points.get_point([7,10]), :empty
    assert_equal  points.get_point([11,11]), :empty
    assert_equal  points.get_point([6,3]), :empty
  end


  def test_game_board_points_each_method
    game = Game.new
    board = game.board

    total = board.count {|pt| true}
    assert_equal total, 91

    board.each {|pt| assert(board.valid_point?(pt)) }
  end


  def test_adjacent_points
    game = Game.new
    analyzer = game.analyzer
    board = game.board

    assert board.adjacent?([5,8],[5,7])
    assert board.adjacent?([5,8],[4,7])
    assert board.adjacent?([5,8],[4,8])
    assert board.adjacent?([5,8],[5,9])
    assert board.adjacent?([5,8],[6,9])
    assert board.adjacent?([5,8],[6,8])
    assert board.adjacent?([1,2],[1,3])
    assert board.adjacent?([9,11],[8,10])
    assert board.adjacent?([9,4],[10,5])
    assert board.adjacent?([5,3],[6,3])
    assert board.adjacent?([10,8],[11,9])

    refute(board.adjacent?([10,8,2],[11,9]))
    refute(board.adjacent?([3,1],[3,0]))
    refute(board.adjacent?([6,7],[4.5,3]))
    refute(board.adjacent?([:blue],[6,8]))
    refute(board.adjacent?([1,1],["2,1"]))
    refute(board.adjacent?([8,4],[8,4]))
    refute(board.adjacent?([5,8],[5,3]))
    refute(board.adjacent?([5,8],[11,9]))
    refute(board.adjacent?([5,8],[1,2]))
    refute(board.adjacent?([2,6],[9,9]))
    refute(board.adjacent?([7,10],[3,8]))
  end


  def test_all_adjacent_points
    game = Game.new
    analyzer = game.analyzer
    board = game.board

    assert_equal board.all_adjacent_points([6,6]), [ [6,5], [7,6], [7,7], [6,7], [5,6], [5,5] ]
    assert_equal board.all_adjacent_points([2,3]), [ [2,2], [3,3], [3,4], [2,4], [1,3], [1,2] ]
    assert_equal board.all_adjacent_points([5,4]), [ [5,3], [6,4], [6,5], [5,5], [4,4], [4,3] ]
    assert_equal board.all_adjacent_points([8,5]), [ [8,4], [9,5], [9,6], [8,6], [7,5], [7,4] ]
    assert_equal board.all_adjacent_points([7,8]), [ [7,7], [8,8], [8,9], [7,9], [6,8], [6,7] ]
    assert_equal board.all_adjacent_points([3,7]), [ [3,6], [4,7], [4,8], [3,8], [2,7], [2,6] ]
    assert_equal board.all_adjacent_points([1,1]), [ [2,1], [2,2], [1,2] ]
    assert_equal board.all_adjacent_points([4,1]), [ [5,1], [5,2], [4,2], [3,1] ]
    assert_equal board.all_adjacent_points([6,1]), [ [7,2], [6,2], [5,1] ]
    assert_equal board.all_adjacent_points([9,4]), [ [10,5], [9,5], [8,4], [8,3] ]
    assert_equal board.all_adjacent_points([11,6]), [ [11,7], [10,6], [10,5] ]
    assert_equal board.all_adjacent_points([11,8]), [ [11,7], [11,9], [10,8], [10,7] ]
    assert_equal board.all_adjacent_points([11,11]), [ [11,10], [10,11], [10,10] ]
    assert_equal board.all_adjacent_points([9,11]), [ [9,10], [10,11], [8,11], [8,10] ]
    assert_equal board.all_adjacent_points([6,11]), [ [6,10], [7,11], [5,10] ]
    assert_equal board.all_adjacent_points([2,7]), [ [2,6], [3,7], [3,8], [1,6] ]
    assert_equal board.all_adjacent_points([1,6]), [ [1,5], [2,6], [2,7] ]
    assert_equal board.all_adjacent_points([1,4]), [ [1,3], [2,4], [2,5], [1,5] ]
    assert_equal board.all_adjacent_points([7,18]), []
    assert_equal board.all_adjacent_points([4,0]), []
    assert_equal board.all_adjacent_points([3,2,7]), []
    assert_equal board.all_adjacent_points([57,11]), []
  end


  # Tests Part Two - Game Analysis Methods


  def test_find_same_color_neighbor_groups_1
    # When the point will be added to a single existing group

    game = Game.new
    board = game.board
    analyzer = game.analyzer
    points = board.points
    group_points = game.analyzer.group_points

    points.set_points :red, [ [3,3], [4,3] ]
    points.set_points :white, [ [3,1], [2,2], [3,2], [5,1], [6,1], [5,3] ]
    points.set_points :blue, [ [1,2], [2,3], [5,2], [6,2] ]

    group_points.set_points( {color: :red, id: 0}, [ [3,3], [4,3] ] )
    group_points.set_points( {color: :white, id: 0}, [ [3,1], [2,2], [3,2] ] )
    group_points.set_points( {color: :white, id: 1}, [ [5,1], [6,1] ] )
    group_points.set_points( {color: :white, id: 2}, [ [5,3] ] )
    group_points.set_points( {color: :blue, id: 0}, [ [1,2], [2,3] ] )
    group_points.set_points( {color: :blue, id: 1}, [ [5,2], [6,2] ] )

    ngroups = analyzer.find_same_color_neighbor_groups([6,3],:white)
    assert_equal( ngroups, [ {id: 2, stones: [ [5,3] ]} ] )
  end


  def test_find_same_color_neighbor_groups_2
    # When the point will be added to two groups after they are merged

    game = Game.new
    board = game.board
    analyzer = game.analyzer
    points = board.points
    group_points = game.analyzer.group_points

    points.set_points :red, [ [3,2], [4,2], [4,4], [5,4], [6,3], [7,3] ]
    points.set_points :white, [ [5,2], [6,2] ]
    points.set_points :blue, [ [1,2], [2,3], [3,3] ]

    group_points.set_points( {color: :red, id: 0}, [ [3,2], [4,2] ] )
    group_points.set_points( {color: :red, id: 1}, [ [6,3], [7,3] ] )
    group_points.set_points( {color: :red, id: 2}, [ [4,4], [5,4] ] )
    group_points.set_points( {color: :white, id: 0}, [ [5,2], [6,2] ] )
    group_points.set_points( {color: :blue, id: 0}, [ [1,2], [2,3], [3,3] ] )

    expected = [ {id: 1, stones: [ [6,3], [7,3] ] },
                 {id: 2, stones: [ [4,4], [5,4] ] } ]

    ngroups = analyzer.find_same_color_neighbor_groups([6,4],:red)
    assert_contain_same_objects ngroups, expected
  end


  def test_get_group_stones
    game = Game.new
    board = game.board
    analyzer = game.analyzer
    points = board.points
    group_points = game.analyzer.group_points

    points.set_points :red, [ [2,4], [3,4], [4,5], [4,6], [3,7], [4,7], [5,7] ]
    points.set_points :white, [ [2,3], [3,3], [3,2], [6,2], [6,5], [7,6] ]
    points.set_points :blue, [ [3,5], [3,6], [5,3], [6,3], [7,4], [8,5] ]

    group_points.set_points( {color: :red, id: 0}, [ [2,4], [3,4], [4,5], [4,6], [3,7], [4,7], [5,7] ] )
    group_points.set_points( {color: :white, id: 0}, [ [2,3], [3,3], [3,2] ] )
    group_points.set_points( {color: :white, id: 1}, [ [6,2] ] )
    group_points.set_points( {color: :white, id: 2}, [ [6,5], [7,6] ] )
    group_points.set_points( {color: :blue, id: 0}, [ [5,3], [6,3], [7,4], [8,5] ] )
    group_points.set_points( {color: :blue, id: 1}, [ [3,5], [3,6] ] )

    exp_red0 = [ [2,4], [3,4], [4,5], [4,6], [3,7], [4,7], [5,7] ]
    exp_white0 = [ [2,3], [3,3], [3,2] ]
    exp_white1 = [ [6,2] ]
    exp_white2 = [ [6,5], [7,6] ]
    exp_blue0 = [ [5,3], [6,3], [7,4], [8,5] ]
    exp_blue1 = [ [3,5], [3,6] ]

    red0 = analyzer.get_group_stones(:red, 0)
    white0 = analyzer.get_group_stones(:white, 0)
    white1 = analyzer.get_group_stones(:white, 1)
    white2 = analyzer.get_group_stones(:white, 2)
    blue0 = analyzer.get_group_stones(:blue, 0)
    blue1 = analyzer.get_group_stones(:blue, 1)

    assert_contain_same_objects exp_red0, red0
    assert_contain_same_objects exp_white0, white0
    assert_contain_same_objects exp_white1, white1
    assert_contain_same_objects exp_white2, white2
    assert_contain_same_objects exp_blue0, blue0
    assert_contain_same_objects exp_blue1, blue1
  end


  def test_find_all_groups_1
    game = Game.new
    board = game.board

    set_test_groups(board,1)

    groups = game.analyzer.find_all_groups()
    assert_rwb_hash(groups, Array)

    red = groups[:red]
    white = groups[:white]
    blue = groups[:blue]

    assert_equal red.size, 1
    assert_equal white.size, 3
    assert_equal blue.size, 3

    red_exp_0 = [ [2, 4], [3, 4], [4, 5], [4, 6], [3, 7], [4, 7], [5, 7] ]
    assert_contain_same_objects red_exp_0, red[0]

    white_exp = [ [ [2, 3], [3, 2], [3, 3] ],
                  [ [7, 4], [8, 5] ],
                  [ [10, 7], [10, 8] ] ]

    white_exp.each do |xgrp|
      assert_not_nil white.find {|group| contain_same_objects(xgrp,group) }
    end 

    blue_exp = [ [ [5, 3] ],
                 [ [3, 5], [3, 6] ],
                 [ [7, 8], [8, 8], [7, 9], [9, 9] ] ]

    blue_exp.each do |xgrp|
      assert_not_nil blue.find {|group| contain_same_objects(xgrp,group) }
    end

  end


  def test_find_all_groups_3
    game = Game.new
    board = game.board

    set_test_groups(board,3)

    groups = game.analyzer.find_all_groups()
    assert_rwb_hash(groups, Array)

    red = groups[:red]
    white = groups[:white]
    blue = groups[:blue]

    assert_equal red.size, 3
    assert_equal white.size, 4
    assert_equal blue.size, 7

    red_exp = [ [ [3,7], [4,7], [5,7] ],
                [ [2,4], [2,3], [1,2] ],
                [ [3,1], [3,2], [4,3], [5,3], [5,2] ] ]

    red_exp.each do |xgrp|
      assert_not_nil red.find {|group| contain_same_objects(xgrp,group) }
    end 

    white_exp = [ [ [3,4], [4,5], [5,5], [5,4], [6,4], [7,4], [8,4] ],
                  [ [1,6], [2,6], [2,5] ],
                  [ [6,1], [7,2], [6,2] ],
                  [ [6,7], [7,7] ] ]

    white_exp.each do |xgrp|
      assert_not_nil white.find {|group| contain_same_objects(xgrp,group) }
    end 

    blue_exp = [ [ [1,1], [2,1] ],
                 [ [4,1], [4,2] ], 
                 [ [3,3], [4,4] ], 
                 [ [6,3], [7,3], [8,3] ], 
                 [ [1,4], [1,5] ], 
                 [ [3,5], [3,6], [4,6] ], 
                 [ [6,6], [6,5], [7,5] ] ]

    blue_exp.each do |xgrp|
      assert_not_nil blue.find {|group| contain_same_objects(xgrp,group) }
    end 

  end


  def test_find_group_airpoints

    game = Game.new
    board = game.board

    set_test_groups(board,1)

    # Red Group #1 - 7 stones, 13 airpoints
    red1 = { stones: [ [3,4], [4,6], [4,7], [4,5], [2,4], [3,7], [5,7] ],
             expected_points: [ [4,4], [5,5], [5,6], [6,7], [6,8], [5,8], [4,8], [3,8], [2,7], [2,6], [2,5], [1,4], [1,3] ] }

    # White Group #1 - 2 stones, 8 airpoints
    white1 = { stones: [ [7,4], [8,5] ],
               expected_points: [ [6,3], [7,3], [8,4], [9,5], [9,6], [8,6], [7,5], [6,4] ] }

    # White Group #2 - 3 stones, 8 airpoints
    white2 = { stones: [ [3,3], [2,3], [3,2] ] ,
               expected_points: [ [1,3], [1,2], [2,2], [2,1], [3,1], [4,2], [4,3], [4,4] ] }

    # White Group #3 - 2 stones, 8 airpoints
    white3 = { stones: [ [10,8], [10,7] ] ,
             expected_points: [ [9,6], [10,6], [11,7], [11,8], [11,9], [10,9], [9,8], [9,7] ] }

    # Blue Group #1 - 1 stone, 6 airpoints
    blue1 = { stones: [ [5,3] ] ,
             expected_points: [ [5,2], [6,3], [6,4], [5,4], [4,3], [4,2] ] }

    # Blue Group #2 - 2 stones, 2 airpoints
    blue2 = { stones: [ [3,5], [3,6] ] ,
             expected_points: [ [2,5], [2,6] ] }

    # Blue Group #3 - 4 stones, 12 airpoints
    blue3 = { stones: [ [7,8], [9,9], [7,9], [8,8] ] ,
             expected_points: [ [6,7], [7,7], [8,7], [9,8], [10,9], [10,10], [9,10], [8,9], [8,10], [7,10], [6,9], [6,8] ] }

    groups = [red1, white1, white2, white3, blue1, blue2, blue3]

    for group in groups
      spaces = game.analyzer.find_group_airpoints(group[:stones])
      assert_contain_same_objects group[:expected_points], spaces
    end
  end


  def test_find_empty_points_for_groups
    game = Game.new
    analyzer = game.analyzer
    board = game.board

    set_test_groups(board,3)
    groups = analyzer.find_all_groups

    empty_points = analyzer.find_empty_points_for_groups(groups)

    red = empty_points.find_all {|group| group[:color] == :red }
    white = empty_points.find_all {|group| group[:color] == :white }
    blue = empty_points.find_all {|group| group[:color] == :blue }

    assert_equal red.size, 3
    assert_equal white.size, 4
    assert_equal blue.size, 7

    red_exp = [ {eyes: [[1,3], [2,2]],
                 points: [[1,2], [2,3], [2,4]] },

                {eyes: [[2,2], [5,1]],
                 points: [[3,1], [3,2], [4,3], [5,3], [5,2]] },

                {eyes: [[2,7], [3,8], [4,8], [5,8], [6,8], [5,6]],
                 points: [[3,7], [4,7], [5,7]] } ]

    red_exp.each do |xgrp|
      assert_not_nil red.find {|group| contain_same_objects(xgrp[:eyes], group[:eyes]) }
      assert_not_nil red.find {|group| contain_same_objects(xgrp[:points], group[:points]) }
    end

    white_exp = [ {eyes: [[5,1]],
                   points: [[6,1], [6,2], [7,2]] },

                  {eyes: [[2,7]],
                   points: [[1,6], [2,6], [2,5]] },

                  {eyes: [[5,6], [8,5], [9,5], [9,4]],
                   points: [[3,4], [4,5], [5,5], [5,4], [6,4], [7,4], [8,4]] },

                  {eyes: [[6,8], [7,8], [8,8], [8,7], [5,6], [7,6]],
                   points: [[6,7], [7,7]] } ]

    white_exp.each do |xgrp|
      assert_not_nil white.find {|group| contain_same_objects(xgrp[:eyes], group[:eyes]) }
      assert_not_nil white.find {|group| contain_same_objects(xgrp[:points], group[:points]) }
    end

    blue_exp = [ {eyes: [[2,2]],
                  points: [[1,1], [2,1]] },

                 {eyes: [[2,2]],
                  points: [[3,3], [4,4]] },

                 {eyes: [[5,1]],
                  points: [[4,1], [4,2]] },

                 {eyes: [[1,3]],
                  points: [[1,4], [1,5]] },

                 {eyes: [[5,6]],
                  points: [[3,5], [3,6], [4,6]] },

                 {eyes: [[9,4]],
                  points: [[6,3], [7,3], [8,3]] },

                 {eyes: [[5,6], [7,6], [8,6], [8,5]],
                  points: [[6,6], [6,5], [7,5]] } ]

    blue_exp.each do |xgrp|
      assert_not_nil blue.find {|group| contain_same_objects(xgrp[:eyes], group[:eyes]) }
      assert_not_nil blue.find {|group| contain_same_objects(xgrp[:points], group[:points]) }
    end 

  end




  # Tests Part Three - Legal Moves Methods

  def test_find_legal_moves
    game = Game.new
    board = game.board
    legal_moves = game.legal_moves

    set_test_groups(board,3)

    red_moves = legal_moves.find_legal_moves(:red)
    white_moves = legal_moves.find_legal_moves(:white)
    blue_moves = legal_moves.find_legal_moves(:blue)

    assert_equal red_moves.size, 48
    assert_equal white_moves.size, 48
    assert_equal blue_moves.size, 46

    # Most Important Test Points:
    assert red_moves.include?([5,1])
    assert white_moves.include?([5,1])
    assert blue_moves.include?([5,1])

    assert red_moves.include?([5,6])
    assert white_moves.include?([5,6])
    assert blue_moves.include?([5,6])

    assert red_moves.include?([9,4])
    assert white_moves.include?([9,4])
    assert blue_moves.include?([9,4])

    assert red_moves.include?([2,2])
    assert white_moves.include?([2,2])
    refute blue_moves.include?([2,2])

    assert red_moves.include?([1,3])
    assert white_moves.include?([1,3])
    refute blue_moves.include?([1,3])

    # Other Points:
    assert red_moves.include?([2,7])
    assert white_moves.include?([2,7])
    assert blue_moves.include?([2,7])

    assert red_moves.include?([7,6])
    assert white_moves.include?([7,6])
    assert blue_moves.include?([7,6])

    assert red_moves.include?([9,7])
    assert white_moves.include?([9,7])
    assert blue_moves.include?([9,7])

    assert red_moves.include?([11,6])
    assert white_moves.include?([11,6])
    assert blue_moves.include?([11,6])

    assert red_moves.include?([6,11])
    assert white_moves.include?([6,11])
    assert blue_moves.include?([6,11])

    assert red_moves.include?([10,11])
    assert white_moves.include?([10,11])
    assert blue_moves.include?([10,11])

    assert red_moves.include?([7,9])
    assert white_moves.include?([7,9])
    assert blue_moves.include?([7,9])

    refute red_moves.include?([3,2])
    refute white_moves.include?([3,2])
    refute blue_moves.include?([3,2])

    refute red_moves.include?([1,4])
    refute white_moves.include?([1,4])
    refute blue_moves.include?([1,4])

    refute red_moves.include?([6,4])
    refute white_moves.include?([6,4])
    refute blue_moves.include?([6,4])

    refute red_moves.include?([5,5])
    refute white_moves.include?([5,5])
    refute blue_moves.include?([5,5])

    refute red_moves.include?([2,6])
    refute white_moves.include?([2,6])
    refute blue_moves.include?([2,6])
  end


  # Tests Part Four - Points To String Methods

  def test_hex_digit
    stringer = PointStringBuilder.new

    assert_equal stringer.hex_digit(0), "0"
    assert_equal stringer.hex_digit(1), "1"
    assert_equal stringer.hex_digit(2), "2"
    assert_equal stringer.hex_digit(5), "5"
    assert_equal stringer.hex_digit(9), "9"
    assert_equal stringer.hex_digit(10), "a"
    assert_equal stringer.hex_digit(11), "b"
    assert_equal stringer.hex_digit(12), "c"
    assert_equal stringer.hex_digit(13), "d"
    assert_equal stringer.hex_digit(14), "e"
    assert_equal stringer.hex_digit(15), "f"
    assert_equal stringer.hex_digit(-8), " "
    assert_equal stringer.hex_digit(16), " "
    assert_equal stringer.hex_digit(17), " "
    assert_equal stringer.hex_digit(42), " "
    assert_equal stringer.hex_digit(897), " "
    refute_equal stringer.hex_digit(3), "4"
    refute_equal stringer.hex_digit(8), "a"
    refute_equal stringer.hex_digit(11), "11"
    refute_equal stringer.hex_digit(14), "14"
    refute_equal stringer.hex_digit(17), "h"
    refute_equal stringer.hex_digit(29), "29"
    refute_equal stringer.hex_digit(440), "440"
  end


  def test_point_to_string
    stringer = PointStringBuilder.new

    assert_equal stringer.point_to_string([1,1]), "11"
    assert_equal stringer.point_to_string([3,1]), "31"
    assert_equal stringer.point_to_string([4,2]), "42"
    assert_equal stringer.point_to_string([2,5]), "25"
    assert_equal stringer.point_to_string([6,6]), "66"
    assert_equal stringer.point_to_string([8,3]), "83"
    assert_equal stringer.point_to_string([5,10]), "5a"
    assert_equal stringer.point_to_string([6,11]), "6b"
    assert_equal stringer.point_to_string([8,11]), "8b"
    assert_equal stringer.point_to_string([10,11]), "ab"
    assert_equal stringer.point_to_string([11,11]), "bb"
    assert_equal stringer.point_to_string([11,10]), "ba"
    assert_equal stringer.point_to_string([10,10]), "aa"
    assert_equal stringer.point_to_string([10,7]), "a7"
    assert_equal stringer.point_to_string([11,6]), "b6"
    assert_equal stringer.point_to_string([11,8]), "b8"
    refute_equal stringer.point_to_string([3,3]), "3,3"
    refute_equal stringer.point_to_string([6,6]), "[6,6]"
    refute_equal stringer.point_to_string([4,7]), "7,2"
    refute_equal stringer.point_to_string([11,11]), "1111"
    refute_equal stringer.point_to_string([10,8]), "108"
    refute_equal stringer.point_to_string([7,10]), "710"
    refute_equal stringer.point_to_string([10,10]), "1010"
  end


  def test_points_to_string
    stringer = PointStringBuilder.new
    hex = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b"]
    points = [ [3,6], [9,9], [8,11], [10,11], [7,10], [2,5], [9,8], [8,3], [5,4], [6,10] ]
    string = stringer.points_to_string(points)

    assert_equal string, "36998bab7a259883546a"
  end



  # Custom Assertion Methods

  def assert_array(objekt, array_size, component_type)
    ok = true
    if objekt.class != Array
      ok = false
    elsif objekt.size != array_size
      ok = false
    else
      objekt.each {|member| ok = false if member.class != component_type }
    end
    assert ok, "Expected object <#{objekt.class}> to be an Array containing #{array_size} objects of type #{component_type}"
  end


  def assert_hash(objekt, hash_size, keys, component_type)
    ok = true
    if objekt.class != Hash
      ok = false
    elsif objekt.size != hash_size
      ok = false
    elsif objekt.keys.sort != keys.sort
      ok = false
    else
      objekt.each_value {|value| ok = false if value.class != component_type }
    end
    assert ok, "Expected object <#{objekt.class}> to be a Hash containing #{hash_size} objects of type #{component_type} for the keys #{keys}"
  end


  def assert_rwb_hash(objekt, component_type)
    # Assert that <objekt> is a hash with keys [:red, :white, :blue], and that
    # the value for each of these keys is an array of objects of class <component_type>

    ok = true
    if objekt.class != Hash
      ok = false
    elsif objekt.keys.sort != [:blue, :red, :white]
      ok = false
    elsif objekt.values.find{|vv| vv.class != Array} != nil
      ok = false
    else
      objekt.values.each do |aa|
        ok = false if aa.find {|obj| obj.class != component_type} != nil
      end
    end

    assert ok, "Expected object <#{objekt.class}> to be a Hash with keys [:red, :white, :blue] and values of type Array with each element of the array of type #{component_type}"
  end


  def assert_contain_same_objects(array1, array2)
    ok = contain_same_objects(array1, array2)
    assert ok, "Expected both arrays to contain the same objects (in any order)."
  end


  # Utility Methods for Tests

  def contain_same_objects(array1, array2)
    ok = true
    if array1.size != array2.size
      ok = false
    else
      array1.each {|obj| ok = false if array2.include?(obj) == false }
    end

    return ok
  end


  # Test Data Setting Methods

  def set_test_groups(board, index)
    points = board.points

    case index
    when 1
      points.set_points :red, [ [3,4], [4,6], [4,7], [4,5], [2,4], [3,7], [5,7] ]
      points.set_points :white, [ [7,4], [8,5], [3,3], [2,3], [3,2], [10,8], [10,7] ]
      points.set_points :blue, [ [5,3], [3,5], [3,6], [7,8], [9,9], [7,9], [8,8] ]

    when 2
      points.set_points :red, [ [6,1], [4,3], [6,3], [2,4], [4,4], [6,4], [3,5], [6,5] ]
      points.set_points :white, [ [1,1], [2,2], [3,2], [4,2], [5,2], [4,5], [4,6], [5,6] ]
      points.set_points :blue, [ [2,1], [3,1], [4,1], [6,2], [7,2], [3,3], [5,3], [3,4], [5,4] ]

    when 3
      points.set_points :red, [ [3,1], [1,2], [3,2], [5,2], [2,3], [4,3], [5,3], [2,4], [3,7], [4,7], [5,7] ]
      points.set_points :white, [ [6,1], [6,2], [7,2], [3,4], [5,4], [6,4], [7,4], [8,4], [2,5], [4,5], [5,5], [1,6], [2,6], [6,7], [7,7] ]
      points.set_points :blue, [ [1,1], [2,1], [4,1], [4,2], [3,3], [6,3], [7,3], [8,3], [1,4], [4,4], [1,5], [3,5], [6,5], [7,5], [3,6], [4,6], [6,6] ]
    end
  end


end



