# frozen_string_literal: true

require "uri"
require "net/http"
require "openssl"

module RapidApi
  class SynonymProviderService
    def initialize(word)
      @word = word
    end

    def call!
      url = URI(URI.encode("https://wordsapiv1.p.rapidapi.com/words/#{@word}/synonyms"))

      # Instanties a client
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      # Set a header
      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-host"] = "wordsapiv1.p.rapidapi.com"
      request["x-rapidapi-key"] = ENV["RAPIDAPI_KEY"]

      response = http.request(request)
      JSON.parse(response.read_body)["synonyms"]
    end
  end
end
