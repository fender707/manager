class AddUserIdToDirectories < ActiveRecord::Migration[5.2]
  def change
    add_reference :directories, :user
  end
end
