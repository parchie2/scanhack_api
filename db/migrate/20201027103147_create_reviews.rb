# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.text       :description, null: false
      t.integer    :point,       null: false
      t.integer    :jan_code,    null: false
      t.references :user,        null: false, foreign_key: true

      t.timestamps
    end
  end
end
