class Invitation < ActiveRecord::Base
  validates_presence_of :recipient_name, :recipient_email, :message, :inviter_id
end