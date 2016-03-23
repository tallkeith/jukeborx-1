class CreateSongs < ActiveRecord::Migration
  def up
    create_table :songs do |t|
      t.string :artist
      t.string :album
      t.string :title
      t.integer :year
    end
  end

  def down
    drop_table :songs
  end
end
