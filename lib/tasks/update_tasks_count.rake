namespace :db do
  desc 'update tasks count'
  task :update_tasks_count => :environment do
    print 'update start: '
    User.all.each do |user|
      User.reset_counters(user.id, :tasks)
      print '.'
    end
    puts 'finished!'
  end
end