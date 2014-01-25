

require '~/Desktop/go3/go3'


require 'test/unit'


class Go3Test < Test::Unit::TestCase


  def app
    Sinatra::Application
  end

  def test_equals
    assert_equal(7,7)
    assert_equal("ABCDE","ABCDE")
    assert_equal("Hello John","Hello John")
  end

  def test_scopes
    game = Game.new
    points = game.board.points

    assert_equal(points.get_point([1,1]),:empty)
    assert_equal(points.get_point([6,1,]),:empty)
    assert_equal(points.get_point([3,5]),:empty)
    assert_equal(points.get_point([1,6]),:empty)
    assert_equal(points.get_point([9,4]),:empty)
    assert_equal(points.get_point([8,11]),:empty)
  end

end


