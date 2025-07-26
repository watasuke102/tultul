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

  has_many :layouts, dependent: :destroy
  # `@user.layouts.create` must be called after calling `@user.save`
  # it means that initially user cannot have root_layout
  # so this must be optional (that is, `presence` validation cannot be used)
  belongs_to :root_layout, class_name: "Layout", optional: true

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
