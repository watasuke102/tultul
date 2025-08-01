class Layout
  include Mongoid::Document
  include Mongoid::Timestamps

  field :direction, type: String
  validates :direction, inclusion: { in: %w[horizontal vertical] }

  field :child_type, type: String
  validates :child_type, inclusion: { in: %w[layout module] }

  # used only when child_type is "module"
  field :renew_period_minute, type: Integer, default: 0
  validates :renew_period_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  field :contents, type: Array, default: []

  belongs_to :user

  validate :validate_and_set_default_value_for_contents
  def validate_and_set_default_value_for_contents
    for content in contents
      case child_type
      when "layout"
        unless content.is_a?(BSON::ObjectId)
          errors.add(:contents, "Contents of Layout(child_type: layout) must be an array of Layout IDs")
          return
        end

      when "module"
        unless content.is_a?(Hash) && content["type"].present?
          errors.add(:contents, "Contents of Layout(child_type: module) must be an array of Module object")
          return
        end
        case content["type"]
        when "text"
          if content["font_size"].is_a?(String)
            content["font_size"] = content["font_size"].to_i
          end
          unless content["font_size"].is_a?(Integer) && content["font_size"] > 0
            content["font_size"] = 16
          end
          unless content["text_align"].in? %w[left center right]
            content["text_align"] = "left"
          end
          unless content["text"].is_a?(String)
            content["text"] = ""
          end
        when "database_table"
          if content["database_id"] != nil
            begin
              Current.user.databases.find_by(id: content["database_id"])
            rescue
              errors.add(:contents, "Invalid database ID for database_table module")
            end
          end
        when "spacer"
          # pass
        else
          errors.add(:contents, "Unknown contentule type: #{content['type']}")
        end
      end
    end
  end
end
