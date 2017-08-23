['family_guy', 'futurama', 'monk', 'south_park'].each do |video_name|
  image_url = '/tmp/' + video_name + '.jpg'
  Video.create(
    title: video_name.titleize,
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.',
    cover_image_url: image_url,
    rating: 4.5,
  )
end