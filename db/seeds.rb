[
  { name: 'family_guy', rating: 4.5, category: 'comedy' },
  { name: 'futurama',   rating: 4.0, category: 'comedy' },
  { name: 'monk', rating: 3.0, category: 'drama' },
  { name: 'south_park', rating: 3.5, category: 'reality' },
].each do |video|
  image_url = '/tmp/' + video[:name] + '.jpg'
  Video.create(
    title: video[:name].titleize,
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.',
    cover_image_url: image_url,
    rating: video[:rating],
    category: video[:category]
  )
end