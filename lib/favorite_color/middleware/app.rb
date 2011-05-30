module FavoriteColor
  class App < Sinatra::Base
    configure do
      config = File.join(File.dirname(__FILE__), '..', '..', '..', 'config')
      Ripple.load_config(config + '/ripple.yml', [settings.environment])

      c = YAML.load(ERB.new(File.read(config + '/settings.yml')).result)
      c.each { |k,v| set k.to_sym, v }
    end

    # Session storage
    use Riak::SessionStore, Ripple.config

    # 3rd party authorization
    use OmniAuth::Builder do
      provider :twitter, App.settings.twitter['key'], App.settings.twitter['secret']
    end

    # App
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
      redirect to('/')
    end

    get '/auth/failure' do
      "Authorization failure"
    end
  end
end
