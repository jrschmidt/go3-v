require 'rubygems'

require 'sinatra'

require 'coffee-script'

require 'pry'


get '/' do
  erb :index
end


# TODO
# TODO  Return the set of points that red can legally play on
# TODO

get '/legal-points' do
  str = @@game.get_string
  str
end


class Game

  attr :board

  def initialize
    @board = Board.new
  end


  def get_string
    str = @board.get_points_string
    str
  end


end



class Board

  ROW_START = [0,0,0,0,0,0,1,2,3,4,5]
  ROW_END = [5,6,7,8,9,10,10,10,10,10,10]



  def initialize
    @points = GameBoardPoints.new()
  end


  def get_points_string
    @points.get_string
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
    pt = get_all_points
    p_string = all_points_to_string(pt)
  end


  def get_string
    points = get_all_points
    str = all_points_to_string(points)
    str
  end


  def get_all_points
    points = []
    @pt_array.each_index do |i|
      row = @pt_array[i]
      row.each_index do |j|
        points << [i,j] if row[j] == :empty
      end
    end
    points
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




