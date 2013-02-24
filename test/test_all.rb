require 'test_helper'

class HelloTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp
  end

  def _defaults
    get '/defaults', {}, {'HTTP_ORIGIN' => 'http://localhost'}
    assert last_response.ok?
    assert_equal 'http://localhost', last_response.headers['Access-Control-Allow-Origin']
    assert_equal 'POST, GET, OPTIONS', last_response.headers['Access-Control-Allow-Methods']
    assert_equal 'true', last_response.headers['Access-Control-Allow-Credentials']
    assert_equal "1728000", last_response.headers['Access-Control-Max-Age']
    assert_equal false, last_response.headers.has_key?('Access-Control-Allow-Headers')
  end

  def test_it_says_hello
    get '/'
    assert last_response.ok?
    assert_equal 'Hello', last_response.body
  end

  def test_cross_origin_is_silent_on_same_origin_request
    get '/same_origin'
    assert last_response.ok?
    assert_equal nil, last_response.headers['Access-Control-Allow-Origin']
  end

  def test_allow_any_origin
    get '/allow_any_origin', {}, {'HTTP_ORIGIN' => 'http://localhost'}
    assert last_response.ok?
    assert_equal 'http://localhost', last_response.headers['Access-Control-Allow-Origin']
  end

  def test_allow_specific_origin
    get '/allow_specific_origin', {}, {'HTTP_ORIGIN' => 'http://example.com'}
    assert last_response.ok?
    assert_equal 'http://example.com', last_response.headers['Access-Control-Allow-Origin']
  end

  def test_allow_methods
    get '/allow_methods', {:methods=>'get, post'}, {'HTTP_ORIGIN' => 'http://localhost'}
    assert last_response.ok?
    assert_equal 'GET, POST', last_response.headers['Access-Control-Allow-Methods']
  end

  def test_allow_headers
    get '/allow_headers', {:allow_headers=>['Content-Type', 'Origin', 'Accept']}, {'HTTP_ORIGIN' => 'http://localhost'}
    assert last_response.ok?
    assert_equal 'Content-Type, Origin, Accept', last_response.headers['Access-Control-Allow-Headers']
  end

  def test_dont_allow_credentials
    get '/dont_allow_credentials', {}, {'HTTP_ORIGIN' => 'http://localhost'}
    assert last_response.ok?
    assert_equal "false", last_response.headers['Access-Control-Allow-Credentials']
  end

  def test_set_max_age
    get '/set_max_age', {:maxage=>"60"}, {'HTTP_ORIGIN' => 'http://localhost'}
    assert last_response.ok?
    assert_equal "60", last_response.headers['Access-Control-Max-Age']
  end

end
