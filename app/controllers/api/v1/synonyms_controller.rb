# frozen_string_literal: true

module Api
  module V1
    class SynonymsController < ApplicationController
      def show
        synonyms = RapidApi::SynonymProviderService.new("wallet").call!
        render status: :ok, json: { synonyms: synonyms }
      rescue StandardError => error
        Rails.logger.error error
        render status: :unprocessable_entity
      end
    end
  end
end
