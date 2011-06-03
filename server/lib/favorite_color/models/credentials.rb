module FavoriteColor
  class Credentials
    include Ripple::EmbeddedDocument
    property :token, String
    property :secret, String

    def as_json(option={})
      attributes
    end
  end
end
