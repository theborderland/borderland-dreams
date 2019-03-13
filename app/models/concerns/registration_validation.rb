require 'open-uri'

module RegistrationValidation
 extend ActiveSupport::Concern

  included do
    validate :invite_code_valid, on: :create if Rails.configuration.x.firestarter_settings["user_authentication_codes"]
  end

  private

  def invite_code_valid
    self.email = self.email.downcase
    self.errors.add(:ticket_id, I18n.t(:invalid_membership_code))    if !Ticket.exists?(id_code: self.ticket_id)
    self.errors.add(:ticket_id, I18n.t(:invalid_membership_code))    if !Ticket.exists?(email: self.email)
    self.errors.add(:ticket_id, I18n.t(:membership_code_registered)) if User.exists?(ticket_id: self.ticket_id)
    self.errors.add(:ticket_id, I18n.t(:membership_code_registered)) if User.eixsts?(email: self.email)

    # Check if ticket exists in the local database to prevent going to remote server
    return if ticket = Ticket.find_by(id_code: self.ticket_id, email: self.email)

    self.errors.clear if invite_code_remote_tickets_valid
  end

  def invite_code_remote_tickets_valid
    return unless Rails.configuration.x.firestarter_settings["user_authentication_vs_tixwise"] && ENV['TICKETS_EVENT_URL']
    return unless parseTixWiseAsHash[self.email] == self.ticket_id
    return if User.exists?(ticket_id: self.ticket_id) || User.exists?(email: self.email)
    Ticket.create(id_code: self.ticket_id, email: self.email)
  end

  def parseTixWiseAsHash
    event            = Nokogiri::XML(open(ENV['TICKETS_EVENT_URL']))
    tickets          = event.css("tixwise_response RESPONSE event_listPurchases TicketPurchaseItem")
    emailPhoneNumber = tickets.css('TicketPurchaseItem email, TicketPurchaseItem phone_number')
    emailPhoneHash   = Hash.new

    return emailPhoneHash if emailPhoneNumber.length <= 0

    # the array is [email1,phone1,email2,phone2] and we want to hash it
    # Iterate over the array removing the last number
    for i in 0..emailPhoneNumber.length-1
      next if i.odd?
      email = emailPhoneNumber[i].text.downcase
      phonenumber = emailPhoneNumber[i+1].text.tr('-', '')
      emailPhoneHash[email] = phonenumber
    end

    emailPhoneHash
  rescue SocketError => e
    self.errors.add(:ticket_id, e.message)
    puts e.message
  end
end
