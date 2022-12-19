class Post < ApplicationRecord
    belongs_to :user, foreign_key: "create_user_id"
    validates :title, presence: true
    validates :description, presence: true, length: { maximum: 255 }
end
