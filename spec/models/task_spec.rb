require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "data input" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it 'should always be after end time' do
      task_with_valid_input = Task.new(
                                title: Faker::Lorem.sentence,
                                start_time: Time.now - 1.day, 
                                end_time: Time.now,
                                description: Faker::Lorem.paragraph
                              )
      task_with_invalid_input = Task.new(
                                  title: Faker::Lorem.sentence,
                                  start_time: Time.now, 
                                  end_time: Time.now - 1.day,
                                  description: Faker::Lorem.paragraph
                                )

      task_with_valid_input.save
      task_with_invalid_input.save
      
      expect(task_with_valid_input.errors.any?).to be false 
      expect(task_with_invalid_input.errors.full_messages).to eq ["#{I18n.t("activerecord.attributes.task.end_time")} #{I18n.t("activerecord.errors.models.task.attributes.must_be_after_the_start_time")}"]
      expect(task_with_valid_input).to be_valid
      expect(task_with_invalid_input).to_not be_valid
    end
  end
end
