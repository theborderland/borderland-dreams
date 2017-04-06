# to import run bundle exec rake importtixwise

require 'rest-client'
require 'json'

desc "Import Ticket from tickets events url"
task :import_burnertickets => [:environment] do

  file = ENV['TICKETS_EVENT_URL']
  if file.nil?
  	puts "Error: Please set env TICKETS_EVENT_URL"
  	next
  end

  begin
    counter = 0
    ignoredCounter = 0
    updatedCounter = 0
    response = RestClient.post(ENV['TICKETS_EVENT_URL'], {'method' => 'GetUsersWithTicketsEventId', 'eventId' => ENV['BURNER_TICKETS_EVENT_ID'], 'apiKey' => ENV['BURNER_TICKETS_API_KEY']})
    parsedResponse = JSON.parse(response.body)
    burnerTickets = parsedResponse["message"]
    puts "Found " + burnerTickets.length.to_s + " tickets"
    burnerTickets.each do |burnerTicket|

      email = burnerTicket["EmailAddress"].downcase
      ticket_id = burnerTicket["TicketNumber"]
      userId = burnerTicket["UserId"]

      unless Ticket.exists?(id_code: ticket_id)
        counter+=1
        Ticket.create(:id_code => ticket_id, :email => email.downcase, :remote_user_id => userId)
        puts "Added email: " + email + ", BurnerTickets ID: " + userId + ", ticket ID: " + ticket_id
      else
        unless Ticket.exists?(email: email)
          puts "Found ticket to transfer"
          ticket = Ticket.find_by(id_code: ticket_id)
          ticket.update(email: email);
          ticket.update(remote_user_id: userId)
          puts "Transferred ticket" + ticket_id + " to " + email
          updatedCounter+=1
          else
            ignoredCounter+=1
          end
        end
      end
  rescue SocketError => e
    self.errors.add(:ticket_id, e.message)
    puts e.message
  end

  puts "Added " + counter.to_s + " Tickets to our database"
  puts "Found " + counter.to_s + " Tickets that are allready in the database"
  puts "Transferred " + counter.to_s + " Tickets to new burners"

end