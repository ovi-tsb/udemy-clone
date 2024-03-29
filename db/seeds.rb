# User.create!(email: '1@yahoo.com', password: '123456', password_confirmation: '123456')
# User.create!(email: '2@yahoo.com', password: '123456', password_confirmation: '123456')
#user = User.new(
#  email: 'admin@example.com', 
#  password: 'admin@example.com', 
#  password_confirmation: 'admin@example.com'
#)
#user.skip_confirmation!
#user.save!

PublicActivity.enabled = false
30.times do
  Course.create!([{
    title: Faker::Educator.course_name,
    description: Faker::TvShows::GameOfThrones.quote,
    user_id: "1",
    short_description: Faker::Quote.famous_last_words,
    language: Faker::Address.country,
    level: 'Beginner',
    price: Faker::Number.between(from: 100, to: 250)
  }])
end

PublicActivity.enabled = true