require 'httparty'

class LoomioHandler
  include HTTParty
  @@base_uri = 'https://talk.theborderland.se/'
  @@sessions_uri = 'api/v1/sessions'
  @@comments_uri = 'api/v1/comments'
  @@threads_uri = 'api/v1/discussions'

  def initialize(username, password)
    user = {user:{email:username,password:password}}
    security_response = self.class.post(@@base_uri + @@sessions_uri, body: user)

    @security_cookies = self.parse_set_cookie(security_response.headers['set-cookie'])
    self.class.default_cookies.add_cookies(@security_cookies)

    @headers = {
      'Content-Type': 'application/json'
    }
  end

  def new_thread(name)
    response = self.class.post(
      @@base_uri + @@threads_uri, 
      body: {"discussion":{"title":name,"description":"","group_id":1259,"private":false,"forked_event_ids":[],"document_ids":[]}}.to_json,
      headers: @headers
    )
    return response['events'][0]['eventable_id'];
  end

  def new_comment(name, discussion_id)
    response = self.class.post(
      @@base_uri + @@comments_uri, 
      body: {"comment":{"body":name,"discussion_id":discussion_id,"document_ids":[]}}.to_json,
      headers: @headers
    )
  end

  def parse_set_cookie(all_cookies_string)
    cookies = Hash.new
  
    # if all_cookies_string.present?
    # single cookies are devided with comma
    all_cookies_string.split(',').each {
      # @type [String] cookie_string
        |single_cookie_string|
      # parts of single cookie are seperated by semicolon; first part is key and value of this cookie
      # @type [String]
      cookie_part_string  = single_cookie_string.strip.split(';')[0]
      # remove whitespaces at beginning and end in place and split at '='
      # @type [Array]
      cookie_part         = cookie_part_string.strip.split('=')
      # @type [String]
      key                 = cookie_part[0]
      # @type [String]
      value               = cookie_part[1]

      # add cookie to Hash
      cookies[key] = value
    }
  
    cookies
  end
end

lh = LoomioHandler.new(username=ENV['LOOMIO_BOT_EMAIL'], password=ENV['LOOMIO_BOT_PASSWORD'])
disc_id = lh.new_thread('CONCEPTUALIZE THIS')
lh.new_comment('First comment!', disc_id)
