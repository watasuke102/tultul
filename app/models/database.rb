class Database
  include Mongoid::Document
  include Mongoid::Timestamps
  field :scheme, type: Hash
  field :content, type: Hash[]
  belongs_to :user
end
