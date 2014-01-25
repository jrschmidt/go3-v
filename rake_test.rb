require_relative 'go3.rb'

require 'test/unit'
require 'rack/test'

class Go3Test < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_equals
    assert_equal(7,7)
    assert_equal("ABCDE","ABCDE")
    assert_equal("Hello John","Hello John")
  end


#  def test_my_default
#    get '/'
#    assert last_response.ok?
#    assert_equal 'Welcome to my page!', last_response.body
#  end

#  def test_with_params
#    post '/', :name => 'Frank'
#    assert_equal 'Hello Frank!', last_response.body
#  end


end


