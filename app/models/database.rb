class Database
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String, default: "New Database"
  validates :title, presence: true

  field :scheme, type: Hash, default: { text: "text" }
  field :content, type: Array, default: [ { text: "Sample text" } ]

  belongs_to :user
end
