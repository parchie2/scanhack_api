# frozen_string_literal: true

module Api
  module V1
    class TranslateController < ApplicationController
      def show
        translations = GoogleCloud::TranslatorService.new(["財布"]).call!
        render status: :ok, json: { translations: translations }
      rescue StandardError => error
        Rails.logger.error error
        render status: :unprocessable_entity
      end
    end
  end
end
