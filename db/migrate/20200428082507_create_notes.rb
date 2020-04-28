class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.string :title
      t.references :directory, foreign_key: true
      t.references :user, foreign_key: true

      t.integer :position
      t.string :description
      t.jsonb :tags, default: []

      t.timestamps
    end
  end
end
