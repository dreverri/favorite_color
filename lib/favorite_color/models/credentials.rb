module FavoriteColor
  class Credentials
    include Ripple::EmbeddedDocument
    property :token, String
    property :secret, String
  end
end
