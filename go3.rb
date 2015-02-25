require 'rubygems'

require 'sinatra'

require 'coffee-script'

require 'pry'

require 'json'

set :server, %w[webrick thin mongrel]

set :port, 4533


get '/' do
  erb :index
end


get '/javascripts/go3.js' do
  coffee :go3
end


post '/make-a-move' do
  puts "POST '/make-a-move'"
  msg_in = request.body.read
  puts "    data = #{msg_in}"
  move_data = JSON.parse msg_in
  @responder = @responder || Responder.new
  str = @responder.respond_to_move move_data
  return str
end

# post '/legal-points' do
#   @game = @game || Game.new
#   msg_in = request.body.read
#   str = @game.handle_client_input(msg_in)
#   str
# end

class Responder

  def initialize
    @move = MoveProcessor.new
  end

  def respond_to_move(move_data)
    @move.make_move move_data
    return '{"resp": "**TEMP RESPONSE**"}'
  end

end


class MoveProcessor

  def make_move move_data
    puts "MoveProcessor#move_data"
    puts "   move_data = #{move_data.to_s}"
  end

end


# class Game
#
#   attr_accessor :board, :newgame, :analyzer, :legal_moves, :manager
#
#
#   def initialize
#     @newgame = "x"
#     @board = Board.new(self)
#     @analyzer = GroupAnalyzer.new(self)
#     @legal_moves = LegalMovesFinder.new(self)
#     @manager = GameplayManager.new(self)
#   end
#
#
#   def handle_client_input(msg_in)
#     return @manager.handle_client_input(msg_in)
#   end
#
#
# end
#
#
#
# class GameplayManager
#
#   COLORS = [:red, :white, :blue]
#
#   def initialize(game_object)
#     @game = game_object
#     @board = @game.board
#     @points_object = @board.points
#     @analyzer = @game.analyzer
#     @legal_moves = @game.legal_moves
#
#     @players = {}
#     @players[:red] = HumanPlayer.new(@game, :red)
#     @players[:white] = AiPlayer.new(@game, :white)
#     @players[:blue] = AiPlayer.new(@game, :blue)
#
#     @human_player = @players[:red]
#     @ai_players = [ @players[:white], @players[:blue] ]
#
#     @current_player = :red
#   end
#
#
#   def get_next_move(player)
#     move = @players[player].get_move
#     return move
#   end
#
#
#   def handle_client_input(input_string)
#     pt = JSON.parse(input_string)
#     @game.newgame = pt["new"]
#     point = pt["red"]
#     make_a_move(@human_player, point)
#     response = {}
#     @ai_players.each do |player|
#       color = player.color
#       point = get_next_move(color)
#       make_a_move(player,point)
#       response[color] = point
#     end
#     legal = @legal_moves.find_legal_moves(:red)
#     response[:red] = legal
#     str = response.to_json
#     return str
#   end
#
#
#   def make_a_move(player,point)
#     # puts " "
#     # puts "GamePlayManager#make_a_move"
#     # puts "   player = #{player.color}"
#     # puts "   point = #{point[0]}, #{point[1]}"
#     # puts
#     # puts "make_a_move()"
#     # puts "   points_object.size = #{@points_object.point_values.size}"
#     @points_object.set_point(point,player.color)
#     remove_dead_stones_after_move(player)
#   end
#
#
#   def remove_dead_stones_after_move(player)
#     opponents = [:red, :white, :blue]
#     opponents.delete(player)
#     opponents.each do |opp|
#       dead_groups = @analyzer.dead_groups?(opp)
#       # puts "dead groups = #{dead_groups.size}"
#       dead_groups.each do |grp|
#         @points_object.set_points(:empty, grp)
#       end
#     end
#   end
#
#
#   def whose_turn?
#     return @current_player
#   end
#
#
#   def next_player
#     case @current_player
#     when :red
#       @current_player = :white
#     when :white
#       @current_player = :blue
#     when :blue
#       @current_player = :red
#     end
#   end
#
#
# end
#
#
#
# class Player
#
#   attr_accessor :color
#
#   def initialize(game,color)
#     @game = game
#     @legal_moves = @game.legal_moves
#     @color = color
#   end
# end
#
#
#
# class HumanPlayer < Player
#
#   attr_accessor :client_move
#
#   # TODO set_client_move method to change @client_move after receiving remote input
#
#   def get_move
#     return get_remote_move
#   end
#
#
#   # def get_console_move
#   #   str = gets
#   #   return string_to_point(str)
#   # end
#
#
#   def get_remote_move
#     return string_to_point(client_move)
#   end
#
#
# end
#
#
#
# class AiPlayer < Player
#
#   # AI VERSION:  0.01
#
#   # Random selection from set of legal playable points. No additional heuristic.
#
#   def get_move
#     open = @legal_moves.find_legal_moves(@color)
#     move = open.sample
#     return move
#   end
#
#
# end
#
#
#
# class Board
#     # This class models the layout of the gameboard.
#     # (The positions of stones on the board are represented by an instance of
#     # the GameBoardPoints class.)
#
#   include Enumerable
#
#   attr_accessor :points, :game
#
#   ROW_START = [nil,1,1,1,1,1,1,2,3,4,5,6]
#   ROW_END = [nil,6,7,8,9,10,11,11,11,11,11,11]
#   MIN = 1
#   MAX = 11
#
#   def initialize(game)
#     # puts "INITIALIZE Board"
#     @game = game
#     # puts "      newgame = #{@game.newgame}"
#     @points = GameBoardPoints.new(@game)
#   end
#
#
#   def each
#     1.upto(MAX) do |i|
#       ROW_START[i].upto(ROW_END[i]) do |j|
#         pt = [i,j]
#         yield pt
#       end
#     end
#   end
#
#
#   def valid_point?(point)
#     valid = false
#
#     if point.class == Array && point.size == 2 && point.count {|p| p.class == Fixnum} == 2
#       a = point[0]
#       b = point[1]
#       if a>=MIN && a<= MAX
#         valid = true if b >= ROW_START[a] && b <= ROW_END[a]
#       end
#     end
#
#     return valid
#   end
#
#
#   def string_to_point(string)
#     point = []
#     if string.size == 2
#       string.each_char do |ch|
#         if ["1","2","3","4","5","6","7","8","9","a","b"].include?(ch)
#           point << ch.to_i(16)
#         end
#       end
#     end
#     return point
#   end
#
#
#   def adjacent?(pt1,pt2)
#     adj = true
#     adj = false if pt1.class != Array || pt2.class != Array
#     adj = false if pt1.size != 2 || pt2.size != 2
#     adj = false if [pt1,pt2].flatten.count {|z| z.class == Fixnum} != 4
#     adj = false if valid_point?(pt1) == false || valid_point?(pt2) == false
#
#     if adj == true
#       a1 = pt1[0]
#       b1 = pt1[1]
#       a2 = pt2[0]
#       b2 = pt2[1]
#       adj = false if (a1-a2).abs > 1 || (b1-b2).abs > 1
#       adj = false if (a1 == a2) && (b1 == b2)
#       adj = false if (a1 == a2+1) && (b1 == b2-1)
#       adj = false if (a1 == a2-1) && (b1 == b2+1)
#     end
#
#     return adj
#   end
#
#   def all_adjacent_points(p)
#     # Returns an array containing the set of adjacent valid points in
#     # clockwise order as follows: :right_up, :right, :right_dn, :left_dn,
#     # :left, :left_up
#
#     filter = [ [0,-1], [1,0], [1,1], [0,1], [-1,0], [-1,-1] ]
#     return get_adjacent_points(p,filter)
#   end
#
#
#   def all_previous_adjacent_points(p)
#     # Returns an array containing the set of adjacent valid points which
#     # are returned before the point p by the each method, in this order:
#     # :left_up, :right_up, :left
#
#     filter = [ [-1,-1], [0,-1], [-1,0] ]
#     return get_adjacent_points(p,filter)
#   end
#
#
#   def get_adjacent_points(p,filter)
#
#     points = []
#     if valid_point?(p)
#       a = p[0]
#       b = p[1]
#       for delta in filter
#         z = [ (a + delta[0]), (b + delta[1]) ]
#         points << z if valid_point?(z)
#       end
#     end
#     return points
#   end
#
#
# end
#
#
#
# class GameBoardPointSet
#   # A general purpose collection of values for each point on the game board.
#
#   attr_accessor :point_values, :bid
#
#   def initialize(game)
#     @game = game
#     @board = @game.board
#     @point_values = []
#   end
#
#
#   def get_point(point)
#     result = @point_values.find {|pt| pt[:point] == point }
#     if result == nil
#       val = :empty
#     else
#       val = result[:value]
#     end
#     return val
#   end
#
#
#   def set_point(point,value)
#     # puts " "
#     # puts "GameBoardPointSet.set_point()"
#     # puts "   point: #{point[0]},#{point[1]}"
#     # puts "   value: #{value}"
#     # puts "   before: point_values.size = #{@point_values.size}"
#     if value == :empty
#       @point_values.delete_if {|pt| pt[:point] == point }
#     else
#       zz = @point_values.find {|pt| pt[:point] == point }
#       if zz != nil
#         zz[:value] = value
#       else
#         @point_values << {point: point, value: value}
#       end
#     end
#     # puts "  after (GameBoardPointSet):  point_values.size = #{@point_values.size}"
#   end
#
#
#   def set_points(value, points_array)
#     points_array.each {|pt| set_point(pt,value)}
#   end
#
#
#   def neighbors_with_value(point,value)
#     nbrs = @board.all_adjacent_points(point)
#     nbv = nbrs.find_all {|pt| get_point(pt) == value }
#     return nbv
#   end
#
#
# end
#
#
#
# class GameBoardPoints < GameBoardPointSet
#   # An extension of GameBoardPointSet to hold the values of the stones played
#   # on the gameboard points.
#
#   def initialize(game)
#     # puts "NEW GameBoardPoints"
#     super(game)
#     @bid = "gameboard"
#     # puts "      newgame = #{@game.newgame}"
#     @persist = GamePersist.new
#     @persist.save_data( [] ) if @game.newgame == "yes"
#   end
#
#
#   def set_point(point,value)
#     # puts " "
#     # puts "GameBoardPoints.set_point()"
#     # puts "   point: #{point[0]},#{point[1]}"
#     # puts "   value: #{value}"
#     # puts "   before reload: point_values.size = #{@point_values.size}"
#     @reload
#     # puts "  after reload:  point_values.size = #{@point_values.size}"
#     super(point, value)
#     # puts "  after super():  point_values.size = #{@point_values.size}"
#     @persist.save_data(@point_values)
#   end
#
#
#   def get_point(point)
#     @reload
#     val = super(point)
#     return val
#   end
#
#
#   def reload
#     # puts "CALL reload()"
#     @point_values = @persist.read_data
#     # puts "END reload()"
#   end
#
#
# end
#
#
#
# class GamePersist
#
#   def initialize
#     @filename = "game.json"
#   end
#
#
#   def read_data
#     # puts " "
#     # puts "GamePersist#read_data()"
#     str = File.read(@filename)
#     # puts "   str = #{str}"
#     jsn = JSON.parse(str)
#     # puts "   jsn = #{jsn}"
#     points_array = jsn["stones"]
#     # puts "   points_array ="
#     # points_array.each {|pt| puts "     #{pt[0]}, #{pt[1]}" }
#     return points_array
#   end
#
#
#   def save_data(data)
#     # puts "CALL save_data  data.size = #{data.size}"
#     File.open(@filename, "w") do |f|
#       pts = {stones: data}
#       f.puts pts.to_json
#     end
#   end
#
# end
#
#
#
# class LegalMovesFinder
#     # A class to find the set of all legal moves for a player
#
#   def initialize(game_object)
#     @game = game_object
#     @board = @game.board
#     @points = @board.points
#     @analyzer = @game.analyzer
#     @group_points = @analyzer.group_points
#   end
#
#
#   def find_legal_moves(player_color)
#     # puts " "
#     # puts "find_legal_moves()"
#     # puts "   before reload: points.size = #{@points.point_values.size}"
#     @points.reload
#     # puts "   after reload: points.size = #{@points.point_values.size}"
#     not_legal = []
#
#     groups = @analyzer.find_all_groups
#     eyes = @analyzer.find_empty_points_for_groups(groups)
#
#     one_eye_groups = []
#
#     g1 = eyes.find_all {|gp| gp[:color] == player_color && gp[:eyes].size == 1 }
#     g1.each do |gp|
#       nbrs = @board.all_adjacent_points(gp[:eyes][0])
#       one_eye_groups << gp unless nbrs.find {|pt| @points.get_point(pt) == :empty }
#     end
#
#     one_eye_groups.each do |gp|
#       point = gp[:eyes][0]
#       g_share = eyes.find_all {|gpx| gpx[:eyes].include?(point) }
#       if g_share.find {|gpz| gpz[:color] == player_color && gpz[:eyes].size > 1 }
#         legal = true
#       elsif g_share.find {|gpz| gpz[:color] != player_color && gpz[:eyes].size == 1 }
#         legal = true
#       else
#         legal = false
#       end
#       not_legal << point if legal == false
#     end
#
#     single_eyes = @analyzer.find_one_eye_points
#     other_color_one_eyes = []
#     single_eyes.each do |eye|
#       other_color_one_eyes << eye if @points.neighbors_with_value(eye,player_color) == []
#     end
#
#     other_color_one_eyes.each do |eye|
#       nbr_grps = @analyzer.find_other_color_neighbor_groups(eye,player_color)
#       not_legal << eye unless nbr_grps.find {|grp| @analyzer.find_group_airpoints(grp[:stones]).size == 1 }
#     end
#
#     moves = @board.find_all {|point| @points.get_point(point) == :empty} - not_legal
#
#     return moves
#   end
#
# end
#
#
#
# class GroupAnalyzer
#     # Provides analysis of groups of stones
#
#   attr_accessor :group_points
#
#   def initialize(game_object)
#     @game = game_object
#     @board = @game.board
#     @points = @board.points
#
#     @group_points = GameBoardPointSet.new(@game)
#     @group_points.bid = "groups"
#   end
#
#
#   def find_all_groups
#     groups = {red: [], white: [], blue: []}
#
#     @board.each do |point|
#       if @points.get_point(point) != :empty
#         color = @points.get_point(point)
#
#         neighbor_groups = find_prior_same_color_neighbor_groups(point,color)
#
#         if neighbor_groups.size == 0
#           group = make_new_group(groups, color)
#           gid = group[:id]
#         else
#           gid = neighbor_groups[0][:id]
#           group = {color: color, id: gid}
#         end
#
#         if neighbor_groups.size > 1
#           old_id = neighbor_groups[1][:id]
#           groups[color][gid].concat( groups[color][old_id] )
#           groups[color][old_id] = nil
#           neighbor_groups[1][:stones].each {|pt| @group_points.set_point(pt,group) }
#         end
#
#         groups[color][gid] << point
#         @group_points.set_point(point,group)
#       end
#     end
#
#     [:red, :white, :blue].each {|color| groups[color].compact! }
#     return groups
#   end
#
#
#   def dead_groups?(color)
#     dead_groups = []
#
#     groups = find_all_groups
#     own_groups = groups[color]
#
#     own_groups.each do |grp|
#       eyes = find_group_airpoints(grp)
#       dead_groups << grp if eyes == []
#     end
#
#     return dead_groups
#   end
#
#
#   def find_one_eye_points
#     one_eye_points = []
#     empty_points = @board.find_all {|pt| @points.get_point(pt) == :empty }
#     empty_points.each do |point|
#       nbrs = @board.all_adjacent_points(point)
#       empty_nbrs = nbrs.find {|pt| @points.get_point(pt) == :empty }
#       one_eye_points << point if empty_nbrs == nil
#     end
#     return one_eye_points
#   end
#
#
#   def find_prior_same_color_neighbor_groups(point,color)
#     find_neighbor_groups(point, color, :previous)
#   end
#
#
#   def find_other_color_neighbor_groups(point,first_color)
#     oc_nbrs = []
#     others = [:red, :white, :blue] - [first_color]
#     others.each do |color|
#       nb = find_neighbor_groups(point, color, :all)
#       nb.each do |grp|
#         grp[:color] = color
#         oc_nbrs << grp
#       end
#     end
#     return oc_nbrs
#   end
#
#
#   def find_neighbor_groups(point,color,search_type)
#     neighbor_groups = []
#     group_ids = []
#
#     if search_type == :previous
#       search_vector = @board.all_previous_adjacent_points(point)
#     elsif search_type == :all
#       search_vector = @board.all_adjacent_points(point)
#     else
#       search_vector = []
#     end
#
#     amigos = []
#     for nb in search_vector
#       amigos << nb if @points.get_point(nb) == color
#     end
#
#     amigos.each do |pt|
#       grp_id = @group_points.get_point(pt)[:id]
#       group_ids << grp_id if not group_ids.include?(grp_id)
#     end
#
#     group_ids.each do |id|
#       stones = get_group_stones(color, id)
#       grp = {id: id, stones: stones}
#       neighbor_groups << grp
#     end
#
#     return neighbor_groups
#   end
#
#
#   def get_group_stones(color, id)
#     return @board.find_all {|point| @group_points.get_point(point) == {color: color, id: id} }
#   end
#
#
#   def find_empty_points_for_groups(groups)
#     empty_points = []
#
#     [:red, :white, :blue].each do |color|
#       groups[color].each do |group|
#         eyes = find_group_airpoints(group)
#         empty_points << {color: color, eyes: eyes, points: group}
#       end
#     end
#
#     return empty_points
#   end
#
#
#   def make_new_group(groups, color)
#     i = groups[color].size
#     groups[color][i] = []
#     group = {color: color, id: i}
#     return group
#   end
#
#
#   def find_group_airpoints(group)
#     air = []
#     for stone in group
#       air << @board.all_adjacent_points(stone).find_all {|pt| @board.points.get_point(pt) == :empty}
#     end
#     air.flatten!(1).uniq!
#     return air
#   end
#
# end
