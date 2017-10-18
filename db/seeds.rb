require 'bcrypt'
require 'faker'

videos = [
  { title: 'family_guy', rating: 4.5, category_id: 1 },
  { title: 'futurama',   rating: 4.0, category_id: 1 },
  { title: 'monk', rating: 3.0, category_id: 2 },
  { title: 'south_park', rating: 3.5, category_id: 3 },
]

categories = [
  { name: 'comedy', title: 'TV Comedies' },
  { name: 'drama', title: 'TV Drama' },
  { name: 'reality', title: 'Reality TV' },
]

users = [
  { email: 't@t.com', password_digest: "$2a$04$jt9w7m/FbKm7YkjUiuboyOUHxvLwUR9lOfwJaToLoKoIUHwc4wJ3S", full_name: 'Taylor Peat' }
]


Video.create(videos) do |video|
  video[:description] = 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.'
  video[:cover_image_url] = '/tmp/' + video[:title] + '.jpg'
end

Category.create(categories)

User.create(users)

reviews = [
  { rating: 5, content: Faker::Lorem.paragraph(3), user_id: User.first.id, video_id: Video.first.id },
  { rating: 2, content: Faker::Lorem.paragraph(3), user_id: User.first.id, video_id: Video.first.id },
  { rating: 3, content: Faker::Lorem.paragraph(3), user_id: User.first.id, video_id: Video.second.id },
]

Review.create(reviews)


# videos.each do |video|
#   image_url = '/tmp/' + video[:name] + '.jpg'
#   Video.create(
#     title: video[:name].titleize,
#     description: 
#     cover_image_url: image_url,
#     rating: video[:rating],
#     category: video[:category]
#   )
# end

# categories.each do |category|
#   Category.create(
#     name: category[:name],
#     title: category[:title],
#   )
# end