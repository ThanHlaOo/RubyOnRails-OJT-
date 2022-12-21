class Post < ApplicationRecord
    belongs_to :user, foreign_key: "create_user_id"
    belongs_to :user, foreign_key: "updated_user_id"
    # belongs_to :create_user_id, class_name: 'User'
    # belongs_to :updated_user_id, class_name: 'User'
    validates :title, presence: true
    validates :description, presence: true, length: { maximum: 255 }
    #def errors.full_message(attribute, message)
    #    if attribute == :name
    #      "Name #{message}"
    #    else
    #      super
    #    end
    #end
end
