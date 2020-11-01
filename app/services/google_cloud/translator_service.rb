# frozen_string_literal: true

require "google/cloud/translate"

module GoogleCloud
  class TranslatorService
    def initialize(contents)
      @contents = contents
    end

    def call!
      client = Google::Cloud::Translate.translation_service

      parent = client.location_path project: "scanhack", location: "global"

      response = client.translate_text(parent: parent, contents: @contents, target_language_code: "en")

      translations = []
      response.translations.each do |translation|
        translations.push(translation.translated_text)
      end
      translations
    end
  end
end
