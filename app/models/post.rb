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
    def self.to_csv
        # Generate the CSV header row
        header_row = ["id", "Title", "Description", "Status", "Create_User ID", "Updated User ID", "Deleted_User_ID", "Deleted_AT", "Created_at", "Updated_at"]
    
        # Create a CSV object
        csv = CSV.generate do |csv|
          # Add the header row to the CSV
          csv << header_row
    
          # Add the data rows to the CSV
          all.each do |post|
            csv << [post.id, post.title, post.description, post.status, post.create_user_id, post.updated_user_id, post.deleted_user_id, post.deleted_at, post.created_at, post.updated_at]
          end
        end
    
        # Return the CSV string
        csv
      end
end
