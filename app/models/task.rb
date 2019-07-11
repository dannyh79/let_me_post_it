class Task < ApplicationRecord
  enum status: [:pending, :ongoing, :done]
  enum priority: [:low, :mid, :high]

  scope :created_at_asc, -> { order(created_at: :asc) }
  scope :created_at_desc, -> { order(created_at: :desc) }
  scope :end_time_asc, -> { order(end_time: :asc).order(title: :asc) }
  scope :end_time_desc, -> { order(end_time: :desc).order(title: :asc) }
  scope :priority_asc, -> { order(priority: :asc).order(title: :asc) }
  scope :priority_desc, -> { order(priority: :desc).order(title: :asc) }
  scope :pending, -> { where(status: :pending).order(title: :asc) }
  scope :ongoing, -> { where(status: :ongoing).order(title: :asc) }
  scope :done, -> { where(status: :done).order(title: :asc) }
  scope :by_title, -> (title) { where('title ILIKE ?', "%#{title}%") }
  scope :by_status, -> (status) { where(status: status).order(title: :asc) }
  scope :by_title_and_status, -> (title, status) { where('title ILIKE ?', "%#{title}%").where(status: status) }
  
  validates :title, :description, :status, :priority, presence: true
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
