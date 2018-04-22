class Profile
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :phone, type: String
  field :img_url, type: String

  has_many :incidents
  belongs_to :user
end
