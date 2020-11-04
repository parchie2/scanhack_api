# frozen_string_literal: true

module Api
  module V1
    class TranslateController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      def show
        binding.pry
        synonyms = RapidApi::SynonymProviderService.new(["bug", "wallet"]).call!
        translations = GoogleCloud::TranslatorService.new(current_send_user.items.map(&:name)).call!
        binding.pry
        render status: :ok, json: { translations: translations }
      rescue StandardError => error
        Rails.logger.error error
        render status: :unprocessable_entity
      end
      private
      def current_send_user
        authenticate_or_request_with_http_token do |token, _options|
          User.find_by(token: token)
        end
      end

      def authenticate
        authenticate_or_request_with_http_token do |token, _options|
          User.exists?(token: token)
        end
      end
    end
  end
end
