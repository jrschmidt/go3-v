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


  getPoint (x,y) {
    // First, use rectangular coordinates to determine which gameboard point to
    // check, then use the radius from the pixel at the center of the gameboard point
    // to see if it's close enough to map the mouse click to that point. Return the 
    // gameboard coordinates of the point if it is valid, else return an empty array.
  }

