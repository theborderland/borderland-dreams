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
    tickets = parsedResponse["message"]
    puts "Found " + tickets.length.to_s + " tickets"
    tickets.each do |ticket|

      email = ticket["EmailAddress"].downcase
      ticket_id = ticket["TicketNumber"]
      userId = ticket["UserId"]

      unless Ticket.exists?(id_code: ticket_id)
        counter+=1
        Ticket.create(:id_code => ticket_id, :email => email.downcase, :remote_user_id => userId)
        puts "Added email: " + email + ", BurnerTickets ID: " + userId + ", ticket ID: " + ticket_id
      else
        unless Ticket.exists?(id_code: ticket_id) and Ticket.exists?(email: email)
          ticket = Ticket.find_by(id_code: ticket_id)
          ticket.email = email
          ticket.remote_user_id = userId
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