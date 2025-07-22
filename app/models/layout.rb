class Layout
  include Mongoid::Document
  include Mongoid::Timestamps

  field :direction, type: String
  validates :direction, inclusion: { in: %w[horizontal vertical] }

  field :contents, type: Array
  validates :contents, presence: true

  belongs_to :user
end
