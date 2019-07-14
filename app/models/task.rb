class Task < ApplicationRecord
  include SharedScopes
  
  belongs_to :user, counter_cache: true

  enum status: [:pending, :ongoing, :done]
  enum priority: [:low, :mid, :high]
  
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
