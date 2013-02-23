require 'sinatra/base'

class TestApp < Sinatra::Base
  register Sinatra::CrossOrigin

  get '/' do
    "Hello"
  end

  get '/defaults' do
    cross_origin
    "Defaults"
  end

  get '/same_origin' do
    "Same origin!"
  end

  get '/allow_any_origin' do
    cross_origin
    "Allowing any origin"
  end

  get '/allow_specific_origin' do
    cross_origin :allow_origin => 'http://example.com'
    "Allowing any origin"
  end

  get '/allow_methods' do
    cross_origin :allow_methods => params[:methods].split(', ')
    "Allowing methods"
  end

  get '/allow_headers' do
    cross_origin :allow_headers => params[:allow_headers]
    "Allowing headers"
  end

  get '/dont_allow_credentials' do
    cross_origin :allow_credentials => false
    "Not allowing credentials"
  end

  get '/set_max_age' do
    cross_origin :max_age => params[:maxage]
    "Setting max age"
  end

end
