# Tests for Gameplay Control Methods
class GameplayControlTest < Test::Unit::TestCase
  include TestHelpers
  include TestData

  COLORS = [:red, :white, :blue]

  def test_whose_turn
    game = Game.new
    manager = game.manager

    player = manager.whose_turn?
    assert COLORS.include?(player)
  end


  def test_next_player
    game = Game.new
    manager = game.manager

    player = manager.whose_turn?
    assert_equal manager.whose_turn?, :red

    manager.next_player
    assert_equal manager.whose_turn?, :white

    manager.next_player
    assert_equal manager.whose_turn?, :blue

    manager.next_player
    assert_equal manager.whose_turn?, :red

    manager.next_player
    assert_equal manager.whose_turn?, :white

    manager.next_player
    assert_equal manager.whose_turn?, :blue

  end


  def test_make_a_move
    game = Game.new
    manager = game.manager
    board = game.board
    points = board.points

    manager.make_a_move(:red, [3,4])
    assert_equal points.get_point([3,4]), :red

    manager.make_a_move(:white, [9,6])
    assert_equal points.get_point([9,6]), :white

    manager.make_a_move(:blue, [10,9])
    assert_equal points.get_point([10,9]), :blue

    manager.make_a_move(:red, [4,3])
    assert_equal points.get_point([4,3]), :red

    manager.make_a_move(:white, [7,4])
    assert_equal points.get_point([7,4]), :white

    manager.make_a_move(:blue, [8,8])
    assert_equal points.get_point([8,8]), :blue

    manager.make_a_move(:red, [6,3])
    assert_equal points.get_point([6,3]), :red

    manager.make_a_move(:white, [3,6])
    assert_equal points.get_point([3,6]), :white

    manager.make_a_move(:blue, [6,8])
    assert_equal points.get_point([6,8]), :blue

  end


end


