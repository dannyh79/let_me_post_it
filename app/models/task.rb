class Task < ApplicationRecord
  enum status: [:pending, :ongoing, :done]

  scope :created_at_asc, -> { order(created_at: :asc) }
  scope :created_at_desc, -> { order(created_at: :desc) }
  scope :end_time_asc, -> { order(end_time: :asc) }
  scope :end_time_desc, -> { order(end_time: :desc) }
  scope :pending, -> { where(status: :pending) }
  scope :ongoing, -> { where(status: :ongoing) }
  scope :done, -> { where(status: :done) }
  scope :by_title, -> (title) { where('title ILIKE ?', "%#{title}%") }
  scope :by_status, -> (status) { where(status: status.to_sym) }
  scope :by_title_and_status, -> (title, status) { where('title ILIKE ?', "%#{title}%").where(status: status) }
  
  validates :title, :description, :status, presence: true
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
