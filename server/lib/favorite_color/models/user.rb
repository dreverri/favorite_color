module FavoriteColor
  class User
    include Ripple::Document
    property :favorite_color, String

    many :authorizations, :class_name => "FavoriteColor::Authorization"
    many :clients, :class_name => "Rack::OAuth2::Server::Client"

    def as_json(option={})
      {
        :authorizations => authorizations.map do |auth|
          {
            :provider => auth.provider,
            :name => auth.user_info.name,
            :nickname => auth.user_info.nickname
          }
        end
      }.merge(attributes)
    end
  end
end
