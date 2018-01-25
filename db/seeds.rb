require 'bcrypt'
require 'faker'

videos = [
  { title: 'Breaking Bad', category_id: 2, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/Breaking_Bad.mp4", description: "A high-school chemistry teacher learns he's dying, so he takes up a new career as a meth producer in hopes of earning enough money to take care of his family." },
  { title: 'Brooklyn Nine-Nine', category_id: 1, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/Brooklyn_Nine-Nine.mp4", description: "A sitcom following the lives of a group of detectives in a New York precinct, including one slacker who is forced to shape up when he gets a new boss." },
  { title: 'Family Guy', category_id: 1, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/Family+Guy.mp4", description: "Animated antics of the constantly grousing Griffins, a family that put some fun in dysfunctional. While dad Peter is a tad dim and lazy, mum Lois is none of the above. Then there are hapless teens Meg and Chris; sassy baby Stewie, who's wise (and a wise guy) beyond his years; and family dog Brian, who might be the smartest of the lot." },
  { title: 'Futurama', category_id: 1, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/Futurama.mp4", description: "Sharply satiric animation about a man from 1999 who thaws out on the eve of the 31st century. An Emmy-winning work cocreated by Matt Groening (`The Simpsons'), it had a `thaw' of its own, of sorts, after it ended its five-year Fox run, during which time it was too often pre-empted by pro-football overruns. After it left the network, however, the irreverent `Futurama' demonstrated that it still had a future, scoring big in cable reruns and DVD sales." },
  { title: 'Game of Thrones', category_id: 2, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/Game_of_Thrones.mp4", description: "An adaptation of author George R.R. Martin's \"A Song of Ice and Fire\" medieval fantasies about power struggles among the Seven Kingdoms of Westeros." },
  { title: "Grey's Anatomy", category_id: 2, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/Grey's_Anatomy.mp4", description: "Doctors at a Seattle teaching hospital hone their bedside manners on and off the job in this medical drama." },
  { title: 'Justified', category_id: 2, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/Justified.mp4", description: "A maverick U.S marshal enforces the law his way in his Kentucky hometown." },
  { title: 'Kitchen Nightmares', category_id: 3, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/Kitchen_Nightmares.mp4", description: "A reality series following chef Gordon Ramsay's attempts to turn around troubled restaurants. Based on the popular British show." },
  { title: 'Modern Family', category_id: 1, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/Modern_Family.mp4", description: "A mockumentary-style sitcom chronicling the unusual kinship of the extended Pritchett clan, a brood that includes patriarch Jay; his younger Latina wife, Gloria, and her son; Jay's daughter, Claire, and her family; and Jay's son, Mitchell, who lives with his partner, Cameron.
" },
  { title: 'Monk', category_id: 2, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/Monk.mp4", description: "An ex-cop suffering from obsessive-compulsive disorder solves crimes with various (and usually exasperated) sidekicks in tow in this first-rate mystery with a breakout Emmy-winning star in Tony Shalhoub. The 'defective detective' may have an abundance of phobias (heights, crowds, and even milk, among them), but he also has razor-sharp deductive skills, which he uses to help the San Francisco police with especially baffling cases." },
  { title: 'Stranger Things', category_id: 2, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/Stranger_Things.mp4", description: "A love letter to the '80s classics that captivated a generation, Stranger Things is set in 1983 Indiana, where a young boy vanishes into thin air. As friends, family and local police search for answers, they are drawn into an extraordinary mystery involving top-secret government experiments, terrifying supernatural forces and one very strange little girl." },
  { title: 'Survivor', category_id: 3, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/Survivor.mp4", description: "Eighteen castaways compete with and against loved ones in a \"Blood vs. Water\" style competition that reintroduces Exile Island to the game." },
  { title: 'The Office', category_id: 1, video_url: "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/video/The_Office.mp4", description: "Based on the award-winning British comedy of the same name, this acclaimed sitcom is told through the lenses of a documentary film crew and filled with gossip, pranks, romance and general foolishness at Dunder-Mifflin Paper Co. in Scranton, Pennsylvania. If you've ever hated your boss, your job or both, then you'll love this show." },
]

categories = [
  { name: 'comedy', title: 'TV Comedies' },
  { name: 'drama', title: 'TV Drama' },
  { name: 'reality', title: 'Reality TV' },
]

users = [
  { email: 'admin@example.com', password_digest: "$2a$04$jt9w7m/FbKm7YkjUiuboyOUHxvLwUR9lOfwJaToLoKoIUHwc4wJ3S", full_name: 'Admin User', admin: true },
  { email: 'arnold@example.com', password_digest: "$2a$04$jt9w7m/FbKm7YkjUiuboyOUHxvLwUR9lOfwJaToLoKoIUHwc4wJ3S", full_name: 'Arnold Hobbs' },
  { email: 'bill@example.com', password_digest: "$2a$04$jt9w7m/FbKm7YkjUiuboyOUHxvLwUR9lOfwJaToLoKoIUHwc4wJ3S", full_name: 'Bill Gates' },
  { email: 'charles@example.com', password_digest: "$2a$04$jt9w7m/FbKm7YkjUiuboyOUHxvLwUR9lOfwJaToLoKoIUHwc4wJ3S", full_name: 'Charlie Kettle' },
  { email: 'doug@example.com', password_digest: "$2a$04$jt9w7m/FbKm7YkjUiuboyOUHxvLwUR9lOfwJaToLoKoIUHwc4wJ3S", full_name: 'Douglas Davies' },
]

videos.each do |video|
  video[:remote_small_cover_url] = "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/small_cover/" + video[:title].downcase.gsub(" ", "_").delete("'") + ".jpg"
  video[:remote_large_cover_url] = "https://s3.us-east-2.amazonaws.com/myflix-staging-tpeat/uploads/video/large_cover/" + video[:title].downcase.gsub(" ", "_").delete("'") + "_large" + ".jpg"
end

Video.create(videos)


Category.create(categories)

User.create(users)

reviews = []

User.all.each do |user|
  video_ids = Video.all.pluck('id')
  
  video_ids.sample(6).each do |video_id|
    reviews << { rating: [1,1.5,2,2.5,3,3.5,4,4.5,5].sample, content: Faker::Lorem.paragraph(3), user_id: user.id, video_id: video_id }
  end

  video_ids.sample([1,2,3,4].sample).each_with_index do |video_id, idx|
    user.queue_items.create({ video_id: video_id, position: idx })
  end
end

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