//   * *  Go3  * *
//
//   3-player hexagonal Go game client
//
//   JR Schmidt
//   2024 version (rewrite of legacy Coffeescript version)


// A client for the Go3 Ruby project, an experimental 3-player hexagonal Go game. The
// client script only does three things: draw the board on a canvas element, send the
// game point clicked to the server if user clicks on a legal move, and receive
// from the server a new set of legal moves along with randomly generated moves for
// the other two players.

// This is a rewrite of a project developed 2013 - 2015, with the client code developed
// in Coffeescript. The main change is, since I now wish to deploy this app as a
// serverless edge function on Vercel, game state between moves will now be persisted
// client side. Also, the client code will be rewritten in modern Javascript, using the
// original Coffeescript code as a template.

// The code is written using the `class` syntax because it was written when classes and
// object oriented programming were popular. Coffescript incorporated the `class`
// construct before it was added to javascript in ES6.


class BoardStats {
  
  constructor () {
    this.rowStart = [1,1,1,1,1,1,2,3,4,5,6]
    this.rowEnd = [6,7,8,9,10,11,11,11,11,11,11]
    
    this.westToEast = [
      [[1,1], [6,1]],
      [[1,2], [7,2]],
      [[1,3], [8,3]],
      [[1,4], [9,4]],
      [[1,5], [10,5]],
      [[1,6], [11,6]],
      [[2,7], [11,7]],
      [[3,8], [11,8]],
      [[4,9], [11,9]],
      [[5,10], [11,10]],
      [[6,11], [11,11]]
    ]
    
    this.southwestToNortheast = [
      [[1,6], [1,1]],
      [[2,7], [2,1]],
      [[3,8], [3,1]],
      [[4,9], [4,1]],
      [[5,10], [5,1]],
      [[6,11], [6,1]],
      [[7,11], [7,2]],
      [[8,11], [8,3]],
      [[9,11], [9,4]],
      [[10,11], [10,5]],
      [[11,11], [11,6]]
    ]
    
    this.northwestToSoutheast = [
      [[1,6], [6,11]],
      [[1,5], [7,11]],
      [[1,4], [8,11]],
      [[1,3], [9,11]],
      [[1,2], [10,11]],
      [[1,1], [11,11]],
      [[2,1], [11,10]],
      [[3,1], [11,9]],
      [[4,1], [11,8]],
      [[5,1], [11,7]],
      [[6,1], [11,6]]
    ]

  }
}
  
  
class CanvasHelper {

  constructor () {
    this.canvas = document.getElementById('go-board')
    this.context = this.canvas.getContext('2d')
    this.board = new BoardStats()
    this.boardBase = new BoardBase(this)
    this.boardLines = new BoardLines(this)
  }

  getX (ab) {
    return 150 + 50*ab[0] - 25*ab[1]
  }
  
  getY (ab) {
    return 6 + 44*ab[1]
  }
  
  getPoint (x,y) {
    // First, use rectangular coordinates to determine which gameboard point to
    // check, then use the radius from the pixel at the center of the gameboard point
    // to see if it's close enough to map the mouse click to that point. Return the 
    // gameboard coordinates of the point if it is valid, else return an empty array.
    
    let point = []
    let a = -1
    let b = -1
    let r2 = 999
    let inBounds = true

    b = Math.floor((y-28)/44)+1
    a = Math.floor((x-125+25*b)/50)
    if ( b<1 ) { inBounds = false }
    if ( b>11 ) { inBounds = false }
    if ( a<this.board.rowStart[b-1]) { inBounds = false }
    if ( a>this.board.rowEnd[b-1] ) { inBounds = false }

    let dx = Math.abs(x-this.getX([a,b]))
    let dy = Math.abs(y-this.getY([a,b]))
    r2 = dx*dx+dy*dy
    if  (r2>530 ) { inBounds = false }

    if ( inBounds ) { const point = [a,b] }
    return point
  }

  getRgb (color) {
    const colorCodes = {
      red: 'cc3333',
      white: 'f0f0f0',
      blue: '5050cc'
    }
    return colorCodes[color]
  }

  drawStone (ab, color) {
    this.context.strokeStyle = "#000000"
    this.context.lineWidth = 2
    this.context.fillStyle = this.getRgb(color)
    this.context.beginPath()
    this.context.arc(this.getX(ab),this.getY(ab),17,0,2*Math.PI,false)
    this.context.fill()
    this.context.stroke()
    this.context.closePath()
    this.context.beginPath()
    this.context.strokeStyle = "#cc9933"
    this.context.arc(this.getX(ab),this.getY(ab),19,0,2*Math.PI,false)
    this.context.stroke()
    this.context.closePath()
  }

  redraw (stones) {
    this.boardBase.drawBase()
    this.boardLines.drawLines()
    
    ['red', 'white', 'blue'].forEach((color) => {
      stones[color].forEach ((point) => {
        this.drawStone(point, color)
      })
    })
  }

}


// Can we eliminate bCanvas and just use boardCanvas? (also Boardlines class)
class BoardBase {

  constructor (boardCanvas) {
    this.bCanvas = boardCanvas
    this.board = this.bCanvas.board
    this.drawBase()
  }
  
  drawBase () {
    canvas = document.getElementById('go-board')
    this.context = canvas.getContext('2d')
    this.drawBaseHex()
    this.drawBaseMargin()
  }
  
  drawBaseHex () {
    this.context.strokeStyle = "#000000"
    this.context.lineWidth = 5
    this.context.fillStyle = "#cc9933"
    this.context.beginPath()
    this.context.moveTo(157,26)
    this.context.lineTo(443,26)
    this.context.lineTo(576,270)
    this.context.lineTo(443,514)
    this.context.lineTo(157,514)
    this.context.lineTo(25,270)
    this.context.lineTo(157,26)
    this.context.fill()
    this.context.stroke()
    this.context.closePath()
  }
  
  drawBaseMargin () {
    this.context.strokeStyle = "#000000"
    this.context.lineWidth = 3
    this.context.beginPath()
    this.context.moveTo(163,34)
    this.context.lineTo(437,34)
    this.context.lineTo(567,270)
    this.context.lineTo(437,506)
    this.context.lineTo(163,506)
    this.context.lineTo(33,270)
    this.context.lineTo(163,34)
    this.context.stroke()
    this.context.closePath()
  }
  
}
  
  
class BoardLines {
  
  constructor (boardCanvas) {
    this.bCanvas = boardCanvas
    this.board = this.bCanvas.board
    this.drawLines()
  }
  
  drawLines () {
    this.drawWestToEastLines()
    this.drawSouthwestToNortheastLines()
    this.drawNorthwestToSoutheastLines()
  }

  drawWestToEastLines () {
    [0,1,2,3,4,5,6,7,8,9,10].forEach((i) => {
      this.drawLine(this.board.westToEast[i][0], this.board.westToEast[i][1])
    })
  }
  
  drawSouthwestToNortheastLines () {
    [0,1,2,3,4,5,6,7,8,9,10].forEach((i) => {
      this.drawLine(this.board.southwestToNortheast[i][0], this.board.southwestToNortheast[i][1])
    })
  }
  
  drawNorthwestToSoutheastLines () {
    [0,1,2,3,4,5,6,7,8,9,10].forEach((i) => {
      this.drawLine(this.board.northwestToSoutheast[i][0],this.board.northwestToSoutheast[i][1])
    })
  }
  
  drawLine (beg, end) {
    canvas = document.getElementById('go-board')
    context = canvas.getContext('2d')
    context.strokeStyle = "#000000"
    context.lineWidth = 3
    context.beginPath()
    context.moveTo(this.bCanvas.getX(beg),this.bCanvas.getY(beg))
    context.lineTo(this.bCanvas.getX(end),this.bCanvas.getY(end))
    context.stroke()
    context.closePath()
  }
  
}


// # GLOBAL level

this.mousedown = (e) => {
  this.canvas = document.getElementById('go-board')
  const dx = this.canvas.offsetLeft
  const dy = this.canvas.offsetTop
  const px = e.pageX
  const py = e.pageY
  const x = px-dx
  const y = py-dy
  const point = this.canvasHelper.getPoint(x,y)
  if ( legalMove(point) ) {
    this.canvasHelper.drawStone(point,"red")
    const objOut = {red_move: point, new_game: this.newgame}
    constmsgOut = JSON.stringify(objOut)
    const xhr = new XMLHttpRequest()
    const url = "/make-a-move"
    xhr.open('POST',url)
    xhr.onreadystatechange = () => {
      if (xhr.readyState === 4 && xhr.status === 200) {
        const msgIn = xhr.responseText
        const response = JSON.parse(msgIn)
        addStones(response)
        updateLegalMoves(response.legal_red_moves)
      }
    }
    xhr.send(msgOut)
    this.newgame = "no"
  }
}


const legalMove = (point) => {
  return this.legalMoves.some((p) => p[0] === point[0] && p[1] === point[1] )
}


const getInitLegalMoves = () => {
  let legalMoves = []
  [0,1,2,3,4,5,6,7,8,9,10].forEach((i) => {
    for (let j = this.canvasHelper.board.rowStart[i]; j <= this.canvasHelper.board.rowEnd[i]; j++) {
      let pp = []
      pp[0] = j
      pp[1] = i+1
      legalMoves.push(pp)
    }
  })
  return legalMoves
}


const addStones = (response) => {
  if ( response.stones == undefined ) {
    this.canvasHelper.drawStone(response.white_move, "white")
    this.canvasHelper.drawStone(response.blue_move, "blue")
  }
  else {
    const stones = JSON.parse(response.stones)
    reset(stones)
  }
}


const reset = (stones) => {
  this.canvasHelper.redraw(stones)
}


const updateLegalMoves = (legalMoves) => {
  this.legalMoves = legalMoves
}


const start = () => {
  this.newgame = "yes"
  this.canvasHelper = new CanvasHelper
  this.legalMoves = getInitLegalMoves()
}



window.onload = start
