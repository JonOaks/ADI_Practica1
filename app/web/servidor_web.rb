require 'sinatra/base'
require 'sinatra/reloader'


class ServidorWeb < Sinatra::Base
  get '/' do
    redirect to('/index_bb.html')
  end
end