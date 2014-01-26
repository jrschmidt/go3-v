

require '~/Desktop/go3/go3'


require 'test/unit'


class Go3Test < Test::Unit::TestCase

  def app
    Sinatra::Application
  end

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

    board.set_point([4,4], :red)
    board.set_point([9,9], :red)
    board.set_point([4,6], :white)
    board.set_point([2,3], :white)
    board.set_point([5,9], :blue)
    board.set_point([3,4], :blue)
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

  def test_find_all_points
    game = Game.new
    board = game.board
    points = board.points

    assert_equal points.find_all_points(:empty).size, 91

    board.set_point([4,4], :red)
    board.set_point([9,9], :red)
    board.set_point([4,6], :white)
    board.set_point([2,3], :white)
    board.set_point([5,7], :white)
    board.set_point([5,9], :blue)
    board.set_point([8,9], :blue)
    board.set_point([5,3], :blue)
    board.set_point([10,8], :blue)
    assert_equal points.find_all_points(:red).size, 2
    assert_equal points.find_all_points(:white).size, 3
    assert_equal points.find_all_points(:blue).size, 4
    assert_equal points.find_all_points(:empty).size, 82
  end


end


