require 'sinatra/base'

# Helper to enable cross origin requests.
# More on Cross Origin Resource Sharing here:
#   https://developer.mozilla.org/En/HTTP_access_control
#
# To enable cross origin requests for all routes:
#   configure do
#     enable :cross_origin
#     ...
#
# To enable cross origin requests for a single domain:
#   get '/' do
#     cross_origin
#     ...
#
# More info at:
#   http://github.com/britg/sinatra-cross_origin
#

module Sinatra
  module CrossOrigin
    module Helpers

      # Apply cross origin headers either
      # from global config or custom config passed
      # as a hash
      def cross_origin(hash=nil)
        return unless request.env['HTTP_ORIGIN']
        options.set hash if hash

        origin = options.allow_origin == :any ? request.env['HTTP_ORIGIN'] : options.allow_origin
        methods = options.allow_methods.map{ |m| m.to_s.upcase! }.join(', ')

        headers 'Access-Control-Allow-Origin' => origin,
          'Access-Control-Allow-Methods' => methods,
          'Access-Control-Allow-Credentials' => options.allow_credentials.to_s,
          'Access-Control-Max-Age' => options.max_age.to_s 
      end
    end

    def self.registered(app)

      app.helpers CrossOrigin::Helpers

      app.set :cross_origin, false 
      app.set :allow_origin, :any
      app.set :allow_methods, [:post, :get, :options]
      app.set :allow_credentials, true
      app.set :max_age, 1728000


      app.before do 
        cross_origin if options.cross_origin
      end

    end
  end

end
