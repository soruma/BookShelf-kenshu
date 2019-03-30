class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :author_id, foreign_key: true

      t.timestamps
    end

    add_index :books, :author_id
  end
end
