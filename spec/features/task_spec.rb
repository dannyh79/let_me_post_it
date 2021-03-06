require 'rails_helper'

RSpec.describe Task, type: :feature do
  before {
    create(:user)
    visit root_path

    within('form[action="/sessions"]') do
      fill_in :email, with: "email@email.com"
      fill_in :password, with: "111111"
      click_on I18n.t("sessions.form_login.submit")
    end
  }
  
  describe 'CRUD' do
    let(:title) { Faker::Lorem.sentence }
    let(:start_time) { DateTime.now }
    let(:end_time) { DateTime.now + 1.day }
    let(:description) { Faker::Lorem.paragraph }

    let(:new_title) { Faker::Lorem.sentence }
    let(:new_start_time) { DateTime.now + 1.day }
    let(:new_end_time) { DateTime.now + 2.day }
    let(:new_description) { Faker::Lorem.paragraph }

    let(:title_error) {
      "#{I18n.t("activerecord.attributes.task.title")} #{I18n.t("activerecord.errors.models.task.attributes.title.blank")}"
    }
    let(:start_time_error) {
      "#{I18n.t("activerecord.attributes.task.start_time")} #{I18n.t("activerecord.errors.models.task.attributes.start_time.blank")}"
    }
    let(:end_time_error) {
      "#{I18n.t("activerecord.attributes.task.end_time")} #{I18n.t("activerecord.errors.models.task.attributes.end_time.blank")}"
    }
    let(:description_error) {
      "#{I18n.t("activerecord.attributes.task.description")} #{I18n.t("activerecord.errors.models.task.attributes.description.blank")}"
    }

    context 'when visiting the index of tasks' do
      it 'should show all the tasks' do  
        expect{ 3.times { create(:task) } }.to change{ Task.count }.from(0).to(3)
        
        visit tasks_path
  
        titles = all('#table_tasks tr > td:first-child').map(&:text)
        result = Task.all.map { |task| task.title }
        expect(titles).to eq result
      end
    end

    context 'when creating a task' do
      it 'should pass with all input fields filled out' do
        expect{
          create_task_with(
            title, 
            start_time, 
            end_time, 
            description
          ) 
        }.to change{ Task.count }.from(0).to(1)
        expect(page).to have_content(I18n.t("tasks.create.notice"))
        expect(page).to have_content(Task.first.title)
      end
  
      it 'should not pass without title, start_time, end_time, and description' do
        create_task_with(nil, nil, nil, nil)
        
        error_message = all('ul.error_message > li').map(&:text)
        expected_error_message = [title_error, start_time_error, end_time_error, description_error]
  
        expect(error_message).to eq expected_error_message
      end
      
      it 'should not pass without title' do
        create_task_with(nil, start_time, end_time, description)
        
        error_message = all('ul.error_message > li').map(&:text)
        expected_error_message = [title_error]
  
        expect(error_message).to eq expected_error_message
      end
  
      it 'should not pass without start_time' do
        create_task_with(title, nil, end_time, description)
        
        error_message = all('ul.error_message > li').map(&:text)
        expected_error_message = [start_time_error]
  
        expect(error_message).to eq expected_error_message
      end
  
      it 'should not pass without end_time' do
        create_task_with(title, start_time, nil, description)
        
        error_message = all('ul.error_message > li').map(&:text)
        expected_error_message = [end_time_error]
  
        expect(error_message).to eq expected_error_message
      end
  
      it 'should not pass without end_time' do
        create_task_with(title, start_time, end_time, nil)
        
        error_message = all('ul.error_message > li').map(&:text)
        expected_error_message = [description_error]
  
        expect(error_message).to eq expected_error_message
      end
    end

    context 'when viewing a task' do
      it 'should have the task\'s title and description' do
        expect{ create(:task) }.to change{ Task.count }.from(0).to(1)

        visit the_task_path(Task.first.title)

        expect(page).to have_content(Task.first.title)
        expect(page).to have_content(Task.first.description)
      end
    end

    context 'when editing a task' do
      before do
        create(:task)
        visit the_edit_task_path(Task.first.title)
      end

      it 'should update the task with new title, new start/end time, and new description' do
        edit_task_with(
          new_title, 
          new_start_time, 
          new_end_time, 
          new_description, 
          "low", 
          "done"
        )

        updated_task = all('#table_tasks tr:first-child td').map(&:text)
        expected_outcome = [
          Task.first.title,
          I18n.l(Task.first.created_at, format: :long),
          I18n.l(Task.first.start_time, format: :long),
          I18n.l(Task.first.end_time, format: :long),
          I18n.t("activerecord.attributes.task/priority.#{Task.first.priority}"),
          I18n.t("activerecord.attributes.task/status.#{Task.first.status}")
        ]

        expect(page).to have_content(I18n.t("tasks.update.notice"))
        expect(updated_task.any? { expected_outcome } ).to be true
      end
  
      it 'should not update without title, start/end time, and description' do
        edit_task_with(nil, nil, nil, nil)
        
        error_message = all('ul.error_message > li').map(&:text)
        expected_error_message = [title_error, start_time_error, end_time_error, description_error]
  
        expect(error_message).to eq expected_error_message
      end
  
      it 'without title' do
        edit_task_with(
          nil, 
          new_start_time, 
          new_end_time, 
          new_description, 
          "low", 
          "done"
        )
        
        error_message = all('ul.error_message > li').map(&:text)
        expected_error_message = [title_error]
  
        expect(error_message).to eq expected_error_message
      end
      
      it 'without start_time' do
        edit_task_with(
          title, 
          nil, 
          new_end_time, 
          new_description, 
          "low", 
          "done"
        )
        
        error_message = all('ul.error_message > li').map(&:text)
        expected_error_message = [start_time_error]
  
        expect(error_message).to eq expected_error_message
      end
      
      it 'without end_time' do
        edit_task_with(
          title, 
          new_start_time, 
          nil, 
          new_description, 
          "low", 
          "done"
        )
        
        error_message = all('ul.error_message > li').map(&:text)
        expected_error_message = [end_time_error]
  
        expect(error_message).to eq expected_error_message
      end
      
      it 'without title' do
        edit_task_with(
          title, 
          new_start_time, 
          new_end_time, 
          nil, 
          "low", 
          "done"
        )
        
        error_message = all('ul.error_message > li').map(&:text)
        expected_error_message = [description_error]
  
        expect(error_message).to eq expected_error_message
      end
      

    end

    context 'when deleting a task' do
      it 'should delete the task' do
        create(:task)
        old_task_title = Task.last.title
        old_task_description = Task.last.description

        visit tasks_path
        expect{ click_on I18n.t("tasks.table.delete") }.to change{ Task.count }.by(-1)
  
        expect(page).to have_content(I18n.t("tasks.destroy.notice"))
        expect(page).not_to have_content(old_task_title)
        expect(page).not_to have_content(old_task_description)
      end
    end
  end

  describe 'sorting' do
    before { visit tasks_path }

    context 'by "created_at"' do
      let(:asc_result) { Task.order(created_at: :asc).pluck(:title) }
      let(:desc_result) { Task.order(created_at: :desc).pluck(:title) }

      it 'should render the tasks in ASC order' do
        # initial load
        text_initial_load = all('tr>td:first-child').map(&:text)
        expect(text_initial_load).to eq(asc_result)
        
        # first click: became desc
        click_on I18n.t("tasks.table.created_at")
        text_after_first_click = all('tr>td:first-child').map(&:text)
        expect(text_after_first_click).to eq(desc_result)
        
        # second click: became asc
        click_on I18n.t("tasks.table.created_at")
        text_after_second_click = all('tr>td:first-child').map(&:text)
        expect(text_after_second_click).to eq(asc_result)
      end
  
      it 'should render the tasks in DESC order' do
        # initial load
        text_initial_load = all('tr>td:first-child').map(&:text)
        expect(text_initial_load).to eq(asc_result)
        
        # click: became desc
        click_on I18n.t("tasks.table.created_at")
        text_after_click = all('tr>td:first-child').map(&:text)
        expect(text_after_click).to eq(desc_result)      
      end
    end

    context 'by "end_time"' do
      let(:asc_result) { Task.order(end_time: :asc).pluck(:title) }
      let(:desc_result) { Task.order(end_time: :desc).pluck(:title) }

      it 'should render the tasks in ASC order' do
        # initial load
        text_initial_load = all('tr>td:first-child').map(&:text)
        expect(text_initial_load).to eq(asc_result)
        
        # first click: became desc
        click_on I18n.t("tasks.table.end_time")
        text_after_first_click = all('tr>td:first-child').map(&:text)
        expect(text_after_first_click).to eq(desc_result)
        
        # second click: became asc
        click_on I18n.t("tasks.table.end_time")
        text_after_second_click = all('tr>td:first-child').map(&:text)
        expect(text_after_second_click).to eq(asc_result)
      end
  
      it 'should render the tasks in DESC order' do
        # initial load
        text_initial_load = all('tr>td:first-child').map(&:text)
        expect(text_initial_load).to eq(asc_result)
        
        # click: became desc
        click_on I18n.t("tasks.table.end_time")
        text_after_click = all('tr>td:first-child').map(&:text)
        expect(text_after_click).to eq(desc_result)      
      end
    end

    context 'by "priority"' do
      let(:asc_result) { Task.order(priority: :asc).pluck(:title) }
      let(:desc_result) { Task.order(priority: :desc).pluck(:title) }

      it 'should render the tasks in ASC order' do
        # initial load
        text_initial_load = all('tr>td:first-child').map(&:text)
        expect(text_initial_load).to eq(asc_result)
        
        # first click: became desc
        click_on I18n.t("tasks.table.priority")
        text_after_first_click = all('tr>td:first-child').map(&:text)
        expect(text_after_first_click).to eq(desc_result)
        
        # second click: became asc
        click_on I18n.t("tasks.table.priority")
        text_after_second_click = all('tr>td:first-child').map(&:text)
        expect(text_after_second_click).to eq(asc_result)
      end
  
      it 'should render the tasks in DESC order' do
        # initial load
        text_initial_load = all('tr>td:first-child').map(&:text)
        expect(text_initial_load).to eq(asc_result)
        
        # click: became desc
        click_on I18n.t("tasks.table.priority")
        text_after_click = all('tr>td:first-child').map(&:text)
        expect(text_after_click).to eq(desc_result)      
      end
    end
  end

  describe 'searching' do
    titles = [Faker::Lorem.sentence, Faker::Lorem.sentence, Faker::Lorem.sentence]
    # status: { 0: "pending", 1: "ongoing", 2: "done" }
    before do
      instance_variable_set "@task1", create(:task, title: titles[0], status: 2)
      instance_variable_set "@task2", create(:task, title: titles[1], status: 1)
      instance_variable_set "@task3", create(:task, title: titles[2], status: 0)
      instance_variable_set "@task4", create(:task, title: titles[2], status: 2)
      instance_variable_set "@task5", create(:task, title: titles[1], status: 1)
      
      visit tasks_path
    end
    
    context 'by "title"' do
      it 'should show the result according to search condition' do
        within('form.form_search') do
          fill_in :title, with: @task1.title
          click_on I18n.t("tasks.search_field.submit")
        end

        search_result = all('#table_tasks tr td:first-child').map(&:text)
        expected_outcome = [@task1.title]

        expect(search_result).to eq expected_outcome
      end
    end
    
    context 'by "status"' do
      it 'should show the result according to search condition' do
        within('form.form_search') do
          # select "ongoing"
          select I18n.t("activerecord.attributes.task/status.ongoing"), from: 'status'
          click_on I18n.t("tasks.search_field.submit")
        end

        search_result = all('#table_tasks tr td:first-child').map(&:text)
        expected_outcome = [@task2.title, @task5.title]

        expect(search_result).to eq expected_outcome
      end
    end

    context 'by title and status' do
      it 'should show the result according to search condition' do
        within('form.form_search') do
          fill_in :title, with: @task3.title
          # select "pending"
          select I18n.t("activerecord.attributes.task/status.pending"), from: 'status'
          click_on I18n.t("tasks.search_field.submit")
        end
        
        search_result = all('#table_tasks tr td:first-child').map(&:text)
        expected_outcome = [@task3.title]

        expect(search_result).to eq expected_outcome
      end
    end
  end


  private

  def create_task_with(title, start_time, end_time, description)
    random_priority = ["low", "mid", "high"]
    random_status = ["pending", "ongoing", "done"]

    visit new_task_path

    within('form.form_task') do
      fill_in I18n.t("tasks.table.title"), with: title
      fill_in I18n.t("tasks.table.start_time"), with: start_time
      fill_in I18n.t("tasks.table.end_time"), with: end_time
      select I18n.t("activerecord.attributes.task/priority.#{random_priority.sample}"), from: I18n.t("tasks.table.priority")
      select I18n.t("activerecord.attributes.task/status.#{random_status.sample}"), from: I18n.t("tasks.table.status")
      fill_in I18n.t("tasks.table.description"), with: description

      click_on I18n.t("helpers.submit.task.create", model: I18n.t("activerecord.models.task"))
    end
  end

  def edit_task_with(title, start_time, end_time, description, priority = nil, status = nil)
    random_priority = ["low", "mid", "high"]
    random_status = ["pending", "ongoing", "done"]

    within('form.form_task') do
      fill_in I18n.t("tasks.table.title"), with: title
      fill_in I18n.t("tasks.table.start_time"), with: start_time
      fill_in I18n.t("tasks.table.end_time"), with: end_time

      # Priority/Status nil value handler
      if priority == nil && status == nil
        select I18n.t("activerecord.attributes.task/priority.#{random_priority.sample}"), from: I18n.t("tasks.table.priority")
        select I18n.t("activerecord.attributes.task/status.#{random_status.sample}"), from: I18n.t("tasks.table.status")
      else
        select I18n.t("activerecord.attributes.task/priority.#{priority}"), from: I18n.t("tasks.table.priority")
        select I18n.t("activerecord.attributes.task/status.#{status}"), from: I18n.t("tasks.table.status")
      end
      
      fill_in I18n.t("tasks.table.description"), with: description

      click_on I18n.t("helpers.submit.task.update", model: I18n.t("activerecord.models.task"))
    end
  end

  def the_task_path(title)
    task_path(find_task_by_title(title))
  end

  def the_edit_task_path(title)
    edit_task_path(find_task_by_title(title))
  end

  def find_task_by_title(title)
    Task.find_by(title: title)
  end
end