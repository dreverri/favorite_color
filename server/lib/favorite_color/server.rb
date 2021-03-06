module FavoriteColor
  class Server < Sinatra::Base
    configure do
      set :views, File.join(File.dirname(__FILE__), '..', '..', 'views')
      config_dir = File.join(File.dirname(__FILE__), '..', '..', 'config')
      Ripple.load_config(config_dir + '/ripple.yml', [settings.environment])

      c = YAML.load(ERB.new(File.read(config_dir + '/settings.yml')).result)
      c.each { |k,v| set k.to_sym, v }
    end

    # Session storage
    use Riak::SessionStore, Ripple.config

    # 3rd party authorization
    use OmniAuth::Builder do
      provider :twitter, Server.settings.twitter['key'], Server.settings.twitter['secret']
    end

    # Server
    helpers do
      def current_user
        @current_user ||= User.find(session['user_key']) if session['user_key']
      end
    end

    not_found do
      "Nothing to see here"
    end

    error do
      "Something broke"
    end

    get '/' do
      erb :index
    end

    post '/' do
      current_user.update_attributes(:favorite_color => params[:favorite_color])
      redirect to('/')
    end

    post '/client' do
      current_user.clients.build(:display_name => params[:display_name],
                                 :scope => %{read write})
      current_user.save!
      redirect to('/')
    end

    get '/api' do
      if oauth.authenticated?
        User.find(oauth.identity).to_json
      else
        halt 401
      end
    end

    # User authorization
    get '/logout' do
      session['user_key'] = nil
      redirect to('/')
    end

    get '/auth/:name/callback' do
      auth = request.env['omniauth.auth']
      unless @auth = Authorization.find_from_auth(auth)
        @auth = Authorization.create_from_auth!(auth, current_user)
      end

      session['user_key'] = @auth.user.key
      if session['authorization']
        authorization = session.delete('authorization')
        redirect to("/oauth/authorize?authorization=#{authorization}")
      else
        redirect to('/')
      end
    end

    get '/auth/failure' do
      "Authorization failure"
    end

    # OAuth 2.0 client authorization
    register Rack::OAuth2::Sinatra

    get '/oauth/authorize' do
      if current_user
        erb :client_authorization
      else
        session['authorization'] = oauth.authorization
        redirect to('/')
      end
    end

    post '/oauth/grant' do
      oauth.grant! current_user.key
    end

    post '/oauth/deny' do
      oauth.deny!
    end
  end
end
