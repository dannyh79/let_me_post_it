class Task < ApplicationRecord
  include SharedScopes
  
  belongs_to :user, counter_cache: true
  has_many :tag_tasks
  has_many :tags, through: :tag_tasks

  enum status: [:pending, :ongoing, :done]
  enum priority: [:low, :mid, :high]
  
  validates :title, :start_time, :end_time, :priority, :status, :description, presence: true
  validate :end_time_after_start_time

  # --- start for tag feature ---
  # filter tasks by tag
  def self.by_tag(name)
    Tag.find_by(name: name).tasks
  end
  
  # getter for tag_list
  def tag_list
    tags.map(&:name).join(', ')
  end
  
  # setter for tag_list
  def tag_list=(tag_names)
    self.tags = tag_names.split(',').map do |tag|
      Tag.where(name: tag.strip.titleize).first_or_create!
    end
  end
  # --- end for tag feature ---

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
