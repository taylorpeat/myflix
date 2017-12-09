class RelationshipsController < ApplicationController
  
  before_filter :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end

  def create
    leader = User.find(params[:leader_id])
    
    if current_user.id != leader.id && !current_user.follows?(leader)
      Relationship.create(follower_id: current_user.id, leader_id: leader.id)
    end

    redirect_to people_path
  end
end