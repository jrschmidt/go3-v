require 'rubygems'

require 'sinatra'

require 'coffee-script'

#require 'pry'

set :server, %w[webrick thin mongrel]

set :port, 4533


set :port, 4533


get '/' do
  erb :index
end


get '/javascripts/go3.js' do
  coffee :go3
end


get '/legal-points' do
  str = @@game.get_string
  str
end


post '/legal-points' do
  str = @@game.get_string
  msg_in = request.body.read
  puts(msg_in)
  str
end


class Game

  attr :board


  def initialize
    @board = Board.new
  end


  def handle_move(player,point)
    # TODO
  end


  def make_move(player,point)
    # TODO
  end


    # TODO
  def remove_point(point)
    @board.remove_point(point)
  end


  def send_legal_moves
    # TODO
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
    # TODO
  end

end



class HumanPlayer < Player

end



class AiPlayer < Player

end



class Board

  attr :points

  ROW_START = [1,1,1,1,1,1,2,3,4,5,6]
  ROW_END = [6,7,8,9,10,11,11,11,11,11,11]
  MIN = 1
  MAX = 11

  def initialize
    @points = GameBoardPoints.new()
  end


  def set_point(point,value)
    @points.set_point(point,value)
  end


  def get_points_string
    @points.get_string
  end


  def valid_point?(point)
    a = point[0]
    b = point[1]
    valid = false
    if a>=MIN && a<= MAX
      valid = true if b >= ROW_START[a-1] && b <= ROW_END[a-1]
    end
    valid
  end


end



class GameBoardPoints

  def initialize
    @string_builder = PointStringBuilder.new()
    @pt_array = [nil]
    Board::ROW_START.each_index do |i|
      row = []
      st = Board::ROW_START[i]
      ed = Board::ROW_END[i]
      st.upto(ed) {|k| row[k] = :empty}
      @pt_array[i+1] = row
    end

# TODO
#    pt = get_empty_points
#    p_string = all_points_to_string(pt)
  end


  def get_empty_points
    points = []
    1.upto(@pt_array.size-1) do |i|
      row = @pt_array[i]
      row.each_index do |j|
        points << [j,i] if row[j] == :empty
      end
    end
    points
  end


  def find_all_points(value)
    points = []
    1.upto(@pt_array.size-1) do |i|
      row = @pt_array[i]
      row.each_index do |j|
        points << [j,i] if row[j] == value
      end
    end
    points
  end


  def get_point(point)
    a = point[0]
    b = point[1]
    val = nil
    row = b > 0 && b <= Board::MAX ? @pt_array[b] : nil
    val = row.class == Array ? row[a] : nil
    val
  end


  def set_point(point,value)
    a = point[0]
    b = point[1]
    row = b > 0 && b <= Board::MAX ? @pt_array[b] : nil
    row[a] = value if row.class == Array
  end


  # TODO Temporarily, this method returns the set of all empty points. Later
  #      we will need to add functionality to compute legal points as the game
  #      progresses.
  def get_string
    @string_builder.get_string(find_all_points(:empty))
  end


end



class PointStringBuilder

  HEX_D = {10 => "a",
           11 => "b",
           12 => "c",
           13 => "d",
           14 => "e",
           15 => "f" }

  def get_string(points)
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



def go_string
  @@game = Game.new if defined?(@@game) == nil
  str = @@game.get_string
  str
end




