class Board

  constructor: () ->
    @drawing_object = new GameCanvas(this)
    @row_start = [0,0,0,0,0,0,1,2,3,4,5]
    @row_end = [5,6,7,8,9,10,10,10,10,10,10]
    @points = []
    for rr in [0..10]
      row = []
      for ss in [@row_start[rr]..@row_end[rr]]
        row[ss] = 0
      @points[rr] = row


  get_stone: (a,b,color) ->
    return st


  put_stone: (a,b,color) ->


  clear_point: (a,b) ->



class GameCanvas

  constructor: (board) ->
    @canvas = document.getElementById('canvas')
    @context = @canvas.getContext('2d')
    @board = board

    @draw_base()
    @draw_lines()

    @draw_stone([3,3],"R")
    @draw_stone([7,6],"W")
    @draw_stone([6,9],"B")


  draw_base: () ->
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


  draw_lines: () ->
    @draw_w_e_lines()
    @draw_sw_ne_lines()
    @draw_nw_se_lines()


  draw_w_e_lines: () ->
    w = [[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[1,6],[2,7],[3,8],[4,9],[5,10]]
    e = [[5,0],[6,1],[7,2],[8,3],[9,4],[10,5],[10,6],[10,7],[10,8],[10,9],[10,10]]
    @draw_line(w[i],e[i]) for i in [0..10]


  draw_sw_ne_lines: () ->
    sw = [[0,5],[1,6],[2,7],[3,8],[4,9],[5,10],[6,10],[7,10],[8,10],[9,10],[10,10]]
    ne = [[0,0],[1,0],[2,0],[3,0],[4,0],[5,0],[6,1],[7,2],[8,3],[9,4],[10,5]]
    @draw_line(sw[i],ne[i]) for i in [0..10]


  draw_nw_se_lines: () ->
    nw = [[0,5],[0,4],[0,3],[0,2],[0,1],[0,0],[1,0],[2,0],[3,0],[4,0],[5,0]]
    se = [[5,10],[6,10],[7,10],[8,10],[9,10],[10,10],[10,9],[10,8],[10,7],[10,6],[10,5]]
    @draw_line(nw[i],se[i]) for i in [0..10]


  draw_line: (beg,end) ->
    @context.strokeStyle = "#000000"
    @context.lineWidth = 3
    @context.beginPath()
    @context.moveTo(@get_x(beg),@get_y(beg))
    @context.lineTo(@get_x(end),@get_y(end))
    @context.stroke()
    @context.closePath()


  get_x: (ab) ->
    return 175 + 50*ab[0] - 25*ab[1]


  get_y: (ab) ->
    return 50 + 44*ab[1]


  draw_stone: (ab,color) ->
    @context.strokeStyle = "#000000"
    @context.lineWidth = 2
    @context.fillStyle = @get_rgb(color)
    @context.beginPath()
    @context.arc(@get_x(ab),@get_y(ab),17,0,2*Math.PI,false)
    @context.fill()
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


  remove_stone: (a,b) ->



start = () ->
  @board = new Board()
  @canvas = document.getElementById('canvas')
  @context = @canvas.getContext('2d')


window.onload = start



