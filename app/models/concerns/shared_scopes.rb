module SharedScopes
  extend ActiveSupport::Concern

  included do
    scope :sorted_by, ->(sort_option) {
      # extract the sort direction from the param value.
      direction = /desc$/.match?(sort_option) ? "desc" : "asc"
      case sort_option.to_s
      when /^created_at_/
        order(created_at: direction)
      when /^end_time_/
        order(end_time: direction)
      when /^priority_/
        order(priority: direction)
      else
        raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
      end
    }
    scope :by_title, -> (title) { where('title ILIKE ?', "%#{title}%") }
    scope :by_status, -> (status) { where(status: status).order(title: :asc) }
    scope :by_title_and_status, -> (title, status) { where('title ILIKE ?', "%#{title}%").where(status: status) }
  end
end