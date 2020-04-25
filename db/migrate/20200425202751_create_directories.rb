class CreateDirectories < ActiveRecord::Migration[5.2]
  def change
    create_table :directories do |t|
      t.string :title
      t.integer :parent_directory_id

      t.timestamps
    end
  end
end
