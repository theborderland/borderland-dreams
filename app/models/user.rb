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
    invite_code_local_tickets_valid()
    if invite_code_remote_tickets_valid()
      # Found the user in database - clear old errors local database not found
      self.errors.clear
      return
    end
  end

  def invite_code_local_tickets_valid
    if Rails.configuration.x.firestarter_settings["user_authentication_codes"]
      unless Ticket.exists?(id_code: self.ticket_id)
        self.errors.add(:ticket_id, I18n.t(:invalid_membership_code))
        return
      end
      unless Ticket.exists?(email: self.email)
        self.errors.add(:ticket_id, I18n.t(:invalid_membership_code))
        return
      end
      if User.exists?(ticket_id: self.ticket_id)
        self.errors.add(:ticket_id, I18n.t(:membership_code_registered))
        return
      end
    end
  end

  def invite_code_remote_tickets_valid
    if Rails.configuration.x.firestarter_settings["user_authentication_vs_ticks"] and ENV['TICKS_EVENT_URL'].present?
      require 'open-uri'
      require 'json'
      begin
        event = JSON.parse(open(ENV['TICKS_EVENT_URL']).read)
      rescue SocketError => e
        self.errors.add(:ticket_id, e.message)
        puts e.message
        return
      end

      # TODO: parse event data - will be possible once the ticketing system will be online
      # Validate email and given self.ticket_id
      # mockedTicketId = '6687'
      # mockedEmail = ''
      # if (mockedTicketId != self.ticket_id)
      #   # No need to write this as it will output from the next section
      #   if !Rails.configuration.x.firestarter_settings["user_authentication_codes"]
      #     self.errors.add(:ticket_id, I18n.t(:invalid_membership_code))
      #   end
      #   return false
      # else
      #   Ticket.create(:id_code => self.ticket_id, :email => self.email)
      #   return true
      # end
      return false
    end
  end
  
end
