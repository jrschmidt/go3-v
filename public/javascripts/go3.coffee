class Zipper

  constructor: () ->
    @bb = new Board()
    @clickster = new ClickHandler(@bb,@bb.drawing_object,@connection)


  click: (x,y) ->
    @clickster.click_handle(x,y)


class Board

  constructor: () ->
    @get_board_constants()
    @drawing_object = new GameCanvas(this)
    @points = []
    for rr in [0..10]
      row = []
      for ss in [@row_start[rr]..@row_end[rr]]
        row[ss] = 0
      @points[rr] = row


  get_board_constants: () ->
    @row_start = [0,0,0,0,0,0,1,2,3,4,5]
    @row_end = [5,6,7,8,9,10,10,10,10,10,10]

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

# FIXME Only fire XHR if click is a gameboard point
# TODO  Complete this method
  legal_move: (point) ->
    return true


  click: (x,y) ->
    alert("CLICK!!!! "+x+" , "+y)


  get_stone: (a,b,color) ->
    return st


  put_stone: (a,b,color) ->


  clear_point: (a,b) ->



class ClickHandler

  constructor: (game,canvas_object,connection) ->
    @game = game
    @canvas_object = canvas_object


  click_handle: (x,y) ->
    point = @canvas_object.get_point(x,y)
    if @game.legal_move(point)
      @canvas_object.draw_stone(point,"R")
      msg = String(point)
      @connection = new ServerConnection(msg)
      @connection.send()
      @connection.receive()


class ServerConnection

  constructor: (msg) ->
    @xhr = new XMLHttpRequest()
    url = "/hxr-source?msg="+msg
    @xhr.open('GET',url)

  send: () ->
     @xhr.send()


  receive: () ->
    alert ("ready state = "+@xhr.readyState)
    alert ("RESPONSE: "+@xhr.responseText)



class GameCanvas

  constructor: (board) ->
    @canvas = document.getElementById('canvas')
    @context = @canvas.getContext('2d')
    @board = board
    @board_base = new BoardBase(this)
    @board_lines = new BoardLines(this)

    @draw_stone([3,3],"R")
    @draw_stone([7,6],"W")
    @draw_stone([6,9],"B")


  get_x: (ab) ->
    return 175 + 50*ab[0] - 25*ab[1]


  get_y: (ab) ->
    return 50 + 44*ab[1]


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


  draw_w_e_lines: () ->
    @draw_line(@board.w_e[i][0], @board.w_e[i][1]) for i in [0..10]


  draw_sw_ne_lines: () ->
    @draw_line(@board.sw_ne[i][0],@board.sw_ne[i][1]) for i in [0..10]


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



