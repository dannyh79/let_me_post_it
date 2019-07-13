require 'rails_helper'

RSpec.describe Task, type: :model do
  before { create(:user) }

  describe "data input" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:priority) }
    it 'should always be after end time' do
      task_with_valid_input = Task.new(
                                title: Faker::Lorem.sentence,
                                start_time: Time.now - 1.day, 
                                end_time: Time.now,
                                description: Faker::Lorem.paragraph,
                                priority: 'mid',
                                status: 'pending',
                                user_id: User.last.id
                              )
      task_with_invalid_input = Task.new(
                                  title: Faker::Lorem.sentence,
                                  start_time: Time.now, 
                                  end_time: Time.now - 1.day,
                                  description: Faker::Lorem.paragraph,
                                  priority: 'mid',
                                  status: 'pending',
                                  user_id: User.last.id
                                )

      task_with_valid_input.save
      task_with_invalid_input.save
      
      expect(task_with_valid_input.errors.any?).to be false 
      expect(task_with_invalid_input.errors.full_messages).to eq ["#{I18n.t("activerecord.attributes.task.end_time")} #{I18n.t("activerecord.errors.models.task.attributes.must_be_after_the_start_time")}"]
      expect(task_with_valid_input).to be_valid
      expect(task_with_invalid_input).to_not be_valid
    end
  end
  
  describe "sort" do
    titles = [Faker::Lorem.sentence, Faker::Lorem.sentence, Faker::Lorem.sentence]
    # status => { 0: "pending", 1: "ongoing", 2: "done" }
    before do
      instance_variable_set "@task1", create(:task, title: titles[0], status: 2)
      instance_variable_set "@task2", create(:task, title: titles[1], status: 1)
      instance_variable_set "@task3", create(:task, title: titles[2], status: 0)
      instance_variable_set "@task4", create(:task, title: titles[2], status: 2)
      instance_variable_set "@task5", create(:task, title: titles[1], status: 1)
      instance_variable_set "@task6", create(:task, title: titles[0], status: 0)
      instance_variable_set "@task7", create(:task, title: titles[0], status: 2)
      instance_variable_set "@task8", create(:task, title: titles[1], status: 1)
      instance_variable_set "@task9", create(:task, title: titles[2], status: 0)
    end

    it 'should be by status' do
      result_pending = []
      result_ongoing = []
      result_done = []
      Task.by_status("pending").each do |task|
        result_pending << task.title
      end
      Task.by_status("ongoing").each do |task|
        result_ongoing << task.title
      end
      Task.by_status("done").each do |task|
        result_done << task.title
      end
      
      expect(result_pending.sort_by{ |title| title.downcase }).to eq [@task3.title, @task6.title, @task9.title].sort_by{ |title| title.downcase }
      expect(result_ongoing.sort_by{ |title| title.downcase }).to eq [@task2.title, @task5.title, @task8.title].sort_by{ |title| title.downcase }
      expect(result_done.sort_by{ |title| title.downcase }).to eq [@task1.title, @task4.title, @task7.title].sort_by{ |title| title.downcase }
    end

    it 'should be by title' do
      Task.by_title(titles[0]).each do |task|
        expect(task.title).to eq titles[0]
      end
    end

    it 'should be by title and status' do
      Task.by_title_and_status(titles[2], "pending").each do |task|
        expect(task.title).to eq titles[2]
        expect(task.status).to eq "pending"
      end
    end
  end
end
