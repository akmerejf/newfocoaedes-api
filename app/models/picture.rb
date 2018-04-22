class Picture
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :url, type: String

  embedded_in :photo, polymorphic: true
end
