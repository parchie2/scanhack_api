# frozen_string_literal: true

module Api
  module V1
    class TranslateController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      def show
        label_annotations = ["Wallet", "Coin purse"]
        synonyms = []
        label_annotations.each do |label_annotation|
          synonyms << RapidApi::SynonymProviderService.new(label_annotation).call!
          synonyms.push(label_annotation)
          rescue StandardError => error
            synonyms << []
            synonyms.push(label_annotation)
        end
        binding.pry
        down_syonyms = synonyms.flatten.map(&:downcase)
        binding.pry
        translations = GoogleCloud::TranslatorService.new(current_send_user.items.map(&:name)).call!.map(&:downcase)
        losts = translations - down_syonyms
        lost_indexes = losts.map{|lost| translations.index(lost)}
        lost_data = lost_indexes.map{|lost_index| current_send_user.items.map(&:name)[lost_index]}

        render status: :ok, json: { data: lost_data }
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
