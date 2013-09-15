#
#   * *  Go3 3-player hex shaped Go game client * *
#
#  This application uses a "very thin client" approach. The coffeescript client
#  script only does three things: draw the board on a canvas element, send the
#  game point clicked to the server if user clicks on a legal move, and receive
#  from the server a new set of legal moves.


class Zipper

  constructor: () ->
    @board_specs = new BoardDimensions()
    @board = new Board(this)
    @lpp = new LegalPlayablePoints(this)
    @clickster = new ClickHandler(@lpp,@board.drawing_object)


  click: (x,y) ->
    @clickster.click_handle(x,y)



class BoardDimensions

# FIXME : NEEDS "+1" FIX !!!
  constructor: () ->
    @row_start = [0,0,0,0,0,0,1,2,3,4,5]
    @row_end = [5,6,7,8,9,10,10,10,10,10,10]



class Board

  constructor: (main_object) ->
    @controller = main_object
    @get_board_constants()
    @drawing_object = new GameCanvas(this)


  get_board_constants: () ->
    @row_start = @controller.board_specs.row_start
    @row_end = @controller.board_specs.row_end

# FIXME : NEEDS "+1" FIX !!!
    @w_e = [ [[0,0], [5,0]],
            [[0,1], [6,1]],
            [[0,2], [7,2]],
            [[0,3], [8,3]],
            [[0,4], [9,4]],
            [[0,5], [10,5]],
            [[1,6], [10,6]],
            [[2,7], [10,7]],
            [[3,8], [10,8]],
            [[4,9], [10,9]],
            [[5,10], [10,10]] ]

# FIXME : NEEDS "+1" FIX !!!
    @sw_ne = [ [[0,5], [0,0]],
              [[1,6], [1,0]],
              [[2,7], [2,0]],
              [[3,8], [3,0]],
              [[4,9], [4,0]],
              [[5,10], [5,0]],
              [[6,10], [6,1]],
              [[7,10], [7,2]],
              [[8,10], [8,3]],
              [[9,10], [9,4]],
              [[10,10], [10,5]] ]

# FIXME : NEEDS "+1" FIX !!!
    @nw_se = [ [[0,5], [5,10]],
              [[0,4], [6,10]],
              [[0,3], [7,10]],
              [[0,2], [8,10]],
              [[0,1], [9,10]],
              [[0,0], [10,10]],
              [[1,0], [10,9]],
              [[2,0], [10,8]],
              [[3,0], [10,7]],
              [[4,0], [10,6]],
              [[5,0], [10,5]] ]



class LegalPlayablePoints

  constructor: (main_object) ->
    @board = main_object.board
    @board_specs = main_object.board_specs
    @points = @get_init_legal_moves()


# FIXME : NEEDS "+1" FIX !!!
  get_init_legal_moves: () ->
    points = []
    for i in [0..@board_specs.row_start.length]
      for j in [@board_specs.row_start[i]..@board_specs.row_end[i]]
        pp = {}
        pp.a = i
        pp.b = j
        points.push(pp)
    return points


  legal_move: (point) ->
    point_in = @points.some (p) -> p.a == point[0] and p.b == point[1]
#    alert("legal_move = "+point_in)
    return point_in


  update_legal_moves: (points_string) ->
    @points = @parse_points(points_string)


  parse_points: (points_string) ->
    points = []
    for p in [0..points_string.length/2-1]
      z = {}
      z.a = parseInt("0x"+points_string[p*2])
      z.b = parseInt("0x"+points_string[p*2+1])
      points.push(z)
    return points


class ClickHandler

  constructor: (legal_moves_object,canvas_object) ->
    @lmo = legal_moves_object
    @canvas_object = canvas_object


  click_handle: (x,y) ->
    point = @canvas_object.get_point(x,y)
    alert("point = "+point)
    if @lmo.legal_move(point)
      alert("legal move")
      @canvas_object.draw_stone(point,"R")
      msg_out = String(point)
      @connection = new ServerConnection()
      @connection.send(msg_out)
      msg_in = @connection.receive()
      @update_legal_moves(msg_in)
      alert (msg_in)


  update_legal_moves: (msg) ->
    @lmo.update_legal_moves(msg)


class ServerConnection

  constructor: () ->
    @xhr = new XMLHttpRequest()
    url = "/legal-points"
    @xhr.open('GET',url)

  send: () ->
     @xhr.send()


  receive: () ->
    alert ("ready state = "+@xhr.readyState)
    msg = @xhr.responseText
    return msg



class GameCanvas

  constructor: (board) ->
    @canvas = document.getElementById('canvas')
    @context = @canvas.getContext('2d')
    @board = board
    @board_base = new BoardBase(this)
    @board_lines = new BoardLines(this)


# FIXME : NEEDS "+1" FIX !!!
  get_x: (ab) ->
    return 175 + 50*ab[0] - 25*ab[1]


# FIXME : NEEDS "+1" FIX !!!
  get_y: (ab) ->
    return 50 + 44*ab[1]


# FIXME : NEEDS "+1" FIX !!!
  get_point: (x,y) ->
    point = []
    a = -1
    b = -1
    r2 = 999
    in_bounds = true
    b = Math.floor((y-28)/44)
    a = Math.floor((x-150+25*b)/50)
    in_bounds = false if b<0
    in_bounds = false if b>10
    in_bounds = false if a<@board.row_start[b]
    in_bounds = false if a>@board.row_end[b]
    dx = Math.abs(x-@get_x([a,b]))
    dy = Math.abs(y-@.get_y([a,b]))
    r2 = dx*dx+dy*dy
    in_bounds = false if r2>530 #(if radius > 23)
    point = [a,b] if (in_bounds == true)
    return point


# FIXME : NEEDS "+1" FIX !!!
  draw_stone: (ab,color) ->
    @context.strokeStyle = "#000000"
    @context.lineWidth = 2
    @context.fillStyle = @get_rgb(color)
    @context.beginPath()
    @context.arc(@get_x(ab),@get_y(ab),17,0,2*Math.PI,false)
    @context.fill()
    @context.stroke()
    @context.closePath()
    @context.beginPath()
    @context.strokeStyle = "#cc9933"
    @context.arc(@get_x(ab),@get_y(ab),19,0,2*Math.PI,false)
    @context.stroke()
    @context.closePath()


  get_rgb: (color) ->
    switch color
      when "R"
        clr = "#cc3333"
      when "W"
        clr = "#f0f0f0"
      when "B"
        clr = "#5050cc"
    return clr


# FIXME : NEEDS "+1" FIX !!!
  remove_stone: (ab) ->
    xx = @get_x(ab)
    yy = @get_y(ab)
    @context.beginPath()
    @context.fillStyle = "#cc9933"
    @context.arc(xx,yy,19,0,2*Math.PI,false)
    @context.fill()
    @context.closePath()
    @context.beginPath()
    @context.strokeStyle = "#000000"
    @context.lineWidth = 3
    @context.moveTo(xx-11,yy-19)
    @context.lineTo(xx+11,yy+19)
    @context.stroke()
    @context.moveTo(xx+11,yy-19)
    @context.lineTo(xx-11,yy+19)
    @context.stroke()
    @context.moveTo(xx-20,yy)
    @context.lineTo(xx+20,yy)
    @context.stroke()
    @context.closePath()



class BoardBase

  constructor: (board_canvas) ->
    @b_canvas = board_canvas
    @board = @b_canvas.board
    @draw_base()


  draw_base: () ->
    canvas = document.getElementById('canvas')
    @context = canvas.getContext('2d')
    @draw_base_hex()
    @draw_base_margin()


  draw_base_hex: () ->
    @context.strokeStyle = "#000000"
    @context.lineWidth = 5
    @context.fillStyle = "#cc9933"
    @context.beginPath()
    @context.moveTo(157,26)
    @context.lineTo(443,26)
    @context.lineTo(576,270)
    @context.lineTo(443,514)
    @context.lineTo(157,514)
    @context.lineTo(25,270)
    @context.lineTo(157,26)
    @context.fill()
    @context.stroke()
    @context.closePath()


  draw_base_margin: () ->
    @context.strokeStyle = "#000000"
    @context.lineWidth = 3
    @context.beginPath()
    @context.moveTo(163,34)
    @context.lineTo(437,34)
    @context.lineTo(567,270)
    @context.lineTo(437,506)
    @context.lineTo(163,506)
    @context.lineTo(33,270)
    @context.lineTo(163,34)
    @context.stroke()
    @context.closePath()



class BoardLines

  constructor: (board_canvas) ->
    @b_canvas = board_canvas
    @board = @b_canvas.board
    @draw_lines()

  draw_lines: () ->
    @draw_w_e_lines()
    @draw_sw_ne_lines()
    @draw_nw_se_lines()


# FIXME : NEEDS "+1" FIX !!!
  draw_w_e_lines: () ->
    @draw_line(@board.w_e[i][0], @board.w_e[i][1]) for i in [0..10]


# FIXME : NEEDS "+1" FIX !!!
  draw_sw_ne_lines: () ->
    @draw_line(@board.sw_ne[i][0],@board.sw_ne[i][1]) for i in [0..10]


# FIXME : NEEDS "+1" FIX !!!
  draw_nw_se_lines: () ->
    @draw_line(@board.nw_se[i][0],@board.nw_se[i][1]) for i in [0..10]


  draw_line: (beg,end) ->
    canvas = document.getElementById('canvas')
    context = canvas.getContext('2d')
    context.strokeStyle = "#000000"
    context.lineWidth = 3
    context.beginPath()
    context.moveTo(@b_canvas.get_x(beg),@b_canvas.get_y(beg))
    context.lineTo(@b_canvas.get_x(end),@b_canvas.get_y(end))
    context.stroke()
    context.closePath()


mousedown = (e) ->
  @canvas = document.getElementById('canvas')
  dx = @canvas.offsetLeft
  dy = @canvas.offsetTop
  px = e.pageX
  py = e.pageY
  x = px-dx
  y = py-dy
  @zip.click(x,y)


start = () ->
  @zip = new Zipper()


window.onload = start



