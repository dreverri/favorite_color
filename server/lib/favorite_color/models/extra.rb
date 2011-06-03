module FavoriteColor
  class Extra
    include Ripple::EmbeddedDocument
    property :user_hash, Hash

    def as_json(option={})
      attributes
    end
  end
end
