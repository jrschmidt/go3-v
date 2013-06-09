// Generated by CoffeeScript 1.4.0
var Board, BoardBase, BoardDimensions, BoardLines, ClickHandler, GameCanvas, LegalPlayablePoints, ServerConnection, Zipper, mousedown, start;

Zipper = (function() {

  function Zipper() {
    this.board_specs = new BoardDimensions();
    this.board = new Board(this);
    this.lpp = new LegalPlayablePoints(this);
    this.clickster = new ClickHandler(this.lpp, this.board.drawing_object);
  }

  Zipper.prototype.click = function(x, y) {
    return this.clickster.click_handle(x, y);
  };

  return Zipper;

})();

BoardDimensions = (function() {

  function BoardDimensions() {
    this.row_start = [0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5];
    this.row_end = [5, 6, 7, 8, 9, 10, 10, 10, 10, 10, 10];
  }

  return BoardDimensions;

})();

Board = (function() {

  function Board(main_object) {
    this.controller = main_object;
    this.get_board_constants();
    this.drawing_object = new GameCanvas(this);
  }

  Board.prototype.get_board_constants = function() {
    this.row_start = this.controller.board_specs.row_start;
    this.row_end = this.controller.board_specs.row_end;
    this.w_e = [[[0, 0], [5, 0]], [[0, 1], [6, 1]], [[0, 2], [7, 2]], [[0, 3], [8, 3]], [[0, 4], [9, 4]], [[0, 5], [10, 5]], [[1, 6], [10, 6]], [[2, 7], [10, 7]], [[3, 8], [10, 8]], [[4, 9], [10, 9]], [[5, 10], [10, 10]]];
    this.sw_ne = [[[0, 5], [0, 0]], [[1, 6], [1, 0]], [[2, 7], [2, 0]], [[3, 8], [3, 0]], [[4, 9], [4, 0]], [[5, 10], [5, 0]], [[6, 10], [6, 1]], [[7, 10], [7, 2]], [[8, 10], [8, 3]], [[9, 10], [9, 4]], [[10, 10], [10, 5]]];
    return this.nw_se = [[[0, 5], [5, 10]], [[0, 4], [6, 10]], [[0, 3], [7, 10]], [[0, 2], [8, 10]], [[0, 1], [9, 10]], [[0, 0], [10, 10]], [[1, 0], [10, 9]], [[2, 0], [10, 8]], [[3, 0], [10, 7]], [[4, 0], [10, 6]], [[5, 0], [10, 5]]];
  };

  return Board;

})();

LegalPlayablePoints = (function() {

  function LegalPlayablePoints(main_object) {
    this.board = main_object.board;
    this.board_specs = main_object.board_specs;
    this.points = this.get_init_legal_moves();
  }

  LegalPlayablePoints.prototype.get_init_legal_moves = function() {
    var i, j, points, pp, _i, _j, _ref, _ref1, _ref2;
    points = [];
    for (i = _i = 0, _ref = this.board_specs.row_start.length; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
      for (j = _j = _ref1 = this.board_specs.row_start[i], _ref2 = this.board_specs.row_end[i]; _ref1 <= _ref2 ? _j <= _ref2 : _j >= _ref2; j = _ref1 <= _ref2 ? ++_j : --_j) {
        pp = {};
        pp.a = i;
        pp.b = j;
        points.push(pp);
      }
    }
    return points;
  };

  LegalPlayablePoints.prototype.legal_move = function(point) {
    var point_in;
    point_in = this.points.some(function(p) {
      return p.a === point[0] && p.b === point[1];
    });
    alert("legal_move = " + point_in);
    return point_in;
  };

  LegalPlayablePoints.prototype.update_legal_moves = function(points_string) {
    return this.points = this.parse_points(points_string);
  };

  LegalPlayablePoints.prototype.parse_points = function(points_string) {
    var p, points, z, _i, _ref;
    points = [];
    for (p = _i = 0, _ref = points_string.length / 2 - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; p = 0 <= _ref ? ++_i : --_i) {
      z = {};
      z.a = parseInt("0x" + points_string[p * 2]);
      z.b = parseInt("0x" + points_string[p * 2 + 1]);
      points.push(z);
    }
    return points;
  };

  return LegalPlayablePoints;

})();

ClickHandler = (function() {

  function ClickHandler(legal_moves_object, canvas_object) {
    this.lmo = legal_moves_object;
    this.canvas_object = canvas_object;
  }

  ClickHandler.prototype.click_handle = function(x, y) {
    var msg_in, msg_out, point;
    point = this.canvas_object.get_point(x, y);
    alert("point = " + point);
    if (this.lmo.legal_move(point)) {
      alert("legal move");
      this.canvas_object.draw_stone(point, "R");
      msg_out = String(point);
      this.connection = new ServerConnection();
      this.connection.send(msg_out);
      msg_in = this.connection.receive();
      this.update_legal_moves(msg_in);
      return alert("RESPONSE: " + msg_in);
    }
  };

  ClickHandler.prototype.update_legal_moves = function(msg) {
    return this.lmo.update_legal_moves(msg);
  };

  return ClickHandler;

})();

ServerConnection = (function() {

  function ServerConnection() {
    var url;
    this.xhr = new XMLHttpRequest();
    url = "/legal-points";
    this.xhr.open('GET', url);
  }

  ServerConnection.prototype.send = function() {
    return this.xhr.send();
  };

  ServerConnection.prototype.receive = function() {
    var msg;
    alert("ready state = " + this.xhr.readyState);
    msg = this.xhr.responseText;
    return msg;
  };

  return ServerConnection;

})();

GameCanvas = (function() {

  function GameCanvas(board) {
    this.canvas = document.getElementById('canvas');
    this.context = this.canvas.getContext('2d');
    this.board = board;
    this.board_base = new BoardBase(this);
    this.board_lines = new BoardLines(this);
  }

  GameCanvas.prototype.get_x = function(ab) {
    return 175 + 50 * ab[0] - 25 * ab[1];
  };

  GameCanvas.prototype.get_y = function(ab) {
    return 50 + 44 * ab[1];
  };

  GameCanvas.prototype.get_point = function(x, y) {
    var a, b, dx, dy, in_bounds, point, r2;
    point = [];
    a = -1;
    b = -1;
    r2 = 999;
    in_bounds = true;
    b = Math.floor((y - 28) / 44);
    a = Math.floor((x - 150 + 25 * b) / 50);
    if (b < 0) {
      in_bounds = false;
    }
    if (b > 10) {
      in_bounds = false;
    }
    if (a < this.board.row_start[b]) {
      in_bounds = false;
    }
    if (a > this.board.row_end[b]) {
      in_bounds = false;
    }
    dx = Math.abs(x - this.get_x([a, b]));
    dy = Math.abs(y - this.get_y([a, b]));
    r2 = dx * dx + dy * dy;
    if (r2 > 530) {
      in_bounds = false;
    }
    if (in_bounds === true) {
      point = [a, b];
    }
    return point;
  };

  GameCanvas.prototype.draw_stone = function(ab, color) {
    this.context.strokeStyle = "#000000";
    this.context.lineWidth = 2;
    this.context.fillStyle = this.get_rgb(color);
    this.context.beginPath();
    this.context.arc(this.get_x(ab), this.get_y(ab), 17, 0, 2 * Math.PI, false);
    this.context.fill();
    this.context.stroke();
    this.context.closePath();
    this.context.beginPath();
    this.context.strokeStyle = "#cc9933";
    this.context.arc(this.get_x(ab), this.get_y(ab), 19, 0, 2 * Math.PI, false);
    this.context.stroke();
    return this.context.closePath();
  };

  GameCanvas.prototype.get_rgb = function(color) {
    var clr;
    switch (color) {
      case "R":
        clr = "#cc3333";
        break;
      case "W":
        clr = "#f0f0f0";
        break;
      case "B":
        clr = "#5050cc";
    }
    return clr;
  };

  GameCanvas.prototype.remove_stone = function(ab) {
    var xx, yy;
    xx = this.get_x(ab);
    yy = this.get_y(ab);
    this.context.beginPath();
    this.context.fillStyle = "#cc9933";
    this.context.arc(xx, yy, 19, 0, 2 * Math.PI, false);
    this.context.fill();
    this.context.closePath();
    this.context.beginPath();
    this.context.strokeStyle = "#000000";
    this.context.lineWidth = 3;
    this.context.moveTo(xx - 11, yy - 19);
    this.context.lineTo(xx + 11, yy + 19);
    this.context.stroke();
    this.context.moveTo(xx + 11, yy - 19);
    this.context.lineTo(xx - 11, yy + 19);
    this.context.stroke();
    this.context.moveTo(xx - 20, yy);
    this.context.lineTo(xx + 20, yy);
    this.context.stroke();
    return this.context.closePath();
  };

  return GameCanvas;

})();

BoardBase = (function() {

  function BoardBase(board_canvas) {
    this.b_canvas = board_canvas;
    this.board = this.b_canvas.board;
    this.draw_base();
  }

  BoardBase.prototype.draw_base = function() {
    var canvas;
    canvas = document.getElementById('canvas');
    this.context = canvas.getContext('2d');
    this.draw_base_hex();
    return this.draw_base_margin();
  };

  BoardBase.prototype.draw_base_hex = function() {
    this.context.strokeStyle = "#000000";
    this.context.lineWidth = 5;
    this.context.fillStyle = "#cc9933";
    this.context.beginPath();
    this.context.moveTo(157, 26);
    this.context.lineTo(443, 26);
    this.context.lineTo(576, 270);
    this.context.lineTo(443, 514);
    this.context.lineTo(157, 514);
    this.context.lineTo(25, 270);
    this.context.lineTo(157, 26);
    this.context.fill();
    this.context.stroke();
    return this.context.closePath();
  };

  BoardBase.prototype.draw_base_margin = function() {
    this.context.strokeStyle = "#000000";
    this.context.lineWidth = 3;
    this.context.beginPath();
    this.context.moveTo(163, 34);
    this.context.lineTo(437, 34);
    this.context.lineTo(567, 270);
    this.context.lineTo(437, 506);
    this.context.lineTo(163, 506);
    this.context.lineTo(33, 270);
    this.context.lineTo(163, 34);
    this.context.stroke();
    return this.context.closePath();
  };

  return BoardBase;

})();

BoardLines = (function() {

  function BoardLines(board_canvas) {
    this.b_canvas = board_canvas;
    this.board = this.b_canvas.board;
    this.draw_lines();
  }

  BoardLines.prototype.draw_lines = function() {
    this.draw_w_e_lines();
    this.draw_sw_ne_lines();
    return this.draw_nw_se_lines();
  };

  BoardLines.prototype.draw_w_e_lines = function() {
    var i, _i, _results;
    _results = [];
    for (i = _i = 0; _i <= 10; i = ++_i) {
      _results.push(this.draw_line(this.board.w_e[i][0], this.board.w_e[i][1]));
    }
    return _results;
  };

  BoardLines.prototype.draw_sw_ne_lines = function() {
    var i, _i, _results;
    _results = [];
    for (i = _i = 0; _i <= 10; i = ++_i) {
      _results.push(this.draw_line(this.board.sw_ne[i][0], this.board.sw_ne[i][1]));
    }
    return _results;
  };

  BoardLines.prototype.draw_nw_se_lines = function() {
    var i, _i, _results;
    _results = [];
    for (i = _i = 0; _i <= 10; i = ++_i) {
      _results.push(this.draw_line(this.board.nw_se[i][0], this.board.nw_se[i][1]));
    }
    return _results;
  };

  BoardLines.prototype.draw_line = function(beg, end) {
    var canvas, context;
    canvas = document.getElementById('canvas');
    context = canvas.getContext('2d');
    context.strokeStyle = "#000000";
    context.lineWidth = 3;
    context.beginPath();
    context.moveTo(this.b_canvas.get_x(beg), this.b_canvas.get_y(beg));
    context.lineTo(this.b_canvas.get_x(end), this.b_canvas.get_y(end));
    context.stroke();
    return context.closePath();
  };

  return BoardLines;

})();

mousedown = function(e) {
  var dx, dy, px, py, x, y;
  this.canvas = document.getElementById('canvas');
  dx = this.canvas.offsetLeft;
  dy = this.canvas.offsetTop;
  px = e.pageX;
  py = e.pageY;
  x = px - dx;
  y = py - dy;
  return this.zip.click(x, y);
};

start = function() {
  return this.zip = new Zipper();
};

window.onload = start;
