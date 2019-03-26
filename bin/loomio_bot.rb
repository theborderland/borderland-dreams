#!/usr/bin/env ruby -w
# Dreamy ~ the dumb dreams loomio bot

# TODO
# Don't busy loop


require ::File.expand_path('../../../config/environment', __FILE__)
require_relative 'loomio_handler'

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
    puts("Processing %s" % l.text)
    camp = Camp.find(l.object_id)
    loomio = LoomioHandler.new(username=ENV['LOOMIO_BOT_EMAIL'], password=ENV['LOOMIO_BOT_PASSWORD'])
    r = loomio.create_thread(camp.name)
    camp.loomio_thread_id = r
    l.processed = true
  else
    puts("Event I don't care about: %s" % l.type)
    l.processed = true
  end
  l.save
end

