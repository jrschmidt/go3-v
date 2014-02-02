

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
    assert_equal board.valid_point?([0,0]), false
    assert_equal board.valid_point?([0,1]), false
    assert_equal board.valid_point?([0,5]), false
    assert_equal board.valid_point?([0,8]), false
    assert_equal board.valid_point?([1,0]), false
    assert_equal board.valid_point?([1,7]), false
    assert_equal board.valid_point?([1,11]), false
    assert_equal board.valid_point?([3,9]), false
    assert_equal board.valid_point?([3,12]), false
    assert_equal board.valid_point?([4,10]), false
    assert_equal board.valid_point?([5,11]), false
    assert_equal board.valid_point?([8,0]), false
    assert_equal board.valid_point?([9,1]), false
    assert_equal board.valid_point?([9,3]), false
    assert_equal board.valid_point?([11,5]), false
    assert_equal board.valid_point?([12,1]), false
    assert_equal board.valid_point?([14,6]), false
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


  def test_game_board_points_each_method
    game = Game.new
    board = game.board
    points = board.points
    total = points.count {|pt| true}
    assert_equal total, 91
  end


  def test_find_all_points
    game = Game.new
    board = game.board
    points = board.points
    assert_equal points.find_all_points(:empty).size, 91

    set_test_groups(board,1)
    assert_equal points.find_all_points(:red).size, 7
    assert_equal points.find_all_points(:white).size, 7
    assert_equal points.find_all_points(:blue).size, 7
    assert_equal points.find_all_points(:empty).size, 70
  end


  def test_get_empty_points
    game = Game.new
    board = game.board
    points = board.points
    assert_equal points.get_empty_points.size, 91
    set_test_groups(board,1)
    assert_equal points.get_empty_points.size, 70
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
    assert_equal(board.adjacent?([10,8,2],[11,9]), false)
    assert_equal(board.adjacent?([3,1],[3,0]), false)
    assert_equal(board.adjacent?([6,7],[4.5,3]), false)
    assert_equal(board.adjacent?([:blue],[6,8]), false)
    assert_equal(board.adjacent?([1,1],["2,1"]), false)
    assert_equal(board.adjacent?([8,4],[8,4]), false)
    assert_equal(board.adjacent?([5,8],[5,3]), false)
    assert_equal(board.adjacent?([5,8],[11,9]), false)
    assert_equal(board.adjacent?([5,8],[1,2]), false)
    assert_equal(board.adjacent?([2,6],[9,9]), false)
    assert_equal(board.adjacent?([7,10],[3,8]), false)
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

  def test_find_all_groups
    game = Game.new
    board = game.board

    set_test_groups(board,1)

    groups = game.analyzer.find_all_groups()
    assert_equal groups.class, Hash

    red = groups[:red]
    white = groups[:white]
    blue = groups[:blue]
    assert_equal red.class, Array
    assert_equal red.size, 1
    assert_equal white.class, Array
    assert_equal white.size, 3
    assert_equal blue.class, Array
    assert_equal blue.size, 3

    assert_equal red[0].size, 7
    expected = [ [2, 4], [3, 4], [4, 5], [4, 6], [3, 7], [4, 7], [5, 7] ]
    expected.each {|pt| assert(red[0].include?(pt)) }

    assert_equal white[0].size, 3
    expected = [ [2, 3], [3, 2], [3, 3] ]
    expected.each {|pt| assert(white[0].include?(pt)) }

    assert_equal white[1].size, 2
    expected = [ [7, 4], [8, 5] ]
    expected.each {|pt| assert(white[1].include?(pt)) }

    assert_equal white[2].size, 2
    expected = [ [10, 7], [10, 8] ]
    expected.each {|pt| assert(white[2].include?(pt)) }

    assert_equal blue[0], [ [5, 3] ]

    assert_equal blue[1].size, 2
    expected = [ [3, 5], [3, 6] ]
    expected.each {|pt| assert(blue[1].include?(pt)) }

    assert_equal blue[2].size, 4
    expected = [ [7, 8], [8, 8], [7, 9], [9, 9] ]
    expected.each {|pt| assert(blue[2].include?(pt)) }
  end


  def test_find_group_airpoints_1
    # (1) Use hard-coded groups

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
      assert_equal spaces.size, group[:expected_points].size
      for pt in group[:expected_points]
        assert(spaces.include?(pt))
      end
    end
  end


  def test_find_group_airpoints_2
    # (2) Use groups returned by find_all_groups method

    game = Game.new
    board = game.board

    set_test_groups(board,1)

    groups = game.analyzer.find_all_groups()

    # EXPECTED POINTS:
    expected = { red: [  [ [4,4], [5,5], [5,6], [6,7], [6,8], [5,8], [4,8], [3,8], [2,7], [2,6], [2,5], [1,4], [1,3] ]  ],

               white: [  [ [1,3], [1,2], [2,2], [2,1], [3,1], [4,2], [4,3], [4,4] ],
                         [ [6,3], [7,3], [8,4], [9,5], [9,6], [8,6], [7,5], [6,4] ],
                         [ [9,6], [10,6], [11,7], [11,8], [11,9], [10,9], [9,8], [9,7] ]  ],

                blue: [  [ [5,2], [6,3], [6,4], [5,4], [4,3], [4,2] ],
                         [ [2,5], [2,6] ],
                         [ [6,7], [7,7], [8,7], [9,8], [10,9], [10,10], [9,10], [8,9], [8,10], [7,10], [6,9], [6,8] ]  ] }

    for color in [:red, :white, :blue]
      groups[color].each_index do |g|
        spaces = game.analyzer.find_group_airpoints(groups[color][g])
        assert_equal spaces.size, expected[color][g].size
        for pt in expected[color][g]
          assert(spaces.include?(pt))
        end
      end
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

#    assert_equal red_moves.size, 55
#    assert_equal white_moves.size, 55
#    assert_equal blue_moves.size, 53

#    assert red_moves.include?([5,1])
#    assert white_moves.include?([5,1])
#    assert blue_moves.include?([5,1])

#    assert red_moves.include?([6,3])
#    assert white_moves.include?([6,3])
#    assert blue_moves.include?([6,3])

#    assert red_moves.include?([2,7])
#    assert white_moves.include?([2,7])
#    assert blue_moves.include?([2,7])

#    assert red_moves.include?([5,6])
#    assert white_moves.include?([5,6])
#    assert blue_moves.include?([5,6])

#    assert red_moves.include?([9,5])
#    assert white_moves.include?([9,5])
#    assert blue_moves.include?([9,5])

#    assert red_moves.include?([6,11])
#    assert white_moves.include?([6,11])
#    assert blue_moves.include?([6,11])

#    assert red_moves.include?([10,11])
#    assert white_moves.include?([10,11])
#    assert blue_moves.include?([10,11])

#    assert red_moves.include?([7,10])
#    assert white_moves.include?([7,10])
#    assert blue_moves.include?([7,10])

    assert_equal red_moves.include?([3,2]), false
    assert_equal white_moves.include?([3,2]), false
    assert_equal blue_moves.include?([3,2]), false

    assert_equal red_moves.include?([1,4]), false
    assert_equal white_moves.include?([1,4]), false
    assert_equal blue_moves.include?([1,4]), false

    assert_equal red_moves.include?([6,4]), false
    assert_equal white_moves.include?([6,4]), false
    assert_equal blue_moves.include?([6,4]), false

    assert_equal red_moves.include?([2,6]), false
    assert_equal white_moves.include?([2,6]), false
    assert_equal blue_moves.include?([2,6]), false

    assert red_moves.include?([2,2])
    assert white_moves.include?([2,2])
    assert_equal blue_moves.include?([2,2]), false

    assert red_moves.include?([1,3])
    assert white_moves.include?([1,3])
    assert_equal blue_moves.include?([1,3]), false
  end


  # Utility Methods for Tests

  def set_test_groups(board, index)
    points = board.points

    case index

    when 1
      points.set_point [3,4], :red
      points.set_point [4,6], :red
      points.set_point [4,7], :red
      points.set_point [4,5], :red
      points.set_point [2,4], :red
      points.set_point [3,7], :red
      points.set_point [5,7], :red
      points.set_point [7,4], :white
      points.set_point [8,5], :white
      points.set_point [5,3], :blue
      points.set_point [3,3], :white
      points.set_point [2,3], :white
      points.set_point [3,2], :white
      points.set_point [3,5], :blue
      points.set_point [3,6], :blue
      points.set_point [10,8], :white
      points.set_point [10,7], :white
      points.set_point [7,8], :blue
      points.set_point [9,9], :blue
      points.set_point [7,9], :blue
      points.set_point [8,8], :blue

    when 2
      points.set_point [1,1], :white
      points.set_point [2,1], :blue
      points.set_point [3,1], :blue
      points.set_point [4,1], :blue
      points.set_point [6,1], :red
      points.set_point [2,2], :white
      points.set_point [3,2], :white
      points.set_point [4,2], :white
      points.set_point [5,2], :white
      points.set_point [6,2], :blue
      points.set_point [7,2], :blue
      points.set_point [3,3], :blue
      points.set_point [4,3], :red
      points.set_point [5,3], :blue
      points.set_point [6,3], :red
      points.set_point [2,4], :red
      points.set_point [3,4], :blue
      points.set_point [4,4], :red
      points.set_point [5,4], :blue
      points.set_point [6,4], :red
      points.set_point [3,5], :red
      points.set_point [4,5], :white
      points.set_point [6,5], :red
      points.set_point [4,6], :white
      points.set_point [5,6], :white

    when 3
      points.set_point [1,1], :blue
      points.set_point [2,1], :blue
      points.set_point [3,1], :red
      points.set_point [4,1], :blue
      points.set_point [1,2], :red
      points.set_point [3,2], :red
      points.set_point [4,2], :blue
      points.set_point [5,2], :red
      points.set_point [2,3], :red
      points.set_point [3,3], :blue
      points.set_point [4,3], :red
      points.set_point [5,3], :red
      points.set_point [1,4], :blue
      points.set_point [2,4], :red
      points.set_point [3,4], :white
      points.set_point [4,4], :blue
      points.set_point [5,4], :white
      points.set_point [6,4], :white
      points.set_point [7,4], :white
      points.set_point [1,5], :blue
      points.set_point [2,5], :white
      points.set_point [3,5], :blue
      points.set_point [4,5], :white
      points.set_point [5,5], :white
      points.set_point [6,5], :blue
      points.set_point [7,5], :blue
      points.set_point [1,6], :white
      points.set_point [2,6], :white
      points.set_point [3,6], :blue
      points.set_point [4,6], :blue
      points.set_point [6,6], :blue
      points.set_point [3,7], :red
      points.set_point [4,7], :red
      points.set_point [5,7], :red
      points.set_point [6,7], :white
      points.set_point [7,7], :white
    end


  end


end



