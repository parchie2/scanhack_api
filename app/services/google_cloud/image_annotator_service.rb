# frozen_string_literal: true

# Imports the Google Cloud client library
require "google/cloud/vision"

module GoogleCloud
  class ImageAnnotatorService
    def initialize(file_name)
      @file_name = file_name
    end

    def call!
      # Instantiates a client
      image_annotator = Google::Cloud::Vision.image_annotator

      # Performs label detection on the image file
      labels = []
      response = image_annotator.label_detection image: @file_name
      response.responses.each do |res|
        res.label_annotations.each do |label|
          labels.push(label.description)
        end
      end
      labels
    end
  end
end
