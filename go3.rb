require 'rubygems'

require 'sinatra'

require 'coffee-script'

require 'pry'


get '/' do
  erb :index
end


get '/hxr-source' do
  msg = params[:msg]
  str = hxr_string(msg)
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


def hxr_string(msg)
  str = "point "
  str << msg.to_s
  str
end


def hxr_string2(msg)
  point = ["a","b"]
  str = "Ruby server received point [ "
  str << point[0].to_s
  str << " , "
  str << point[1].to_s
  str << "] from the browser"
  str
end



