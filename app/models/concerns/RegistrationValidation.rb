module RegistrationValidation
 extend ActiveSupport::Concern

  included do
    if Rails.configuration.x.firestarter_settings["user_authentication_vs_tixwise"]
      validate :invite_code_valid, :on => :create
    end
  end

  def invite_code_valid
    self.email = self.email.downcase
    invite_code_local_tickets_valid()
    # Check if ticket exists in the local database to prevent going to remote server
    ticket = Ticket.find_by(id_code: self.ticket_id, email: self.email)
    if ticket.present?
      return
    end
  end

  def invite_code_local_tickets_valid
    if Rails.configuration.x.firestarter_settings["user_authentication_vs_tixwise"]
      unless Ticket.exists?(email: self.email)
        self.errors.add(:ticket_id, I18n.t(:invalid_membership_code))
        return
      end
      if User.exists?(email: self.email)
        self.errors.add(:ticket_id, I18n.t(:membership_code_registered))
        return
      end
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


