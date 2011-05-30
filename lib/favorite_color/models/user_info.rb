module FavoriteColor
  class UserInfo
    include Ripple::EmbeddedDocument
    property :name, String, :presence => true
    property :email, String
    property :nickname, String
    property :first_name, String
    property :last_name, String
    property :location, String
    property :description, String
    property :image, String # URL
    property :urls, Hash # "Blog" => "http://intridea.com/blog"
  end
end
