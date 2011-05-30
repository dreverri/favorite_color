module FavoriteColor
  class User
    include Ripple::Document
    many :authorizations, :class_name => "FavoriteColor::Authorization"
  end
end
