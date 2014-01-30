require 'rubygems'

require 'sinatra'

require 'coffee-script'

#require 'pry'

set :server, %w[webrick thin mongrel]

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

  attr :board, :analyzer


  def initialize
    @board = Board.new
    @analyzer = GroupAnalyzer.new(self)
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
    return str
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
    valid = false

    if point.class == Array && point.size == 2 && point.count {|p| p.class == Fixnum} == 2
      a = point[0]
      b = point[1]
      if a>=MIN && a<= MAX
        valid = true if b >= ROW_START[a-1] && b <= ROW_END[a-1]
      end
    end

    return valid
  end


end



class GameBoardPoints
  include Enumerable


  def initialize
    @string_builder = PointStringBuilder.new()
    @pt_array = [nil]
    Board::ROW_START.each_index do |i|
      row = []
      st = Board::ROW_START[i]
      ed = Board::ROW_END[i]
      st.upto(ed) {|k| row[k] = :empty} #TODO The 'row' is actually a diagonal 'column'.
      @pt_array[i+1] = row #TODO Why is this i & k when the other methods use i & j?
    end

    # TODO
    #    pt = get_empty_points
    #    p_string = all_points_to_string(pt)
  end


  def each
    1.upto(@pt_array.size-1) do |i|
      row = @pt_array[i]
      row.each_index do |j|
        if not row[j] == nil
          pt = {point: [j,i], value: row[j]}
          yield pt
        end
      end
    end
  end


  def get_empty_points
    points = []
    1.upto(@pt_array.size-1) do |i|
      row = @pt_array[i]
      row.each_index do |j|
        points << [j,i] if row[j] == :empty
      end
    end
    return points
  end


  def find_all_points(value)
    points = []
    1.upto(@pt_array.size-1) do |i|
      row = @pt_array[i]
      row.each_index do |j|
        points << [j,i] if row[j] == value
      end
    end
    return points
  end


  def get_point(point)
    a = point[0]
    b = point[1]
    val = nil
    row = b > 0 && b <= Board::MAX ? @pt_array[b] : nil
    val = row.class == Array ? row[a] : nil
    return val
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
    return str
  end


  def all_points_to_string(points)
    str = points.map {|pt| point_to_string(pt)}.reduce("",:<<) {|pt_str| pt_str}
    return str
  end


  def point_to_string(point)
    str = hex_digit(point[0]) + hex_digit(point[1])
    return str
  end


  def hex_digit(n)
    dd = n<10 ? n.to_s : HEX_D[n] if n >= 0 && n < 16
    dd = " " if n<0 || n>15
    return dd
  end


end


class GroupAnalyzer

  def initialize(game_object)
    @game = game_object
    @board = @game.board
    @points = @board.points

    @groups = {red: [], white: [], blue: []}
  end

  def get_all_groups
    return @groups
  end

  def adjacent?(pt1,pt2)
    adj = true
    adj = false if pt1.class != Array || pt2.class != Array
    adj = false if pt1.size != 2 || pt2.size != 2
    adj = false if [pt1,pt2].flatten.count {|z| z.class == Fixnum} != 4
    adj = false if @board.valid_point?(pt1) == false || @board.valid_point?(pt2) == false

    if adj == true
      a1 = pt1[0]
      b1 = pt1[1]
      a2 = pt2[0]
      b2 = pt2[1]
      adj = false if (a1-a2).abs > 1 || (b1-b2).abs > 1
      adj = false if (a1 == a2) && (b1 == b2)
      adj = false if (a1 == a2+1) && (b1 == b2-1)
      adj = false if (a1 == a2-1) && (b1 == b2+1)
    end

    return adj
  end

  def all_adjacent_points(p)
    # Returns an array containing the set of adjacent valid points in
    # clockwise order as follows: :right_up, :right, :right_dn, :left_dn,
    # :left, :left_up  

    points = []
    if @board.valid_point?(p)
      a = p[0]
      b = p[1]
      for delta in [ [0,-1], [1,0], [1,1], [0,1], [-1,0], [-1,-1] ]
        z = [ (a + delta[0]), (b + delta[1]) ]
        points << z if @board.valid_point?(z)
      end
    end
    return points
  end

  def find_group_airpoints(group)
    air = []
    for stone in group
      air << all_adjacent_points(stone).select {|pt| @board.points.get_point(pt) == :empty}
    end
    air.flatten!(1).uniq!
    return air
  end


end


def go_string
  @@game = Game.new if defined?(@@game) == nil
  str = @@game.get_string
  return str
end




