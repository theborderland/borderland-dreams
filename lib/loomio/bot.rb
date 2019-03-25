# Dreamy ~ the dumb dreams loomio bot

# TODO
# Don't busy loop


require ::File.expand_path('../../../config/environment', __FILE__)

@last_id = 0

loop do
  LogEntry
    .where("id > ? AND loomio_consumed IS (NULL or FALSE)", @last_id)
    .each { |e|
      process(e)
    }
  sleep 1
end

def process(l)
  case l.type
  when :camp_created
    camp = l.object_id
    r = loomio.create_thread(camp.name, camp.description)
    l.object_id.loomio_thread_id = r
    l.processed = true
  else
    puts("Event I don't care about: %s" % l.type)
    l.processed = true
  end
  l.save
end

