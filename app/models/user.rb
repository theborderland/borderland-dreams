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
    self.email = self.email.downcase
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
      if User.exists?(email: self.email)
        self.errors.add(:ticket_id, I18n.t(:membership_code_registered))
        return
      end
    end
  end

  def invite_code_remote_tickets_valid
    if Rails.configuration.x.firestarter_settings["user_authentication_vs_tixwise"] and ENV['TICKETS_EVENT_URL'].present?
      emailPhoneNumber = parseTixWiseAsHash() 
      if emailPhoneNumber[self.email] == self.ticket_id
        # Check that user not already created manually
        if User.exists?(ticket_id: self.ticket_id)
          return false #Errors was set in the earlier local function
        end
        if User.exists?(email: self.email)
          return false #Errors was set in the earlier local function
        end
        # Create a ticket in our system to prevent duplicate sign ups
        unless Ticket.exists?(email: self.email) and Ticket.exists?(id_code: self.ticket_id)
          Ticket.create(:id_code => self.ticket_id, :email => self.email)
        end
        return true
      end
      return false
    end
  end

  def parseTixWiseAsHash
    require 'open-uri'
      begin
        event = Nokogiri::XML(open(ENV['TICKETS_EVENT_URL']))
        tickets = event.css("tixwise_response RESPONSE event_listPurchases TicketPurchaseItem")
        emailPhoneNumber = tickets.css('TicketPurchaseItem email, TicketPurchaseItem phone_number')

        emailPhoneHash = Hash.new
        if emailPhoneNumber.length <= 0
          return emailPhoneHash
        end

        # the array is [email1,phone1,email2,phone2] and we want to hash it
        # Iterate over the array removing the last number
        for i in 0..emailPhoneNumber.length-1
          next if i.odd?
          email = emailPhoneNumber[i].text.downcase
          phonenumber = emailPhoneNumber[i+1].text.tr('-', '')
          emailPhoneHash[email] = phonenumber
        end
        return emailPhoneHash

      rescue SocketError => e
        self.errors.add(:ticket_id, e.message)
        puts e.message
    end
  end
  
end
