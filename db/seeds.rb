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

Video.create(videos) do |video|
  video[:description] = 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.'
  video[:cover_image_url] = '/tmp/' + video[:title] + '.jpg'
end

Category.create(categories)

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