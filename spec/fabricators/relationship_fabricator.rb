Fabricator(:relationship) do
  follower_id { Fabricate(:user).id }
  leader_id { Fabricate(:user).id }
end