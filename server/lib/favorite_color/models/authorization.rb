module FavoriteColor
  class Authorization
    include Ripple::Document
    property :provider, String, :presence => true
    property :uid, String, :presence => true
    one :user_info, :class_name => "FavoriteColor::UserInfo"
    one :credentials, :class_name => "FavoriteColor::Credentials"
    one :extra, :class_name => "FavoriteColor::Extra"
    one :user, :class_name => "FavoriteColor::User"

    def key
      "#{self.provider}-#{self.uid}"
    end

    def self.find_from_auth(auth)
      auth_key = "#{auth['provider']}-#{auth['uid']}"
      find(auth_key)
    end

    def self.create_from_auth!(auth, user)
      user ||= User.create!
      a = user.authorizations.create!(auth.merge(:user => user))
      user.save!
      return a
    end

    def as_json(option={})
      attributes
    end
  end
end
