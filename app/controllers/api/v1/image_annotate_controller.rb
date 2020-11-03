# frozen_string_literal: true

module Api
  module V1
    class ImageAnnotateController < ApplicationController
      def show
        file_path = "tmp/#{current_user.id}"
        File.open(file_path, "wb") { |f| f.write(image_data) }
        label_annotations = GoogleCloud::ImageAnnotatorService.new(file_path).call!
        FileUtils.rm(file_path)
        render status: :ok, json: { labels: label_annotations }
      rescue StandardError => error
        Rails.logger.error error
        render status: :unprocessable_entity
      end
    end
  end
end
