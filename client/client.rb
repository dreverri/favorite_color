require 'sinatra/base'
require 'net/http'
require 'uri'
require 'json'

module FavoriteColor
  class Client < Sinatra::Base
    configure do
      set :views, File.join(File.dirname(__FILE__), 'views')
    end

    use Rack::Session::Cookie, :key => 'rack.session.favorite_color'

    get '/' do
      if session['access_token']
        # collect data from the server API
        uri = URI.join(session['server_url'], '/api')
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Get.new(uri.request_uri)
        req.add_field("Authorization", "OAuth #{session['access_token']}")
        @data = JSON.parse(http.request(req).body)
        erb :show_data
      else
        # gather required information to obtain a token from the
        # server API
        erb :client_form
      end
    end

    post '/' do
      # prepare request which will be made to the server API
      redirect_uri = URI.escape(url('/callback'),
                                Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      server_url = session['server_url'] = params[:server_url]
      client_id = session['client_id'] = params[:client_id]
      client_secret = session['client_secret'] = params[:client_secret]
      scope = "read"
      response_type = "code"
      uri = URI.join(server_url, "/oauth/authorize")
      uri.query = ["redirect_uri=#{redirect_uri}",
                   "client_id=#{client_id}",
                   "client_secret=#{client_secret}",
                   "scope=#{scope}",
                   "response_type=#{response_type}"].join("&")
      redirect uri.to_s
    end

    get '/callback' do
      server_url = session['server_url']
      client_id = session['client_id']
      client_secret = session['client_secret']
      # request access_token
      uri = URI.join(server_url, "/oauth/access_token")
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.request_uri)
      req.set_form_data("grant_type" => "authorization_code",
                            "code" => params[:code],
                            "client_id" => client_id,
                            "client_secret" => client_secret)
      res = http.request(req)
      # parse body for access_token
      access_token = JSON.parse(res.body)["access_token"]
      # set access_token in the session
      session['access_token'] = access_token
      # redirect to /
      redirect to('/')
    end

    get '/logout' do
      session['access_token'] = nil
      redirect to('/')
    end
  end
end

