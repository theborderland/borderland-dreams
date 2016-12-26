require 'googleauth/stores/file_token_store'
require 'googleauth/token_store'

# Implementation of google auth storage backed by ENV variable
# Gal Bracha
class EnvTokenStore < Google::Auth::TokenStore

  @token = ''

  def initialize(options = {})
    @token = options
    puts 'Init tokens with ' + options
  end

  # (see Google::Auth::Stores::TokenStore#load)
  def load(id)
    puts 'load token ' + id
    return ENV[@token]
  end

  def store(id, token)
    puts 'Great! Now Please set it manually in the env variable ' + @token
    puts id
    puts token
    # @store.transaction { @store[id] = token }
  end

  # (see Google::Auth::Stores::TokenStore#delete)
  def delete(id)
    puts 'delete ' + id
    puts 'Not implemented'
    # @store.transaction { @store.delete(id) }
  end
end