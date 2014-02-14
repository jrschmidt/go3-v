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


end


