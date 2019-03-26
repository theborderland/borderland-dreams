#!/usr/bin/env ruby
# Dreamy ~ the dumb dreams loomio bot

# TODO
# Don't busy loop
require ::File.expand_path('../../../config/environment', __FILE__)
# require ::File.expand_path('../../lib/loomio/loomio_handler', __FILE__)
require_relative 'processors'
require_relative 'loomio_handler'

@processors_hash = {
  'camp_created': Processors.method(:process_camp_created),
  'other_entry_type': Processors.method(:process_other_entry_type)
}.stringify_keys
@predefined_entry_types = @processors_hash.keys

# run through all log_entry_types and run their processors
def process(log_entry, loomio)
  puts("Processing %s" % log_entry.description)

  @predefined_entry_types.each do |predefined_entry_type|
    if log_entry.entry_type == predefined_entry_type
      @processors_hash[predefined_entry_type].(log_entry, loomio)
      return
    end

  puts("Event I don't care about: %s" % log_entry.entry_type)
  # log_entry.loomio_consumed = true

  puts("Done processing %s" % log_entry.description)
  end
end

def run_bot
  # initialize the handler here so that the authentication doesn't have to be repeated
  loomio = LoomioHandler.new(username=ENV['LOOMIO_BOT_EMAIL'], password=ENV['LOOMIO_BOT_PASSWORD'])
  Thread.new do
    loop do
      LogEntry
        .where("loomio_consumed IS 'f'") # extract all log_entries that haven't been processed yet
        .each { |log_entry|
          process(log_entry, loomio)
        }
      sleep 1
    end
  end
end

