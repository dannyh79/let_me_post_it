class Task < ApplicationRecord
  belongs_to :user

  enum status: [:pending, :ongoing, :done]
  enum priority: [:low, :mid, :high]

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
  
  validates :title, :start_time, :end_time, :priority, :status, :description, presence: true
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    # jumps out if either one is blank
    return if end_time.blank? || start_time.blank?
 
    if end_time < start_time
      errors.add(
        :end_time, 
        I18n.t(
          "activerecord.errors.models.task.attributes.must_be_after_the_start_time"
        )
      ) 
    end 
  end
end
