# Dreamy ~ the dumb dreams loomio bot

require ::File.expand_path('../../../config/environment', __FILE__)

puts("aaa")
puts(LogItem)

loop do
  # get new unprocessed events
  # for each event
  # process(event)
  sleep 1
end

def process(l)
  case l.type
  when :camp_created
    r = loomio.create_thread()
    l.object_id.loomio_thread_id = r
    l.processed = true
  else
    puts("Event I don't care about: %s" % l.type)
    l.processed = true
  end
  l.save
end

