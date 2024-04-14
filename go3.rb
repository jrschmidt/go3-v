require 'rubygems'

require 'sinatra'

require 'json'

set :server, %w[webrick thin mongrel]

set :port, 4533

get '/' do
  erb :index
end

post '/make-a-move' do
  msg_in = request.body.read
  request_data = JSON.parse msg_in, :symbolize_names => true
  @move_processor = MoveProcessor.new
  str = @move_processor.process_client_move request_data
  return str
end


class MoveProcessor

  attr_accessor :stones, :analyzer # (needed so tests can reset these attributes)

  def process_client_move(request_data)
    @stones = Stones.new request_data[:stones]
    @board = BoardSpecs.new
    @analyzer = GroupAnalyzer.new(@stones, @board)
    @legal_moves = LegalMovesFinder.new(@stones, @board, @analyzer)
    @ai_players = AIPlayers.new(@legal_moves, @stones)
    @reset = :no
    red_move = request_data[:red_move]
    make_move :red, red_move
    white_move = @ai_players.get_move :white
    make_move :white, white_move
    blue_move = @ai_players.get_move :blue
    make_move :blue, blue_move
    legal_red_moves = @legal_moves.find_legal_moves :red, @stones
    stones = @stones.values
    return build_response stones, white_move, blue_move, legal_red_moves
  end

  def make_move(color, point)
    @stones.place_stone color, point
    remove_dead_stones_after_move(color)
  end

  def remove_dead_stones_after_move(color)
    dead_stones = []
    opponents = [:red, :white, :blue]
    opponents.delete(color)
    opponents.each do |opp|
      dead_groups = @analyzer.dead_groups?(opp)
      if dead_groups.size > 0
        dead_groups.each {|grp| grp.each {|pt| dead_stones << pt} }
      end
    end
    if dead_stones.size > 0
      @reset = :yes
      dead_stones.each {|pt| @stones.set_point(pt, :empty)}
    end
  end

  def build_response(stones, white, blue, legal_red)
    response = {
      stones: @stones.get_json,
      white_move: white,
      blue_move: blue,
      legal_red_moves: legal_red }
    return response.to_json
  end

end


class PointSet
  # A general purpose collection of values for each point on the game board.

  def initialize
    @values = []
  end

  def get_point(point)
    result = @values.find {|pt| pt[:point] == point }
    if result == nil
      val = :empty
    else
      val = result[:value]
    end
    return val
  end

  def set_point(point,value)
    if value == :empty
      @values.delete_if {|pt| pt[:point] == point }
    else
      zz = @values.find {|pt| pt[:point] == point }
      if zz != nil
        zz[:value] = value
      else
        @values << {point: point, value: value}
      end
    end
  end

  def set_points(value, points_array)
    points_array.each {|pt| set_point(pt,value)}
  end

end


class Stones < PointSet

  attr_accessor :values

  def initialize(stones)
      @values = []
      [:red, :white, :blue].each do |color|
        stones[color].each do |point|
          @values << {point: point, value: color}
        end
      end
  end

  def place_stone(color, point)
    set_point point, color
  end

  def get_json
    rwb = {red: [], white: [], blue: []}
    @values.each {|pt| rwb[pt[:value]] << pt[:point]}
    return rwb.to_json
  end

end


class AIPlayers
  # AI VERSION:  0.1
  # Random selection from set of legal playable points. No additional heuristic.

  def initialize(legal_moves, stones)
    @legal_moves = legal_moves
    @stones = stones
  end

  def get_move(color)
    open = @legal_moves.find_legal_moves color, @stones
    point = open.sample
    return point
  end

end


class BoardSpecs
    # This class models the layout of the gameboard.
    # (The positions of stones on the board are represented by an instance of
    # the GameBoardPoints class.)

  include Enumerable

  ROW_START = [nil,1,1,1,1,1,1,2,3,4,5,6]
  ROW_END = [nil,6,7,8,9,10,11,11,11,11,11,11]
  MIN = 1
  MAX = 11

  def each
    1.upto(MAX) do |i|
      ROW_START[i].upto(ROW_END[i]) do |j|
        pt = [i,j]
        yield pt
      end
    end
  end

  def valid_point?(point)
    valid = false
    if point.class == Array && point.size == 2 && point.count {|p| p.class == Fixnum} == 2
      a = point[0]
      b = point[1]
      if a>=MIN && a<= MAX
        valid = true if b >= ROW_START[a] && b <= ROW_END[a]
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
    # :left_up, :right_up, :left

    filter = [ [-1,-1], [0,-1], [-1,0] ]
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


class LegalMovesFinder
  # A class to find the set of all legal moves for a player

  def initialize(stones, board, analyzer)
    @stones = stones
    @board = board
    @analyzer = analyzer
  end

  def find_legal_moves(player_color, stones)
    not_legal = []

    groups = @analyzer.find_all_groups
    eyes = @analyzer.find_empty_points_for_groups(groups)

    one_eye_groups = []

    g1 = eyes.find_all {|gp| gp[:color] == player_color && gp[:eyes].size == 1 }
    g1.each do |gp|
      nbrs = @board.all_adjacent_points(gp[:eyes][0])
      one_eye_groups << gp unless nbrs.find {|pt| @stones.get_point(pt) == :empty }
    end

    one_eye_groups.each do |gp|
      point = gp[:eyes][0]
      g_share = eyes.find_all {|gpx| gpx[:eyes].include?(point) }
      if g_share.find {|gpz| gpz[:color] == player_color && gpz[:eyes].size > 1 }
        legal = true
      elsif g_share.find {|gpz| gpz[:color] != player_color && gpz[:eyes].size == 1 }
        legal = true
      else
        legal = false
      end
      not_legal << point if legal == false
    end

    single_eyes = @analyzer.find_one_eye_points
    other_color_one_eyes = []
    single_eyes.each do |eye|
      nbrs = @board.all_adjacent_points(eye)
      nbv = nbrs.find_all {|pt| @stones.get_point(pt) == player_color}
      other_color_one_eyes << eye if nbv.size == 0
    end

    other_color_one_eyes.each do |eye|
      nbr_grps = @analyzer.find_other_color_neighbor_groups(eye,player_color)
      not_legal << eye unless nbr_grps.find {|grp| @analyzer.find_group_airpoints(grp[:stones]).size == 1 }
    end

    all_empties = @board.find_all {|point| stones.get_point(point) == :empty}
    moves = all_empties - not_legal

    return moves
  end

  def no_neighbors_with_value(point, value)
    nbrs = @board.all_adjacent_points(point)
    nbv = nbrs.find_all {|pt| @stones.get_point(pt) == value }
    q = (nbv.size == 0)
    return q
  end

  def neighbors_with_value(point,value)
    nbrs = @board.all_adjacent_points(point)
    nbv = nbrs.find_all {|pt| @stones.get_point(pt) == value }
    return nbv
  end

end


class GroupAnalyzer
    # Provides analysis of groups of stones

  attr_accessor :group_points

  def initialize(stones, board)
    @stones = stones
    @board = board
    @group_points = PointSet.new
  end

  def find_all_groups
    groups = {red: [], white: [], blue: []}

    @board.each do |point|
      if @stones.get_point(point) != :empty
        color = @stones.get_point(point)

        neighbor_groups = find_prior_same_color_neighbor_groups(point,color)

        if neighbor_groups.size == 0
          group = make_new_group(groups, color)
          gid = group[:id]
        else
          gid = neighbor_groups[0][:id]
          group = {color: color, id: gid}
        end

        if neighbor_groups.size > 1
          old_id = neighbor_groups[1][:id]
          groups[color][gid].concat( groups[color][old_id] )
          groups[color][old_id] = nil
          neighbor_groups[1][:stones].each {|pt| @group_points.set_point(pt,group) }
        end

        groups[color][gid] << point
        @group_points.set_point(point,group)
      end
    end

    [:red, :white, :blue].each {|color| groups[color].compact! }
    return groups
  end

  def dead_groups?(color)
    dead_groups = []

    groups = find_all_groups
    own_groups = groups[color]

    own_groups.each do |grp|
      eyes = find_group_airpoints(grp)
      dead_groups << grp if eyes == []
    end

    return dead_groups
  end

  def find_one_eye_points
    one_eye_points = []
    empty_points = @board.find_all {|pt| @stones.get_point(pt) == :empty }
    empty_points.each do |point|
      nbrs = @board.all_adjacent_points(point)
      empty_nbrs = nbrs.find {|pt| @stones.get_point(pt) == :empty }
      one_eye_points << point if empty_nbrs == nil
    end
    return one_eye_points
  end

  def find_prior_same_color_neighbor_groups(point,color)
    find_neighbor_groups(point, color, :previous)
  end

  def find_other_color_neighbor_groups(point,first_color)
    oc_nbrs = []
    others = [:red, :white, :blue] - [first_color]
    others.each do |color|
      nb = find_neighbor_groups(point, color, :all)
      nb.each do |grp|
        grp[:color] = color
        oc_nbrs << grp
      end
    end
    return oc_nbrs
  end

  def find_neighbor_groups(point,color,search_type)
    neighbor_groups = []
    group_ids = []

    if search_type == :previous
      search_vector = @board.all_previous_adjacent_points(point)
    elsif search_type == :all
      search_vector = @board.all_adjacent_points(point)
    else
      search_vector = []
    end

    amigos = []
    for nb in search_vector
      amigos << nb if @stones.get_point(nb) == color
    end

    amigos.each do |pt|
      grp_id = @group_points.get_point(pt)[:id]
      group_ids << grp_id if not group_ids.include?(grp_id)
    end

    group_ids.each do |id|
      stones = get_group_stones(color, id)
      grp = {id: id, stones: stones}
      neighbor_groups << grp
    end

    return neighbor_groups
  end

  def get_group_stones(color, id)
    return @board.find_all {|point| @group_points.get_point(point) == {color: color, id: id} }
  end

  def find_empty_points_for_groups(groups)
    empty_points = []
    [:red, :white, :blue].each do |color|
      groups[color].each do |group|
        eyes = find_group_airpoints(group)
        empty_points << {color: color, eyes: eyes, points: group}
      end
    end
    return empty_points
  end

  def make_new_group(groups, color)
    i = groups[color].size
    groups[color][i] = []
    group = {color: color, id: i}
    return group
  end

  def find_group_airpoints(group)
    air = []
    for stone in group
      air << @board.all_adjacent_points(stone).find_all {|pt| @stones.get_point(pt) == :empty}
    end
    air.flatten!(1).uniq!
    return air
  end

end
