class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :tickets
  has_many :memberships
  has_many :camps, through: :memberships

  # Again, from Rails Girls tutorial on Facebook auth.
  # Used for handling the facebook auth callback.

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      #user.name = auth.info.name # We don't persist usernames to the DB.
    end
  end

   validate :invite_code_valid, :on => :create

  def invite_code_valid
    if Rails.configuration.x.firestarter_settings["user_authentication_codes"]
      unless Ticket.exists?(id_code: self.ticket_id)
        self.errors.add(:ticket_id, I18n.t(:invalid_membership_code))
        return
      end
      if User.exists?(ticket_id: self.ticket_id)
        self.errors.add(:ticket_id, I18n.t(:membership_code_registered))
      end
    end
  end
  
end
