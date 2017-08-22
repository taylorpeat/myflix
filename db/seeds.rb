['family_guy', 'futurama', 'monk', 'south_park'].each do |video_name|
  image_url = '/tmp/' + video_name + '.jpg'
  Video.create(cover_image_url: image_url)
end