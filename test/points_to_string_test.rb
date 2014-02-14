# Tests for Points To String Methods
class PointsToStringTest < Test::Unit::TestCase
  include TestHelpers
  include TestData


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


end


