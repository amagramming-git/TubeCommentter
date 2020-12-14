# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "Admin User",
    email: ENV.fetch('ADMIN_USER_EMAIL'),
    password:              ENV.fetch('ADMIN_USER_PASSWORD'),
    password_confirmation: ENV.fetch('ADMIN_USER_PASSWORD'),
    admin: true,
    activated: true,
    activated_at: Time.zone.now)

User.create!(name:  "Sample User",
      email: "sample@railstutorial.org",
      password:              "password",
      password_confirmation: "password",
      activated: true,
      activated_at: Time.zone.now)

30.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(name:  name,
    email: email,
    password:              password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
10.times do
  content = "インリビング" + Faker::Lorem.sentence(5) 
  users.each { |user| user.microposts.create!(content: content,video_id: "3ZMuehY9tiE") }
end
10.times do
  content = "てかてか" +Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content,video_id: "X_zCy0fMjIM") }
end
10.times do
  content = "中田" +Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content,video_id: "HaTDjEhdDfc") }
end
10.times do
  content = "モノマネ" +Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content,video_id: "xkxnDK8NZj0") }
end


# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }