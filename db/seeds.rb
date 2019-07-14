# 100.times do
#   FactoryBot.create(:task)
# end
User.where(email: 'email@email.com').first_or_create(password: '111111', role: 'admin').update(password: '111111', role: 'admin')