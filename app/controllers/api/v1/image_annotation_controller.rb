# frozen_string_literal: true

module Api
	module V1
		class ImageAnnotationController < ApplicationController
			def show
				label_annotations = GoogleCloud::ImageAnnotatorService.new("./bag.jpg").call!
				render status: :ok, json: { labels: label_annotations }
			rescue StandardError => error
				Rails.logger.error error
				render status: :unprocessable_entity
			end
		end
	end
end