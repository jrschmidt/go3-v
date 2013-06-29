Given /^We have a GO game <(game)>$/ do |game|
  @game = Game.new
end

When /^a move is sent by the client for a gameboard point <(point)>$/ do |point|
  @point = point
end

Then /^the server reads and handles the new input$/ do
  @game.handle_move(:human,@point)
end

When /^a 'get move' request is made for AI player <(ai)>$/ do |ai|
  @ai = AiPlayer.new
end

Then /^a move <(move)> is made by AI player <(ai)>$/ do |ai|
  @move = @ai.get_move
end

Then /^the state of <(game)> is changed to reflect the new move$/ do |game|
  @game.make_move(@ai)
end

When /^a 'send_legal_moves' command is made for game <(game)>$/ do |game|
  @game.send_legal_moves
end

Then /^a new string <(game_string)> is generated representing the revised legal moves collection$/ do |game_string|
  @game_string = @game.get_legal_moves_string
end

Then /^the string <(game_string)> is sent to the client$/ do |game_string|
  @game.send_legal_moves(@game_string)
end

