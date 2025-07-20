class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  include ActiveModel::Validations
  before_save :normalize_email_address
  has_secure_password
  has_many :sessions, dependent: :destroy

  field :email_address, type: String
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  field :password, type: String
  field :password_digest, type: String

  def normalize_email_address
    self.email_address = email_address.strip.downcase if email_address.present?
  end

  def self.authenticate_by(attributes)
    identifiers = attributes.to_h

    raise ArgumentError, "Password is required" unless identifiers["password"].present? or identifiers["password"].empty?

    begin
      user = find_by(email_address: identifiers["email_address"].strip.downcase)
      user if user.authenticate_password(identifiers["password"])
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end
end
