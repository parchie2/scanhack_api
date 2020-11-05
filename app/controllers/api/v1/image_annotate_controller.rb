# frozen_string_literal: true

module Api
  module V1
    class ImageAnnotateController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      def show
        image_data = Base64.urlsafe_decode64(params["base64"])
        file_path = "tmp/current_user"
        File.open(file_path, "wb") { |f| f.write(image_data) }
        label_annotations = GoogleCloud::ImageAnnotatorService.new(file_path).call!
        FileUtils.rm(file_path)
        synonyms = []
        logger.debug("label_annotationslabel_annotationslabel_annotationslabel_annotationslabel_annotationslabel_annotationslabel_annotations")
        logger.debug(label_annotations)
        label_annotations.each do |label_annotation|
          logger.debug("single_label_annotationsingle_label_annotationsingle_label_annotationsingle_label_annotationsingle_label_annotationsing")
          logger.debug(label_annotation)
  
          synonyms << RapidApi::SynonymProviderService.new(label_annotation).call!
          synonyms.push(label_annotation)
          # if not exit synonyms
          rescue StandardError => error
            synonyms << []
            synonyms.push(label_annotation)
        end
        logger.debug("current_send_usercurrent_send_usercurrent_send_usercurrent_send_usercurrent_send_usercurrent_send_usercurrent_send_usercurrent_send_usercurrent_send_user")
        logger.debug(current_send_user)
        logger.debug("current_send_user.itemscurrent_send_user.itemscurrent_send_user.itemscurrent_send_user.itemscurrent_send_user.itemscurrent_send_user.itemscurrent_send_user")
        logger.debug(current_send_user.items)
        logger.debug("synonymssynonymssynonymssynonymssynonymssynonymssynonymssynonymssynonymssynonymssynonymssynonymssynonymssynonymssynonymssynonymssynonyms")
        logger.debug(synonyms)
        down_syonyms = synonyms.flatten.map(&:downcase)
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
