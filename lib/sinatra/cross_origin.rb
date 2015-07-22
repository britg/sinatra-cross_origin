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
        request_origin = request.env['HTTP_ORIGIN']
        return unless request_origin
        settings.set hash if hash

        if settings.allow_origin == :any
          origin = request_origin
        else
          allowed_origins = *settings.allow_origin # make sure its an array
          origin = allowed_origins.join('|')       # we'll return this unless allowed

          allowed_origins.each do |allowed_origin|
            if allowed_origin.is_a?(Regexp) ? 
                request_origin =~ allowed_origin : 
                request_origin == allowed_origin
              origin = request_origin
              break
            end
          end
        end

        methods = settings.allow_methods.map{ |m| m.to_s.upcase! }.join(', ')

        headers_list = {
          'Access-Control-Allow-Origin' => origin,
          'Access-Control-Allow-Methods' => methods,
          'Access-Control-Allow-Headers' => settings.allow_headers.map(&:to_s).join(', '),
          'Access-Control-Allow-Credentials' => settings.allow_credentials.to_s,
          'Access-Control-Max-Age' => settings.max_age.to_s,
          'Access-Control-Expose-Headers' => settings.expose_headers.join(', ')
        }

        headers headers_list
      end
    end

    def self.registered(app)

      app.helpers CrossOrigin::Helpers

      app.set :cross_origin, false
      app.set :allow_origin, :any
      app.set :allow_methods, [:post, :get, :options]
      app.set :allow_credentials, true
      app.set :allow_headers, ["*", "Content-Type", "Accept", "AUTHORIZATION", "Cache-Control"]
      app.set :max_age, 1728000
      app.set :expose_headers, ['Cache-Control', 'Content-Language', 'Content-Type', 'Expires', 'Last-Modified', 'Pragma']

      app.before do
        cross_origin if settings.cross_origin
      end

    end
  end
end
