class Invitation < ActiveRecord::Base
  validates_presence_of :recipient_name, :recipient_email, :message, :inviter_id

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end