class Layout
  include Mongoid::Document
  include Mongoid::Timestamps

  field :direction, type: String, default: 'horizontal'
  validates :direction, inclusion: { in: %w[horizontal vertical] }

  field :child_type, type: String, default: 'layout'
  validates :child_type, inclusion: { in: %w[layout module] }

  field :contents, type: Array
  validates :contents, presence: true

  belongs_to :user
end
