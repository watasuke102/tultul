class Session
  include Mongoid::Document
  belongs_to :user
  field :user_agent, type: String
  field :ip_address, type: String
end
