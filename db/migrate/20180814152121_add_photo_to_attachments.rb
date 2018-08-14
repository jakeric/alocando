class AddPhotoToAttachments < ActiveRecord::Migration[5.2]
  def change
    add_column :attachments, :photo, :string
  end
end
