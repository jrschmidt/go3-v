require '~/Desktop/go3/go3'

require 'test/unit'


require './test/test_helpers.rb'
require './test/test_data.rb'


# Tests for Board Point and Stone Methods
require './test/board_point_stone_test.rb'

# Tests for Game Analysis Methods
# require './test/game_analysis_test.rb'

# Tests for Legal Moves Methods
# require './test/legal_moves_test.rb'

# Tests for Gameplay Control Methods
# require './test/gameplay_control_test.rb'


class Go3Test < Test::Unit::TestCase
  include TestData

  def app
    Sinatra::Application
  end

end
