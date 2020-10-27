# frozen_string_literal: true

require 'net/http'

class ItemsController < ApplicationController
  def index
    params = URI.encode_www_form(appid: ENV.fetch('APP_ID'), jan_code: '49810721')
    uri = URI.parse("https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?#{params}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    response = https.start do |http|
      http.open_timeout = 5
      http.read_timeout = 10
      http.get(uri.request_uri)
    end
    begin
      case response
      when Net::HTTPSuccess
        @result = JSON.parse(response.body)
        render json: { massege: @result }
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue IOError => e
      @message = 'e.message'
    rescue TimeoutError => e
      @message = 'e.message'
    rescue JSON::ParserError => e
      @message = 'e.message'
    rescue StandardError => e
      @message = 'e.message'
    end
  end
end
