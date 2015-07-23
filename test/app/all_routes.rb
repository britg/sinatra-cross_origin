require 'sinatra/base'

class AllRoutesApp < Sinatra::Base
  register Sinatra::CrossOrigin
  enable :cross_origin

  get '/' do
    "Hello"
  end

end
