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

  attr :board, :analyzer, :legal_moves


  def initialize
    @board = Board.new
    @analyzer = GroupAnalyzer.new(self)
    @legal_moves = LegalMovesFinder.new(self)
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


  def adjacent?(pt1,pt2)
    adj = true
    adj = false if pt1.class != Array || pt2.class != Array
    adj = false if pt1.size != 2 || pt2.size != 2
    adj = false if [pt1,pt2].flatten.count {|z| z.class == Fixnum} != 4
    adj = false if valid_point?(pt1) == false || valid_point?(pt2) == false

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

    filter = [ [0,-1], [1,0], [1,1], [0,1], [-1,0], [-1,-1] ]
    return get_adjacent_points(p,filter)
  end


  def all_previous_adjacent_points(p)
    # Returns an array containing the set of adjacent valid points which
    # are returned before the point p by the each method, in this order:
    # :left_up, :left, :right_up

    filter = [ [-1,-1], [-1,0], [0,-1] ]
    return get_adjacent_points(p,filter)
  end


  def get_adjacent_points(p,filter)

    points = []
    if valid_point?(p)
      a = p[0]
      b = p[1]
      for delta in filter
        z = [ (a + delta[0]), (b + delta[1]) ]
        points << z if valid_point?(z)
      end
    end
    return points
  end


end



class GameBoardPoints
  # A collection of values for each point on the game board

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


  def each   # FIXME This might be better in the Board class
    1.upto(@pt_array.size-1) do |i|
      row = @pt_array[i]
      row.each_index do |j|
        if not row[j] == nil
          pt = [j,i]
          yield pt
        end
      end
    end
  end


  def find_all_points(value)
    points = []
    each {|pt| points << pt if get_point(pt) == value}
    return points
  end


  def get_empty_points
    points = find_all_points(:empty)
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
  # FIXME Get rid of the 4 layers of method calls to get to this method!!!
  #       Which class should really call the string builder method?
  def get_string
    @string_builder.get_string(find_all_points(:empty))
  end


end



class LegalMovesFinder

  def initialize(game_object)
    @game = game_object
    @board = @game.board
    @points = @board.points
  end


  def find_legal_moves(color)
    moves = []


    return moves
  end


end



class GroupAnalyzer

  def initialize(game_object)
    @game = game_object
    @board = @game.board
    @points = @board.points

    @group_points = GameBoardPoints.new()
  end


  def find_all_groups
    groups = {red: [], white: [], blue: []}

    @points.each do |point|
      if @points.get_point(point) != :empty
        color = @points.get_point(point)
        same_color_neighbors = []
        for nb in @board.all_previous_adjacent_points(point)
          if @points.get_point(nb) == color
            same_color_neighbors << {point: nb, group: @group_points.get_point(nb)}
          end
        end

        if same_color_neighbors == []
          group = make_new_group(groups, color)
        else
          group = merge_groups(groups, color, same_color_neighbors)
        end

        groups[color][group[:id]] << point
        @group_points.set_point(point,group)
      end
    end

    return groups
  end


  def make_new_group(groups, color)
    i = groups[color].size
    groups[color][i] = []
    group = {color: color, id: i}
    return group  # FIXME Make sure we add the new point to the new group in the groups[color][i] array
  end


  def merge_groups(groups, color, same_color_neighbors)
    groups_to_merge = []

    same_color_neighbors.each do |nb|
      groups_to_merge << nb[:group] if not groups_to_merge.include?(nb[:group])
    end

    points = []
    groups_to_merge.each do |gr|
      points.concat(@group_points.find_all_points(gr))
      groups[color][gr[:id]] = nil
    end
    groups[color].compact!

    group = make_new_group(groups, color)
    points.each {|pt| @group_points.set_point(pt,group)}
    groups[color][group[:id]] = points
    return group
  end


  def set_group_id(old_id, new_id)
    group = @group_points.find_all_points(old_id)
    group.each do |pt|
      @group_points.set_point(pt, new_id)
    end
  end


  def find_group_airpoints(group)
    air = []
    for stone in group
      air << @board.all_adjacent_points(stone).select {|pt| @board.points.get_point(pt) == :empty}
    end
    air.flatten!(1).uniq!
    return air
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
    return str
  end


  def all_points_to_string(points)
    str = points.map {|pt| point_to_string(pt)}.join
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



def go_string
  @@game = Game.new if defined?(@@game) == nil
  str = @@game.get_string
  return str
end




