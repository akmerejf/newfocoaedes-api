class Incident
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Timestamps
  field :name, type: String
  field :description, type: String
  field :latitude, type: String

  embeds_many :pictures, as: :photo, store_as: "images", cascade_callbacks: true
  belongs_to :profile, validate: false

  validates_presence_of :name, :pictures
  accepts_nested_attributes_for :pictures
  search_in :description, :name
  
end
