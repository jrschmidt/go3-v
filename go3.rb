require 'rubygems'

require 'sinatra'

require 'coffee-script'

require 'pry'


get '/' do
  erb :index
end


get '/hxr-source' do
  str = hxr_string
  str
end


class Game

  def to_dom_string
    str = ""
    str
  end


end


def go_string
  @game = Game.new
  @game.to_dom_string
end


def hxr_string
  str = "H X R Test String!!!!"
  str
end
