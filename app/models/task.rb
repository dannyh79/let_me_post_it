class Task < ApplicationRecord
  scope :created_at_asc, -> { order(created_at: :asc) }
  scope :created_at_desc, -> { order(created_at: :desc) }
  scope :end_time_asc, -> { order(end_time: :asc) }
  scope :end_time_desc, -> { order(end_time: :desc) }
  
  validates :title, :description, presence: true
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
