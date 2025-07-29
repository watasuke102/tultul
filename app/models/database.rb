class Database
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  validates :title, presence: true

  field :scheme, type: Hash
  validates :scheme, presence: true

  field :content, type: Array
  belongs_to :user
end
