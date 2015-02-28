require 'json'

@filename = "game.json"

File.open(@filename, "w") do |f|
  pts = {stones: []}
  f.puts pts.to_json
end
