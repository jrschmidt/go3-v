require 'rubygems'

require 'sinatra'

require 'coffee-script'

require 'pry'


get '/' do
  erb :index
end


get '/legal-points' do
  str = @@game.get_string
  str
end


class Game

  attr :board


  def initialize
    @board = Board.new
  end


  def handle_move(player,point)
    # TODO Cucumber FILLER
  end


  def make_move(player,point)
    # TODO Cucumber FILLER
  end


    # TODO Cucumber FILLER
  def remove_point(point)
    @board.remove_point(point)
  end


  def send_legal_moves
    # TODO Cucumber FILLER
  end


  def send_string(game_string)

  end


  def get_string
    str = @board.get_points_string
    str
  end


  def get_legal_moves_string

  end


end



class Player

  def get_move
    # TODO Cucumber FILLER (at least for AiPlayer)
  end

end



class HumanPlayer < Player

end



class AiPlayer < Player

end
  # FIXME Board & GameBoardPoints : These classes need to be refactored. What
  # does the GameBoardPoints class do? Is it the collection of all points on
  # the game board with the status for each point? Or is it a general purpose
  # set of points which can be added to or subtracted from?


class Board

  ROW_START = [1,1,1,1,1,1,2,3,4,5,6]
  ROW_END = [6,7,8,9,10,11,11,11,11,11,11]



  def initialize
    @points = GameBoardPoints.new()
  end


  def remove_point(point)
    @points.remove_point(point)
  end


  def get_points_string
    @points.get_string
  end


  def valid_point?(point)
    a = point[0]
    b = point[1]
    valid = false
    # TODO get rid of hard-coded constants
    if a>=1 && a<= 11
      valid = true if b >= ROW_START[a-1] && b <= ROW_END[a-1]
    end
    valid
  end


end



class GameBoardPoints

  HEX_D = {10 => "a",
           11 => "b",
           12 => "c",
           13 => "d",
           14 => "e",
           15 => "f" }

  def initialize
    @pt_array = []
    Board::ROW_START.each_index do |i|
      row = []
      st = Board::ROW_START[i]
      ed = Board::ROW_END[i]
      st.upto(ed) {|k| row[k] = :empty}
      @pt_array[i] = row
    end
# TODO
#    pt = get_empty_points
#    p_string = all_points_to_string(pt)
  end


  def get_empty_points
    points = []
    @pt_array.each_index do |i|
      row = @pt_array[i]
      row.each_index do |j|
        points << [j,i+1] if row[j] == :empty
      end
    end
    points
  end


  # TODO
  # complete get_point method to get value of a point
  # complete set_point method to set a value for a point in the @pt_array[]

  def get_point(point)
    pt = nil
    

    pt
  end

    # TODO need to define what 'remove a point' means or if 'remove_point is
    # even a valid operation. Obviously, change the :empty value so the point
    # no longer appears in any list of empty or available points. But unless
    # we want to have a :not_available value, we should just set the point
    # directly to a stone color (:red, :white, :blue) or some other value.
  def remove_point(point)
    # TODO Cucumber FILLER
  end


  # FIXME Put string functions in another class?
  def get_string
    points = get_empty_points
    str = all_points_to_string(points)
#    binding.pry
    str
  end


  def all_points_to_string(points)
    str = points.map {|pt| point_to_string(pt)}.reduce("",:<<) {|pt_str| pt_str}
    str
  end


  def point_to_string(point)
    str = hex_digit(point[0]) + hex_digit(point[1])
    str
  end


  def hex_digit(n)
    dd = n<10 ? n.to_s : HEX_D[n] if n >= 0 && n < 16
    dd = " " if n<0 || n>15
    dd
  end


end



def hxr_string(msg)
  str = "point "
  str << msg.to_s
  str
end


def go_string
  @@game = Game.new if defined?(@@game) == nil
  str = @@game.get_string
  str
end




