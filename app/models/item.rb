class Item < ApplicationRecord
  validates :name, presence: true, length: { maximum: 10 }

  belongs_to :user

end
