class Layout
  include Mongoid::Document
  include Mongoid::Timestamps

  field :direction, type: String
  validates :direction, inclusion: { in: %w[horizontal vertical] }

  field :child_type, type: String
  validates :child_type, inclusion: { in: %w[layout module] }

  # used only when child_type is "module"
  field :renew_period_minute, type: Integer, default: 1
  validates :renew_period_minute, numericality: { only_integer: true, greater_than: 0 }

  field :contents, type: Array, default: []

  belongs_to :user
end
