require 'bcrypt'
require 'faker'

videos = [
  { title: 'Family Guy', rating: 4.5, category_id: 1, video_url: "https://n2158.thevideo.me:8777/trcgnjj6723hu37wrbood5ctgecesdacf2qjovrdhtv4c2pcpyvo7typv6ze5o2qroxhulz3swwhwxfzbcnhuxqqm3aw3k3jvbshkps6udgdpfgqg7k6rnlxywiao5ypotrv345dlnlqn5l3lvj72b2roozq6owj3jmz7564jvyz63q2j2iiq72vlfsusg7nhv4o3bu2oqjjnc5cb45sqx5fdgiuvsujwkoirvthpw7dnouxacc7iayomhpyewgryaewbciiiczhyrciph5gqviexl5q/v.mp4?direct=false&ua=1&vt=gx52xe24tfjhaclroka4h4badnfjxkkh66h4ihtsbungafn6icz5xuw3vi62eqq6f55cybgskiphhlxtxfw5tzi6ab7u2kqrujhzzntkodi4kyfgkbm6am776dqh5txlwwdkh32twqyh3qfu2tlcmz7ow766loysni73czhacyrskthe5mlutsuh7snmv3unetzc7i3ixaljcubilbltlktzp3o4apck7nsclqh6okxy4y2l2xmdsfmxl6xr5sefkuo7myounptisitmlwyssftxfm" },
  { title: 'Futurama',   rating: 4.0, category_id: 1, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/videoplayback.3gp" },
  { title: 'Monk', rating: 3.0, category_id: 2, video_url: "https://n2741.thevideo.me:8777/tzcgm2gbbg3hu37wrbq6pkaqf5krhfgy2c6v2feihpa4cl45xk7o2wyxwpoqkmlavequ26nu4mhdyxdna3ywbpsph7k5g7aiv6i2o7imgxurcye6am6knyvvrkw2zfqjpz5lpioik5dm3hgl6hlxyokqtdmd4w2lal3x4k6wpztlynnjjctlsie4l4aoj2rpoozrg2zb2c3l5nld6ercrxczpfvtr5owl4plm4sejy3c6vp4zkgq5tdiispo5hnynx4nybbafqb2evoushub75a6r5fq/v.mp4?direct=false&ua=1&vt=ng4llha2yfidggdcplomh4cz7mcm2adsthxedagsinh2ygpnccgfhjkzafqqxukq6c2cam2xv23rzevt5lab3ontgien7g4gxtxlpmybvyqtjuft2jmsywfkxe4xnyzgxazn5rtva2lx6pa64msem4kdn4nmzzatx6gtmelcvwj2hjw2t2plobyq5eoamwwyllnk6tddcgfq447aw4cp7ykb6t4jqyhd4p622tx2qllkjlrkjkxeftu5aog7wp6ur5bgwawbngkvz5bieujb3sueby" },
  { title: 'South Park', rating: 3.5, category_id: 3, video_url: "https://n5587.thevideo.me:8777/ojcgnibylc3hu37wrd36372ugfru6w3dph3lsaujmconb4ioupq5dpdzzubfoygp2qlxo6law6hglmihy7ffvygso73esad4pqfwndn64niekpsh7dj2aequrd75ccdodc4m457mqyxbowl56l7263jixlclfoup2jnjzxfbn4m5nyn6ey6if5usmevsy4qjbrfqr3tmd737apv2svh4bh7kty2yi6s5ptuf2hrzgulk7nuryunhgudomrkpwa7bp7b3hgwpkhh4k3vxzzptpvs5isua/v.mp4?direct=false&ua=1&vt=h36kxsc63vlgmhdpf6n4h4bbwv6hrozreqiitrn7lnvvylsuwg2i7bsrwqv3lrwinmpgvgezczati7ouonop6zgu7dh4odw2h5wc3stje7qqyuonbolrsdqs5ucahw3ieyzbywujioguscrvt2j7bcr43w6lasvlazbgc6d77rlrzv2yypeenvvhwwn2g2ox44xyxyhr4nrpb2n4cypk5d45aucos6yga3xpishisq763v7x6thlbuzcqocsmoqocx6ksls25djrirpy3uqwk32osi" },
]

categories = [
  { name: 'comedy', title: 'TV Comedies' },
  { name: 'drama', title: 'TV Drama' },
  { name: 'reality', title: 'Reality TV' },
]

users = [
  { email: 't@t.com', password_digest: "$2a$04$jt9w7m/FbKm7YkjUiuboyOUHxvLwUR9lOfwJaToLoKoIUHwc4wJ3S", full_name: 'Taylor Peat', admin: true }
]

Video.create(videos) do |video|
  video[:description] = 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.'
  video.small_cover = File.open(Rails.root.join("public/tmp/" + video.title.downcase.gsub(" ", "_") + ".jpg"))
  video.large_cover = File.open(Rails.root.join("public/tmp/monk_large.jpg"))
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