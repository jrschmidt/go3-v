Feature: 3 Player Hexagonal GO Game

  We want to build a Ruby server backend
  To send and receive data from an HTML5 Canvas gameboard
  That plays a 3 player hexagonal game of GO
  And receives the coordinates of a gamepoint when the user makes a legal play
  And computes AI moves for the other two players
  And sends the Canvas element the new gameboard state with a new list of legal moves


  ## TODO ## (change to Go3 scenarios)
  Scenario: Receive Player's Move
    Given We have a GO game <game>
    When a move is sent by the client for a gameboard point <point>
    Then the server reads and handles the new input

  Scenario: Make AI Move
    Given We have a GO game <game>
    When a 'get move' request is made for AI player <ai>
    Then a move <move> is made by AI player <ai>
    And the state of <game> is changed to reflect the new move <move>

  Scenario: Send Legal Moves
    Given We have a GO game <game>
    When a 'send_legal_moves' command is made for game <game>
    Then a new string <game_string> is generated representing the revised legal moves collection
    And the string <game_string> is sent to the client

  Scenario: Delete a Point from Legal Moves List
    Given We have a GO game <game>
    When a 'remove_point' command for point <point> is made for game <game>
    Then a new string <game_string> is generated representing the revised legal moves collection
    And the string <game_string> is sent to the client

