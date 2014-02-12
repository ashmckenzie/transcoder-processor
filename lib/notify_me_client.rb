require 'uri'
require 'net/http'
require 'json'

class NotifyMeClient

  class Response

    SUCCESS_CODE = 200

    attr_reader :response

    def initialize response
      @response = response
    end

    def success?
      code == SUCCESS_CODE
    end

    def code
      response.code.to_i
    end

    def body
      JSON.parse(response.body)
    end
  end

  #----------------------------------------------------------------------------#

  BASE_URI = 'http://notify-me.the-rebellion.net'

  def initialize api_key
    @api_key = api_key
  end

  def notify! title, message
    data = { api_key: api_key, title: title, message: message }

    Response.new(Net::HTTP.post_form(uri, data))
  end

  private

    attr_reader :api_key

    def uri
      @uri ||= URI.parse(BASE_URI)
    end

end
