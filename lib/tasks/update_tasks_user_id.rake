namespace :db do
  desc 'update tasks user_id'
  task :update_tasks_user_id => :environment do
    print 'update start: '
    if User.any?
      first_user_id = User.first.id
      Task.where( user_id: nil ).each do |task|
        task.user_id = (first_user_id)
        task.save
        print '.'
      end
    else
      'Please create a user first. You have no users to associate tasks with.'
    end
    puts 'finished!'
  end
end