puts 'Seeding DB ' + '*'* 100

# Creates 10 users
ActiveRecord::Base.transaction do
  10.times do |user|
    user                       = User.new
    user.name                  = Faker::Name.name
    user.email                 = Faker::Internet.email
    user.password              = 'test@1234'
    user.password_confirmation = 'test@1234'
    user.save!
    puts user.email
  end
end

puts 'End of Seed' + '*'* 100
