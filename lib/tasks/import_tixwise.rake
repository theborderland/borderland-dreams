# to import run bundle exec rake importtixwise

desc "Import Ticket from tickets events url"
task :import_tixwise => [:environment] do

  file = ENV['TICKETS_EVENT_URL']
  if file.nil?
  	puts "Error: Please set env TICKETS_EVENT_URL"
  	next
  end

  require 'open-uri'
    begin
      event = Nokogiri::XML(open(ENV['TICKETS_EVENT_URL']))
      tickets = event.css("tixwise_response RESPONSE event_listPurchases TicketPurchaseItem")
      emailPhoneNumber = tickets.css('TicketPurchaseItem email, TicketPurchaseItem phone_number')

      emailPhoneHash = Hash.new
      if emailPhoneNumber.length <= 0
        puts "No emails phone found in the given url"
        return
      end

      # the array is [email1,phone1,email2,phone2] and we want to hash it
      # Iterate over the array removing the last number
      for i in 0..emailPhoneNumber.length-1
        next if i.odd?
        email = emailPhoneNumber[i].text.downcase
        phonenumber = emailPhoneNumber[i+1].text.tr('-', '')
        emailPhoneHash[email] = phonenumber
      end

    rescue SocketError => e
      self.errors.add(:ticket_id, e.message)
      puts e.message
  end


  counter = 0
  puts "Found " + emailPhoneHash.length.to_s + " tickets"
  emailPhoneHash.each do |email, phone|
    unless Ticket.exists?(email: email) and Ticket.exists?(id_code: phone)
      Ticket.create(:id_code => phone, :email => email)
      counter+=1
    end
  end
  puts "Added " + counter.to_s + " Tickets to our database"

end