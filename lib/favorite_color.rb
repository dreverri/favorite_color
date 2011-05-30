require 'sinatra/base'
require 'ripple'
require 'riak-sessions'
require 'omniauth'

# OAuth provider
require 'rack/oauth2/sinatra'

# Models
require 'favorite_color/models/authorization'
require 'favorite_color/models/credentials'
require 'favorite_color/models/extra'
require 'favorite_color/models/user_info'
require 'favorite_color/models/user'

# Middleware
require 'favorite_color/middleware/app'
